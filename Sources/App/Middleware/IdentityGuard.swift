//
// Created by Alyx Mote on 7/29/22.
//

import Vapor
import Fluent

struct IdentityGuard: AsyncMiddleware {
    var requiredRoles: Set<Account.Roles>
    var checkProfile: Bool

    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let payload = try? request.jwt.verify(as: Session.TokenPayload.self) else {
            request.logger.warning("Someone tried to pass off as a verified user!")
            throw Abort(.unauthorized)
        }

        guard let account = try await Account.find(payload.accountId, on: request.db) else {
            throw Abort(.internalServerError)
        }

        if canAccess(needs: requiredRoles, has: Set(account.roles)) {
            if checkProfile {
                guard let profileId: String = request.query["profileId"] else {
                    throw Abort(.badRequest)
                }

                guard let profileUuid = UUID(uuidString: profileId) else {
                    throw Abort(.internalServerError)
                }

                guard let profile: Profile = try? await account.$profiles.query(on: request.db).filter(\.$id == profileUuid).first() else {
                    request.logger.error("Could not validate provided profile ID. Does it really belong to Account \(account.id?.uuidString ?? "NULL_ID")?")
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

    init(needs requiredRoles: [Account.Roles], checkProfile: Bool = true) {
        self.requiredRoles = Set(requiredRoles)
        self.checkProfile = checkProfile
    }
}