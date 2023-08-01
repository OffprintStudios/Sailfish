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
    func register(with registerForm: Account.RegisterForm) async throws -> Session.ClientPackage {
        let existingEmail = try await Account.query(on: request.db).filter(\.$email == registerForm.email).first()
        
        if existingEmail != nil {
            throw Abort(.conflict, reason: "An account with this email already exists.")
        }
        
        let newAccount = try Account(formData: registerForm)
        try await newAccount.save(on: request.db)
        try await request.auditLogService.create(newAccount.id!, reason: "Account Created")
        return try await request.sessionService.createSession(for: newAccount, rememberMe: true)
    }

    /// Logs in an existing user by first verifying that the account exists, then verifying the password
    /// matches our records.
    func login(with loginForm: Account.LoginForm) async throws -> Session.ClientPackage {
        guard let existingAccount = try await Account.query(on: request.db).filter(\.$email == loginForm.email).first() else {
            throw Abort(.notFound, reason: "Your email or password don't match our records.")
        }

        guard let compareResult = try? Argon2Swift.verifyHashString(
            password: loginForm.password,
            hash: existingAccount.password,
            type: Argon2Type.id
        ) else {
            throw Abort(.notFound, reason: "Your email or password don't match our records.")
        }

        if compareResult == true {
            return try await request.sessionService.createSession(for: existingAccount, rememberMe: loginForm.rememberMe)
        } else {
            throw Abort(.notFound, reason: "Your email or password don't match our records.")
        }
    }

    /// Logs out a user and erases their session. Any cookie erasure should happen on the client,
    /// so we only check to see if the `Authorization` header has been passed one final time.
    func logout(with info: SessionService.SessionInfo) async throws -> Response {
        guard let account = try await Account.find(info.accountId, on: request.db) else {
            throw Abort(.notFound, reason: "Something went wrong.")
        }
        if let refreshToken = info.refreshToken.fromBase64() {
            guard let id = UUID(uuidString: refreshToken) else {
                throw Abort(.internalServerError, reason: "Could not decide refresh token!")
            }
            try await account.$sessions.query(on: request.db).filter(\.$id == id).delete()
        }
        return .init(status: .ok)
    }

    /// Retrieves a user's account from `request.user`. If `withProfile` is true, we also retrieve
    /// the associated profile. Otherwise, `profile` is `nil`
    func getUser(withProfile: Bool = false) throws -> (account: Account?, profile: Profile?) {
        if request.user?.account == nil {
            return (nil, nil)
        }
        if withProfile {
            if let account = request.user?.account, let profile = request.user?.profile {
                return (account, profile)
            } else {
                throw Abort(.unauthorized, reason: "You don't have permission to do that.")
            }
        } else {
            if let account = request.user?.account {
                return (account, nil)
            } else {
                throw Abort(.unauthorized, reason: "You don't have permission to do that.")
            }
        }
    }
}

extension Request {
    var authService: AuthService {
        .init(request: self)
    }
}
