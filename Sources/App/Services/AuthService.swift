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
    /// Creates a new account, saves it to the database, then returns a valid long session
    /// for this user.
    ///
    /// - Parameters:
    ///   - req: a Vapor `Request` object
    ///   - registerForm: a Data Transfer Object containing the necessary details to make an account
    /// - Returns: a `Session.ClientPackage` object
    /// - Throws: when a new account fails to be created for any reason, or when a session fails to be created
    static func register(via req: Request, with registerForm: Account.RegisterForm) async throws -> Session.ClientPackage {
        let newAccount = try Account(formData: registerForm)
        try await newAccount.save(on: req.db)
        return try await createSession(for: newAccount, via: req, session: true)
    }

    /// Logs in an existing user by first verifying that the account exists, then verifying the password
    /// matches our records.
    ///
    /// - Parameters:
    ///   - req: a Vapor `Request` object
    ///   - loginForm: a Data Transfer Object containing the necessary details to log in
    /// - Returns: a `Session.ClientPackage` object
    /// - Throws: if login fails for any reason, or if creating a session fails for any reason
    static func login(via req: Request, with loginForm: Account.LoginForm) async throws -> Session.ClientPackage {
        guard let existingAccount = try await Account.query(on: req.db).filter(\.$email == loginForm.email).first() else {
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
            return try await createSession(for: existingAccount, via: req, session: loginForm.rememberMe)
        } else {
            throw Abort(.notFound)
        }
    }

    /// Logs out a user and erases any `accessKey`. Any cookie erasure should happen on the client,
    /// but we check if the `accessKey` cookie exists anyway.
    ///
    /// - Parameters:
    ///   - req:
    ///   - res:
    /// - Returns:
    /// - Throws:
    static func logout(via req: Request, with res: Response) async throws -> Response {
        guard let existingToken = req.cookies["accessKey"] else {
            res.status = .ok
            return res
        }

        guard let verifiedToken = try? req.jwt.verify(existingToken.string, as: Session.TokenPayload.self) else {
            throw Abort(.badRequest)
        }

        guard let account = try await Account.find(verifiedToken.accountId, on: req.db) else {
            throw Abort(.notFound)
        }

        try await account.$sessions.query(on: req.db).filter(\.$id == verifiedToken.accessKey).delete()
        res.status = .ok
        return res
    }

    /// Creates a new session for the specified account, saving it to the database.
    ///
    /// - Parameters:
    ///   - account: the account requesting a new session
    ///   - req: a Vapor `Request` object
    ///   - session: determines whether or not to create a short or a long session
    /// - Returns: a new `ClientPackage`
    /// - Throws: when a new session fails to be created, or when signing the JWT fails
    private static func createSession(for account: Account, via req: Request, session: Bool) async throws -> Session.ClientPackage {
        let sessionId = UUID()
        let expiration = session
            ? Date(timeInterval: 60.0 * 60.0 * 24.0 * 30.0, since: .now)
            : Date(timeInterval: 60.0 * 60.0 * 24.0, since: .now)
        let newSession = Session(id: sessionId, via: getUserAgent(from: req), expires: expiration)
        try await account.$sessions.create(newSession, on: req.db)

        let token = try req.jwt.sign(
            Session.TokenPayload(
                subject: "offprint",
                expiration: .init(value: expiration),
                accountId: account.id,
                accessKey: sessionId
            )
        )

        try await account.$profiles.load(on: req.db)
        return Session.ClientPackage(account: .init(from: account), profiles: account.profiles , token: token)
    }

    /// Gets the user agent from request headers.
    ///
    /// - Parameter req: a Vapor `Request` object
    /// - Returns: an instance of `Session.DeviceInfo`
    private static func getUserAgent(from req: Request) -> Session.DeviceInfo {
        let parsedInfo = UAParser(agent: req.headers.first(name: .userAgent).unsafelyUnwrapped)
        return Session.DeviceInfo(
            browserName: parsedInfo.browser?.name ?? "unknown name",
            browserVer: parsedInfo.browser?.version ?? "unknown version",
            ipAddr: req.remoteAddress?.ipAddress ?? "unknown",
            osName: parsedInfo.os?.name ?? "unknown name",
            osVer: parsedInfo.os?.version ?? "unknown version"
        )
    }
}
