//
// Created by Alyx Mote on 12/4/22.
//

import Vapor
import Fluent

/// Checks to see if a user has been banned. To be used after `IdentityGuard` and `MutedGuard`.
struct BannedGuard: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let account = try request.authService.getUser().account else {
            throw Abort(.internalServerError, reason: "Could not process your account. Try again in a little bit.")
        }
        guard let isBanned: AccountBan = try await AccountBan.query(on: request.db).filter(\.$account.$id == account.id!).first() else {
            return try await next.respond(to: request)
        }
        guard let duration = isBanned.expiresOn else {
            throw Abort(.forbidden, reason: "Your account has been banned.")
        }
        if duration < Date() {
            return try await next.respond(to: request)
        }
        throw Abort(.forbidden, reason: "Your account has been banned.")
    }
}
