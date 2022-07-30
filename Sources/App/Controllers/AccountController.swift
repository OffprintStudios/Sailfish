//
// Created by Alyx Mote on 7/29/22.
//

import Vapor

struct AccountController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let accounts = routes.grouped("accounts")

        accounts.grouped(IdentityGuard(needs: [.user])).get("fetch-profiles") { request async throws -> [Profile] in
            try await request.accountService.fetchProfiles()
        }

        accounts.grouped(IdentityGuard(needs: [.user])).post("create-profile") { request async throws -> Profile in
            try Profile.ProfileForm.validate(content: request)
            let profileForm = try request.content.decode(Profile.ProfileForm.self)
            return try await request.accountService.createProfile(with: profileForm)
        }
    }
}
