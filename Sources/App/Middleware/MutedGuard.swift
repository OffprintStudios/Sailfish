//
// Created by Alyx Mote on 12/4/22.
//

import Vapor
import Fluent

/// Checks to see if a user has been muted. To be used after `IdentityGuard` but before `BannedGuard`.
struct MutedGuard: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let account = try request.authService.getUser().account
        guard let isMuted: AccountMute = try await AccountMute.query(on: request.db).filter(\.$account.$id == account.id!).first() else {
            return try await next.respond(to: request)
        }
        if isMuted.expiresOn < Date() {
            return try await next.respond(to: request)
        }
        throw Abort(.forbidden, reason: "Your account has been muted and cannot perform this action right now.")
    }
}
