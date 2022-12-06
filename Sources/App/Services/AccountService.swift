//
// Created by Alyx Mote on 7/29/22.
//

import Foundation
import Vapor
import Fluent
import SwiftSoup

/// Offprint Account Service
///
/// Contains functions dedicated to the processing of account-related requests, such as
/// information updates, profile creation, and more.
struct AccountService {
    let request: Request

    /// Fetches a user's profile by its ID
    func fetchProfile(_ id: String) async throws -> Profile {
        let account = try request.authService.getUser().account
        guard let profile = try await account.$profiles.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Could not find the specified profile.")
        }
        return profile
    }

    /// Fetches all profiles belonging to a user
    func fetchProfiles() async throws -> [Profile] {
        let account = try request.authService.getUser().account
        return try await account.$profiles.get(on: request.db)
    }

    /// Creates a new profile for a user
    func createProfile(with profileForm: Profile.ProfileForm) async throws -> Profile {
        let account = try request.authService.getUser().account
        let existingUser = try await Profile.query(on: request.db).filter(\.$username == profileForm.username).first()
        
        if existingUser != nil {
            throw Abort(.conflict, reason: "This username has already been taken.")
        }
        
        try await account.$profiles.load(on: request.db)
        if account.profiles.count == MAX_PROFILE_LIMIT {
            throw Abort(.conflict, reason: "Only \(MAX_PROFILE_LIMIT) profiles are allowed per account.")
        }
        
        let newProfile = try Profile(from: profileForm)
        try await account.$profiles.create(newProfile, on: request.db)
        return newProfile
    }

    /// Updates an existing profile
    func updateProfile(_ id: String, with profileForm: Profile.ProfileForm) async throws -> Profile {
        let account = try request.authService.getUser().account
        guard let profile: Profile = try await account.$profiles.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Could not find profile you wish to update.")
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

    /// Soft-deletes a given profile
    func deleteProfile(_ id: String) async throws {
        let account = try request.authService.getUser().account
        try await account.$profiles.query(on: request.db).filter(\.$id == id).delete()
    }
}

extension Request {
    var accountService: AccountService {
        .init(request: self)
    }
}
