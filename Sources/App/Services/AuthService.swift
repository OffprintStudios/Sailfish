//
// Created by Alyx Mote on 7/21/22.
//

import Foundation
import Vapor
import Fluent
import Argon2Swift

/// Offprint Authorization Service
///
/// Contains functions dedicated to the processing of authorization requests.
struct AuthService {
    let request: Request

    /// Creates a new account, saves it to the database, then returns a valid long session
    /// for this user.
    ///
    /// - Throws: when a new account fails to be created for any reason, or when a session fails to be created
    func register(with registerForm: Account.RegisterForm) async throws -> Session.ClientPackage {
        // TODO: check for invite code before account creation
        let newAccount = try Account(formData: registerForm)
        try await newAccount.save(on: request.db)
        return try await request.sessionService.createSession(for: newAccount, session: true)
    }

    /// Logs in an existing user by first verifying that the account exists, then verifying the password
    /// matches our records.
    ///
    /// - Throws: if login fails for any reason, or if creating a session fails for any reason
    func login(with loginForm: Account.LoginForm) async throws -> Session.ClientPackage {
        guard let existingAccount = try await Account.query(on: request.db).filter(\.$email == loginForm.email).first() else {
            throw Abort(.notFound)
        }

        guard let compareResult = try? Argon2Swift.verifyHashString(
            password: loginForm.password,
            hash: existingAccount.password,
            type: Argon2Type.id
        ) else {
            throw Abort(.notFound)
        }

        if compareResult == true {
            return try await request.sessionService.createSession(for: existingAccount, session: loginForm.rememberMe)
        } else {
            throw Abort(.notFound)
        }
    }

    /// Logs out a user and erases their session. Any cookie erasure should happen on the client,
    /// so we only check to see if the `Authorization` header has been passed one final time.
    func logout() async throws -> Response {
        let res = Response()

        guard let verifiedToken = try? request.jwt.verify(as: Session.TokenPayload.self) else {
            throw Abort(.badRequest)
        }

        guard let account = try await Account.find(verifiedToken.accountId, on: request.db) else {
            throw Abort(.notFound)
        }

        try await account.$sessions.query(on: request.db).filter(\.$id == verifiedToken.accessKey).delete()
        res.status = .ok
        return res
    }


    /// Retrieves a user's account from `request.user`. If `withProfile` is true, we also retrieve
    /// the associated profile. Otherwise, `profile` is `nil`
    ///
    /// - Throws: if `request.user` doesn't have either an account or a profile, or if it simply doesn't
    /// have an account
    func getUser(withProfile: Bool = false) throws -> (account: Account, profile: Profile?) {
        if withProfile {
            if let account = request.user?.account, let profile = request.user?.profile {
                return (account, profile)
            } else {
                throw Abort(.unauthorized)
            }
        } else {
            if let account = request.user?.account {
                return (account, nil)
            } else {
                throw Abort(.unauthorized)
            }
        }
    }
}

extension Request {
    var authService: AuthService {
        .init(request: self)
    }
}
