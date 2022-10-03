//
// Created by Alyx Mote on 9/3/22.
//

import Vapor

struct SessionController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let sessions = routes.grouped("sessions").grouped(IdentityGuard(needs: [.user]))

        sessions.get("fetch-sessions") { request async throws -> [Session] in
            try await request.sessionService.fetchSessions()
        }

        sessions.grouped(StatusGuard()).delete("delete-session", ":sessionId") { request async throws -> Response in
            let sessionId = request.parameters.get("sessionId", as: UUID.self)!
            try await request.sessionService.deleteSession(sessionId)
            return Response(status: .ok)
        }
    }
}
