//
// Created by Alyx Mote on 9/3/22.
//

import Foundation
import Vapor
import Fluent
import UAParserSwift

struct SessionService {
    let request: Request

    /// Fetches sessions belonging to an account.
    func fetchSessions() async throws -> [Session] {
        let account = try request.authService.getUser().account
        return try await account.$sessions.get(on: request.db)
    }

    /// Creates a new session for the specified account, saving it to the database.
    func createSession(for account: Account, rememberMe: Bool) async throws -> Session.ClientPackage {
        let sessionId = UUID()
        var sessionExpiration: Date
        if rememberMe {
            sessionExpiration = .init(timeIntervalSinceNow: LONG_SESSION)
        } else {
            sessionExpiration = .init(timeIntervalSinceNow: SHORT_SESSION)
        }
        let newSession = Session(id: sessionId, via: getUserAgent(), expires: sessionExpiration)
        try await account.$sessions.create(newSession, on: request.db)

        let profiles = try await account.$profiles.get(on: request.db)
        let base64Session = sessionId.uuidString.toBase64()
        
        return Session.ClientPackage(
            account: .init(from: account),
            profiles: profiles,
            accessToken: try createAccessToken(for: account),
            refreshToken: base64Session,
            refreshExpirationTime: rememberMe ? LONG_SESSION : SHORT_SESSION
        )
    }

    /// Refreshes a user's session, returning a new `accessToken`. If the session has expired,
    /// then it returns a 401.
    func refreshSession(with info: SessionInfo) async throws -> Session.RefreshPackage {
        guard let account: Account = try await Account.find(info.accountId, on: request.db) else {
            throw Abort(.forbidden, reason: "You aren't allowed to access this function.")
        }
        
        if let idString = info.refreshToken.fromBase64() {
            guard let sessionId = UUID(uuidString: idString) else {
                throw Abort(.internalServerError, reason: GENERIC_ERROR_MESSAGE)
            }
            if try await account.$sessions.query(on: request.db)
                .filter(\.$id == sessionId)
                .filter(\.$expires > Date())
                .first() == nil {
                throw Abort(.forbidden, reason: "You aren't allowed to access this function.")
            }
            return .init(accessToken: try createAccessToken(for: account))
        } else {
            throw Abort(.internalServerError, reason: GENERIC_ERROR_MESSAGE)
        }
    }

    /// Deletes a given session via its ID.
    func deleteSession(_ id: UUID) async throws {
        let account = try request.authService.getUser().account
        return try await account.$sessions.query(on: request.db)
            .filter(\.$id == id)
            .delete()
    }
    
    /// Creates a JSON Web Token
    func createAccessToken(for account: Account, expires: Date = Date(timeIntervalSinceNow: TOKEN_EXPIRATION)) throws -> String {
        return try request.jwt.sign(Session.TokenPayload(
            subject: "offprint",
            expiration: .init(value: expires),
            accountId: account.id
        ))
    }

    /// Gets the user agent from request headers and returns a `DeviceInfo` object containing browser, ip address, and
    /// operating system information.
    private func getUserAgent() -> Session.DeviceInfo {
        let parsedInfo = UAParser(agent: request.headers.first(name: .userAgent).unsafelyUnwrapped)
        return Session.DeviceInfo(
            browserName: parsedInfo.browser?.name ?? "unknown name",
            browserVer: parsedInfo.browser?.version ?? "unknown version",
            ipAddr: request.headers.first(name: "X-Offprint-Client-IP") ?? "unknown IP",
            osName: parsedInfo.os?.name ?? "unknown name",
            osVer: parsedInfo.os?.version ?? "unknown version"
        )
    }
}

extension SessionService {
    struct SessionInfo: Content {
        var accountId: UUID
        var refreshToken: String
    }
}

extension Request {
    var sessionService: SessionService {
        .init(request: self)
    }
}
