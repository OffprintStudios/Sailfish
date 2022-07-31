//
// Created by Alyx Mote on 7/29/22.
//

import Vapor

struct AccountController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let accounts = routes.grouped(IdentityGuard(needs: [.user])).grouped("accounts")

        accounts.get("fetch-profile", ":profileId") { request async throws -> Profile in
            guard let profileUuid = UUID(uuidString: request.parameters.get("profileId")!) else {
                throw Abort(.internalServerError)
            }
            return try await request.accountService.fetchProfile(id: profileUuid)
        }

        accounts.get("fetch-profiles") { request async throws -> [Profile] in
            try await request.accountService.fetchProfiles()
        }

        accounts.post("create-profile") { request async throws -> Profile in
            try Profile.ProfileForm.validate(content: request)
            let profileForm = try request.content.decode(Profile.ProfileForm.self)
            return try await request.accountService.createProfile(with: profileForm)
        }

        accounts.patch("update-profile", ":profileId") { request async throws -> Profile in
            guard let profileUuid = UUID(uuidString: request.parameters.get("profileId")!) else {
                throw Abort(.internalServerError)
            }
            try Profile.ProfileForm.validate(content: request)
            let profileForm = try request.content.decode(Profile.ProfileForm.self)
            return try await request.accountService.updateProfile(profileUuid, with: profileForm)
        }

        accounts.delete("delete-profile", ":profileId") { request async throws -> String in
            guard let profileUuid = UUID(uuidString: request.parameters.get("profileId")!) else {
                throw Abort(.internalServerError)
            }
            try await request.accountService.deleteProfile(profileUuid)
            return "Ok"
        }
    }
}
