//
// Created by Alyx Mote on 9/3/22.
//

import Foundation
import Vapor
import Fluent
import UAParserSwift

struct SessionService {
    let request: Request

/// Creates a new session for the specified account, saving it to the database.
    ///
    /// - Throws: when a new session fails to be created, or when signing the JWT fails
    func createSession(for account: Account, session: Bool) async throws -> Session.ClientPackage {
        let sessionId = UUID()
        let expiration = session
            ? Date(timeInterval: LONG_SESSION, since: Date())
            : Date(timeInterval: SHORT_SESSION, since: Date())
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

    /// Fetches sessions belonging to an account.
    func fetchSessions() async throws -> [Session] {
        let account = try request.authService.getUser().account
        return try await account.$sessions.get(on: request.db)
    }

    /// Deletes a given session via its ID.
    func deleteSession(_ id: UUID) async throws {
        let account = try request.authService.getUser().account
        return try await account.$sessions.query(on: request.db)
            .filter(\.$id == id)
            .delete()
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
    var sessionService: SessionService {
        .init(request: self)
    }
}
