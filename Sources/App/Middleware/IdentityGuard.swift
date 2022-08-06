//
// Created by Alyx Mote on 7/29/22.
//

import Vapor
import Fluent

struct IdentityGuard: AsyncMiddleware {
    var requiredRoles: [Account.Roles]
    var checkProfile: Bool

    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let payload = try? request.jwt.verify(as: Session.TokenPayload.self) else {
            request.logger.warning("Someone tried to pass off as a verified user!")
            throw Abort(.unauthorized)
        }

        guard let account = try await Account.find(payload.accountId, on: request.db) else {
            throw Abort(.internalServerError)
        }

        if canAccess(needs: requiredRoles, has: account.roles) {
            if checkProfile {
                guard let profileId: String = request.query["profileId"] else {
                    throw Abort(.badRequest)
                }

                guard let profile: Profile = try? await account.$profiles.query(on: request.db).filter(\.$id == profileId).first() else {
                    request.logger.error("Could not validate provided profile ID. Does it really belong to Account \(account.id ?? "NULL_ID")?")
                    throw Abort(.unauthorized)
                }

                request.user = .init(account: account, profile: profile)
            } else {
                request.user = .init(account: account, profile: nil)
            }

            return try await next.respond(to: request)
        } else {
            throw Abort(.unauthorized)
        }
    }

    init(needs requiredRoles: [Account.Roles], checkProfile: Bool = false) {
        self.requiredRoles = requiredRoles
        self.checkProfile = checkProfile
    }
}