//
// Created by Alyx Mote on 7/29/22.
//

import Vapor
import Fluent

/// Checks to see if the user making a request has the privileges necessary
/// to complete it. If yes, the account object is attached to the request for
/// use downstream. If not, a 401 Forbidden error is thrown.
///
/// Additionally, if the route requires a profile, this middleware will check
/// if a `profileId` has been added to the route's query parameters and fetch it
/// as is necessary. If no `profileId` is provided, however, a 401 Forbidden error
/// is thrown.
///
/// This middleware should always be used first, before any others.
struct IdentityGuard: AsyncMiddleware {
    var requiredRoles: [Account.Roles]
    var checkProfile: Bool
    var optional: Bool

    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let payload = try? request.jwt.verify(as: Session.TokenPayload.self) else {
            if optional == true {
                print("Payload Failed, Optional Routed")
                request.user = .init(account: nil, profile: nil)
                return try await next.respond(to: request)
            } else {
                request.logger.warning("Someone tried to pass off as a verified user!")
                throw Abort(.unauthorized, reason: "You aren't allowed to do that.")
            }
        }

        guard let account = try await Account.find(payload.accountId, on: request.db) else {
            throw Abort(.internalServerError, reason: "Something went wrong validating your access.")
        }

        if canAccess(needs: requiredRoles, has: account.roles) {
            if checkProfile {
                guard let profileId: String = request.query["profileId"] else {
                    throw Abort(.badRequest, reason: "You must include a profile ID with this request.")
                }

                guard let profile: Profile = try? await account.$profiles.query(on: request.db).filter(\.$id == profileId).first() else {
                    request.logger.error("Could not validate provided profile ID. Does it really belong to Account \(account.id?.uuidString ?? "NULL_ID")?")
                    throw Abort(.unauthorized, reason: "You aren't allowed to do that.")
                }

                request.user = .init(account: account, profile: profile)
            } else {
                request.user = .init(account: account, profile: nil)
            }

            return try await next.respond(to: request)
        } else {
            throw Abort(.unauthorized, reason: "You aren't allowed to do that.")
        }
    }
    
    init(needs requiredRoles: [Account.Roles], checkProfile: Bool = false, optional: Bool = false) {
        self.requiredRoles = requiredRoles
        self.checkProfile = checkProfile
        self.optional = optional
    }
}
