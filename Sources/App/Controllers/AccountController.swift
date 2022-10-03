//
// Created by Alyx Mote on 7/29/22.
//

import Vapor

struct AccountController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let accounts = routes.grouped(IdentityGuard(needs: [.user])).grouped("accounts")

        accounts.get("fetch-profile", ":profileId") { request async throws -> Profile in
            let profileId = request.parameters.get("profileId")!
            return try await request.accountService.fetchProfile(profileId)
        }

        accounts.get("fetch-profiles") { request async throws -> [Profile] in
            try await request.accountService.fetchProfiles()
        }

        accounts.grouped(StatusGuard()).post("create-profile") { request async throws -> Profile in
            try Profile.ProfileForm.validate(content: request)
            let profileForm = try request.content.decode(Profile.ProfileForm.self)
            return try await request.accountService.createProfile(with: profileForm)
        }

        accounts.grouped(StatusGuard()).patch("update-profile", ":profileId") { request async throws -> Profile in
            let profileId = request.parameters.get("profileId")!
            try Profile.ProfileForm.validate(content: request)
            let profileForm = try request.content.decode(Profile.ProfileForm.self)
            return try await request.accountService.updateProfile(profileId, with: profileForm)
        }

        accounts.grouped(StatusGuard()).delete("delete-profile", ":profileId") { request async throws -> Response in
            let profileId = request.parameters.get("profileId")!
            try await request.accountService.deleteProfile(profileId)
            return Response(status: .ok)
        }
    }
}
