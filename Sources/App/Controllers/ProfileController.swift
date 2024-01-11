//
//  ProfileController.swift
//
//
//  Created by Alyx Mote on 12/2/23.
//

import Vapor
import Fluent

struct ProfileController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let profiles = routes.grouped("profiles")
        let secure = profiles.grouped(SessionToken.authenticator(), SessionToken.guardMiddleware(), IdentityGuard(needs: [.user]))
        
        profiles.get(":id") { request async throws -> ProfileView in
            let id = request.parameters.get("id")!
            guard let profile = try await ProfileView.find(id, on: request.db) else {
                throw Abort(.notFound, reason: "The profile your looking for cannot be found.")
            }
            return profile
        }
    }
}

extension ProfileController {
    // all data transfer objects go here
}

