//
//  AccountController.swift
//
//
//  Created by Alyx Mote on 12/1/23.
//

import Vapor
import Fluent

struct AccountController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let accounts = routes.grouped("accounts")
        let secure = accounts.grouped(SessionToken.authenticator(), SessionToken.guardMiddleware(), IdentityGuard(needs: [.user]))
        let secureProfiles = secure.grouped("profiles")
        
        secureProfiles.get("fetch") { request async throws -> [ProfileView] in
            guard let account = request.user?.account else {
                throw Abort(.unauthorized, reason: "You don't have permission to do that.")
            }

            return try await account.$profiles.get(on: request.db)
        }
        
        secureProfiles.post("create") { request async throws -> ProfileView in
            guard let account = request.user?.account else {
                throw Abort(.unauthorized, reason: "You don't have permission to do that.")
            }
            
            let profiles = try await account.$profilesRaw.get(on: request.db)
            if profiles.count == 3 {
                throw Abort(.forbidden, reason: "Accounts can only have a maximum of 3 profiles.")
            }
            
            try Profile.FormInfo.validate(content: request)
            let formInfo = try request.content.decode(Profile.FormInfo.self)
            let newProfile = Profile(from: formInfo)
            try await account.$profilesRaw.create(newProfile, on: request.db)
            
            return try await account.$profiles.query(on: request.db).filter(\.$id == newProfile.requireID()).first()!
        }
    }
}

extension AccountController {
    // all data transfer objects go here
    
    struct FetchProfilesDTO: Content {
        var profiles: [ProfileView]
    }
}
