//
// Created by Alyx Mote on 8/5/22.
//

import Vapor
import Fluent

struct ProfileController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let profiles = routes.grouped("profiles")
        let profilesWithAuth = profiles.grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            ConfirmationGuard(),
            BannedGuard()
        ])

        profiles.get("fetch-profile", ":profileId") { request async throws -> ClientProfile in
            let profileId = request.parameters.get("profileId")!
            return try await request.profileService.fetchProfile(profileId)
        }
        
        profilesWithAuth.patch("update-profile") { request async throws -> Profile in
            try Profile.ProfileForm.validate(content: request)
            let profileForm = try request.content.decode(Profile.ProfileForm.self)
            return try await request.profileService.updateProfile(with: profileForm)
        }
        
        profilesWithAuth.patch("update-links") { request async throws -> Profile in
            let linksForm = try request.content.decode(Profile.ProfileLinks.self)
            return try await request.profileService.updateLinks(with: linksForm)
        }
        
        profilesWithAuth.on(.PATCH, "update-avatar", body: .collect(maxSize: "5mb")) { request async throws -> Profile in
            let profile = try request.authService.getUser(withProfile: true).profile!
            let data: UtilityService.UploadImage = try request.content.decode(UtilityService.UploadImage.self)
            let avatarUrl = try await request.utilityService.uploadImage(
                data,
                itemId: profile.id!,
                folder: "avatars"
            )
            return try await request.profileService.updateAvatar(avatarUrl: avatarUrl)
        }
        
        profilesWithAuth.on(.PATCH, "update-banner", body: .collect(maxSize: "5mb")) { request async throws -> Profile in
            let profile = try request.authService.getUser(withProfile: true).profile!
            let data: UtilityService.UploadImage = try request.content.decode(UtilityService.UploadImage.self)
            let bannerUrl = try await request.utilityService.uploadImage(
                data,
                itemId: profile.id!,
                folder: "profile-banners"
            )
            return try await request.profileService.updateBannerArt(bannerUrl: bannerUrl)
        }
    }
}
