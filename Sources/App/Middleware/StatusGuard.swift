//
// Created by Alyx Mote on 10/3/22.
//

import Vapor
import Fluent

/// Checks to see if the user making a request hasn't either been muted or banned.
/// Defaults to checking if an account has been muted, otherwise it'll check if
/// the account has been banned.
///
/// This middleware should be used second, after the `IdentityGuard`.
struct StatusGuard: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let account = try request.authService.getUser().account

        let isMuted: AccountMute? = try await AccountMute.query(on: request.db)
            .filter(\.$account.$id == account.id!)
            .first()

        if let muted = isMuted {
            if muted.expiresOn > Date() {
                throw Abort(.methodNotAllowed, reason: "Your account cannot perform this action right now.")
            } else {
                let isBanned: AccountBan? = try await AccountBan.query(on: request.db)
                    .filter(\.$account.$id == account.id!)
                    .first()

                if let banned = isBanned {
                    if let duration = banned.expiresOn {
                        if duration > Date() {
                            throw Abort(.methodNotAllowed, reason: "Your account has been banned.")
                        } else {
                            return try await next.respond(to: request)
                        }
                    } else {
                        throw Abort(.methodNotAllowed, reason: "Your account has been banned.")
                    }
                }
                return try await next.respond(to: request)
            }
        }
        return try await next.respond(to: request)
    }
}
