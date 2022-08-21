//
// Created by Alyx Mote on 7/21/22.
//

import Foundation
import Vapor
import Fluent
import Argon2Swift
import UAParserSwift

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
        return try await createSession(for: newAccount, session: true)
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
            return try await createSession(for: existingAccount, session: loginForm.rememberMe)
        } else {
            throw Abort(.notFound)
        }
    }

    /// Logs out a user and erases their session. Any cookie erasure should happen on the client,
    /// so we only check to see if the `Authorization` header has been passed one final time.
    ///
    /// - Throws:
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

    /// Creates a new session for the specified account, saving it to the database.
    ///
    /// - Throws: when a new session fails to be created, or when signing the JWT fails
    private func createSession(for account: Account, session: Bool) async throws -> Session.ClientPackage {
        let sessionId = UUID()
        let expiration = session
            ? Date(timeInterval: LONG_SESSION, since: .now)
            : Date(timeInterval: SHORT_SESSION, since: .now)
        let newSession = Session(id: sessionId, via: getUserAgent(), expires: expiration)
        try await account.$sessions.create(newSession, on: request.db)

        let token = try request.jwt.sign(
            Session.TokenPayload(
                subject: "offprint",
                expiration: .init(value: expiration),
                accountId: account.id,
                accessKey: sessionId
            )
        )

        let profiles = try await account.$profiles.get(on: request.db)

        return Session.ClientPackage(account: .init(from: account), profiles: profiles, token: token)
    }

    /// Gets the user agent from request headers and returns a `DeviceInfo` object containing browser, ip address, and
    /// operating system information.
    private func getUserAgent() -> Session.DeviceInfo {
        let parsedInfo = UAParser(agent: request.headers.first(name: .userAgent).unsafelyUnwrapped)
        return Session.DeviceInfo(
            browserName: parsedInfo.browser?.name ?? "unknown name",
            browserVer: parsedInfo.browser?.version ?? "unknown version",
            ipAddr: request.remoteAddress?.ipAddress ?? "unknown",
            osName: parsedInfo.os?.name ?? "unknown name",
            osVer: parsedInfo.os?.version ?? "unknown version"
        )
    }
}

extension Request {
    var authService: AuthService {
        .init(request: self)
    }
}
