//
// Created by Alyx Mote on 7/29/22.
//

import Foundation
import Vapor
import Fluent

struct AccountService {
    let request: Request

    func fetchProfiles() async throws -> [Profile] {
        if let account = request.user?.account {
            try await account.$profiles.load(on: request.db)
            return account.profiles
        } else {
            throw Abort(.unauthorized)
        }
    }

    func createProfile(with profileForm: Profile.ProfileForm) async throws -> Profile {
        let newProfile = Profile(from: profileForm)
        try await request.user?.account.$profiles.create(newProfile, on: request.db)
        return newProfile
    }

    func updateProfile(with profileForm: Profile.ProfileForm) async throws {}

    func deleteProfile(with profileForm: Profile.ProfileForm) async throws {}
}

extension Request {
    var accountService: AccountService {
        .init(request: self)
    }
}
