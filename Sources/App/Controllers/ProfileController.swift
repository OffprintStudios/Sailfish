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
        let profiles = routes.grouped("profiles").grouped(":id")
        
        profiles.get() { request async throws -> ProfileView in
            let id = request.parameters.get("id")!
            guard let profile = try await ProfileView.find(id, on: request.db) else {
                throw Abort(.notFound, reason: "The profile your looking for cannot be found.")
            }
            return profile
        }

        profiles.get("blogs") { request async throws -> Page<BlogView> in
            let id = request.parameters.get("id")!
            return try await BlogView.query(on: request.db)
                .filter(\.$author.$id == id)
                .filter(\.$publishedOn != nil)
                .sort(\.$publishedOn, .descending)
                .paginate(for: request)
        }

        profiles.get("works") { request async throws -> String in 
            return "hello"
        }
    }
}

extension ProfileController {
    // all data transfer objects go here
}

