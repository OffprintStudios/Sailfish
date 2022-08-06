//
// Created by Alyx Mote on 8/5/22.
//

import Vapor
import Fluent

struct ProfileController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let profiles = routes.grouped("profiles")

        profiles.get("fetch-profile", ":profileId") { request async throws -> Profile in
            let profileId = request.parameters.get("profileId")!
            return try await request.profileService.fetchProfile(profileId)
        }
    }
}
