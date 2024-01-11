//
//  IdentityGuard.swift
//
//
//  Created by Alyx Mote on 10/29/23.
//

import Vapor
import Fluent

struct IdentityGuard: AsyncMiddleware {
    var requiredRoles: [Account.Roles]
    var checkProfile: Bool
    
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let sessionToken = try request.auth.require(SessionToken.self)
        
        guard let account = try await Account.find(sessionToken.accountId, on: request.db) else {
            throw Abort(.internalServerError, reason: "Something went wrong validating your access!")
        }
        
        if canAccess(needs: requiredRoles, has: account.roles) {
            if checkProfile == true {
                guard let profileId: String = request.query["profileId"] else {
                    throw Abort(.badRequest, reason: "You must include a profile ID with this request!")
                }
                
                guard let profile = try? await account.$profilesRaw.query(on: request.db).filter(\.$id == profileId).first() else {
                    request.logger.error("Could not validate provided profile ID. Are you sure it really belongs to Account \(account.id?.uuidString ?? "NULL_ID")?")
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
    
    init(needs requiredRoles: [Account.Roles], checkProfile: Bool = false) {
        self.requiredRoles = requiredRoles
        self.checkProfile = checkProfile
    }
}
