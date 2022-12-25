//
// Created by Alyx Mote on 8/5/22.
//

import Vapor
import Fluent
import SwiftSoup

struct ProfileService {
    let request: Request

    /// Fetches a profile given its ID. If no profile exists, throw a `notFound` error.
    func fetchProfile(_ id: String) async throws -> ClientProfile {
        guard let profile = try await Profile.query(on: request.db)
            .filter(\.$id == id)
            .with(\.$account)
            .first() else {
            throw Abort(.notFound, reason: "Could not find profile. Are you sure it exists?")
        }
        return ClientProfile(from: profile)
    }
    
    /// Updates an existing profile
    func updateProfile(with profileForm: Profile.ProfileForm) async throws -> Profile {
        let profile = try request.authService.getUser(withProfile: true).profile!
        let existingUsername = try await Profile.query(on: request.db).filter(\.$username == profileForm.username).first()
        if let alreadyExists = existingUsername {
            if alreadyExists.id != profile.id {
                throw Abort(.conflict, reason: "The username you're trying to switch to is already taken.")
            }
        }
        profile.username = try SwiftSoup.clean(profileForm.username, .none())!
        profile.info.presence = profileForm.presence
        if let bio = profileForm.bio {
            profile.info.bio = try SwiftSoup.clean(bio, .none())!
        }
        if let tagline = profileForm.tagline {
            profile.info.tagline = try SwiftSoup.clean(tagline, .none())!
        }
        try await profile.save(on: request.db)
        return profile
    }
    
    /// Updates a profile's avatar.
    func updateAvatar(avatarUrl: String? = nil) async throws -> Profile {
        let profile = try request.authService.getUser(withProfile: true).profile!
        if let hasAvatar = avatarUrl {
            profile.avatar = hasAvatar
        } else {
            profile.avatar = "https://images.offprint.net/avatars/avatar.png"
        }
        try await profile.save(on: request.db)
        return profile
    }
    
    /// Updates a profile's banner.
    func updateBannerArt(bannerUrl: String? = nil) async throws -> Profile {
        let profile = try request.authService.getUser(withProfile: true).profile!
        profile.bannerArt = bannerUrl
        try await profile.save(on: request.db)
        return profile
    }
}

extension Request {
    var profileService: ProfileService {
        .init(request: self)
    }
}
