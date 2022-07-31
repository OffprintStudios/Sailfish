//
// Created by Alyx Mote on 7/29/22.
//

import Foundation
import Vapor
import Fluent

struct AccountService {
    let request: Request

    func fetchProfile(id: UUID) async throws -> Profile {
        let account = try request.authService.getUser().account
        guard let profile = try await account.$profiles.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound)
        }
        return profile
    }

    func fetchProfiles() async throws -> [Profile] {
        let account = try request.authService.getUser().account
        return try await account.$profiles.get(on: request.db)
    }

    func createProfile(with profileForm: Profile.ProfileForm) async throws -> Profile {
        let account = try request.authService.getUser().account
        let newProfile = Profile(from: profileForm)
        try await account.$profiles.create(newProfile, on: request.db)
        return newProfile
    }

    func updateProfile(_ id: UUID, with profileForm: Profile.ProfileForm) async throws -> Profile {
        let account = try request.authService.getUser().account
        guard let profile = try await account.$profiles.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound)
        }

        profile.username = profileForm.username
        profile.info.pronouns = profileForm.pronouns
        profile.info.presence = profileForm.presence

        if let bio = profileForm.bio {
            profile.info.bio = bio
        }

        if let tagline = profileForm.tagline {
            profile.info.tagline = tagline
        }

        try await profile.save(on: request.db)
        return profile
    }

    func deleteProfile(_ id: UUID) async throws {
        let account = try request.authService.getUser().account
        try await account.$profiles.query(on: request.db).filter(\.$id == id).delete()
    }
}

extension Request {
    var accountService: AccountService {
        .init(request: self)
    }
}
