//
// Created by Alyx Mote on 10/31/22.
//

import Vapor
import Fluent

struct FollowerService {
    let request: Request
    
    /// Fetches a user's followers.
    func fetchFollowers(_ id: String) async throws -> Page<ClientProfile> {
        guard let profile = try await Profile.find(id, on: request.db) else {
            throw Abort(.notFound, reason: "The profile you're trying to look up doesn't exist.")
        }
        let followers = try await profile.$followers.query(on: request.db).with(\.$account).paginate(for: request)
        let clientProfiles = followers.items.map({ ClientProfile(from: $0) })
        return .init(items: clientProfiles, metadata: followers.metadata)
    }
    
    /// Fetches the profiles of people a user follows.
    func fetchFollowing(_ id: String) async throws -> Page<ClientProfile> {
        guard let profile = try await Profile.find(id, on: request.db) else {
            throw Abort(.notFound, reason: "The profile you're trying to look up doesn't exist.")
        }
        let following = try await profile.$following.query(on: request.db).with(\.$account).paginate(for: request)
        let clientProfiles = following.items.map({ ClientProfile(from: $0) })
        return .init(items: clientProfiles, metadata: following.metadata)
    }
    
    /// Checks to see if a user is following the given profile, and returns that boolean value.
    func checkIfFollowing(_ id: String) async throws -> CheckFollowing {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return .init(isFollowing: try await profile.$following.isAttached(toID: id, on: request.db))
    }

    /// Follows a user
    func followUser(_ id: String) async throws -> CheckFollowing {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let toFollow = try await Profile.find(id, on: request.db) else {
            throw Abort(.notFound, reason: "The user you're trying to follow doesn't exist.")
        }
        if try await profile.$following.isAttached(to: toFollow, on: request.db) {
            throw Abort(.conflict, reason: "You're already following this user.")
        }
        try await request.db.transaction { database in
            try await profile.$following.attach(toFollow, on: database)
            profile.stats.following += 1
            toFollow.stats.followers += 1
            try await profile.save(on: database)
            try await toFollow.save(on: database)
            
        }
        try await request.queue.dispatch(AddNotificationJob.self, .init(
            to: toFollow.id!,
            from: profile.id!,
            event: .follow,
            context: [:]
        ))
        return .init(isFollowing: true)
    }

    /// Unfollows a user.
    func unfollowUser(_ id: String) async throws -> CheckFollowing {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let toUnfollow = try await Profile.find(id, on: request.db) else {
            throw Abort(.notFound, reason: "The user you're trying to follow doesn't exist.")
        }
        try await request.db.transaction { database in
            try await profile.$following.detach(toUnfollow, on: database)
            profile.stats.following -= 1
            toUnfollow.stats.followers -= 1
            try await profile.save(on: database)
            try await toUnfollow.save(on: database)
        }
        return .init(isFollowing: false)
    }
}

extension FollowerService {
    struct CheckFollowing: Content {
        var isFollowing: Bool
    }
}

extension Request {
    var followerService: FollowerService {
        .init(request: self)
    }
}
