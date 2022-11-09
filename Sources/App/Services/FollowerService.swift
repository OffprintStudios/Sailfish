//
// Created by Alyx Mote on 10/31/22.
//

import Vapor
import Fluent

struct FollowerService {
    let request: Request
    
    func fetchFollowers(_ id: String) async throws -> Page<Follower> {
        try await Follower.query(on: request.db)
            .with(\.$profile)
            .with(\.$subscribedTo)
            .filter(\.$subscribedTo.$id == id)
            .paginate(for: request)
    }
    
    func fetchFollowing(_ id: String) async throws -> Page<Follower> {
        try await Follower.query(on: request.db)
            .with(\.$profile)
            .with(\.$subscribedTo)
            .filter(\.$profile.$id == id)
            .paginate(for: request)
    }
    
    func checkIfFollowing(_ id: String) async throws -> Follower {
        let profile = try request.authService.getUser(withProfile: true).profile!
        if let hasFollowed = try await Follower.query(on: request.db)
            .filter(\.$profile.$id == profile.id!)
            .filter(\.$subscribedTo.$id == id)
            .first() {
            return hasFollowed
        } else {
            throw Abort(.notFound, reason: "No follow detected.")
        }
    }

    func followUser(_ id: String) async throws -> Follower {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let following = try await Profile.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "The user you're trying to follow doesn't exist.")
        }
        if try await Follower.query(on: request.db)
            .filter(\.$subscribedTo.$id == following.id!)
            .filter(\.$profile.$id == profile.id!)
            .first() != nil {
                throw Abort(.forbidden, reason: "You're already following this user.")
            }

        return try await request.db.transaction { database in
            let newFollow = Follower(follow: following.id!, for: profile.id!)
            try await newFollow.save(on: database)
            profile.stats.following += 1
            following.stats.followers += 1
            try await profile.save(on: database)
            try await following.save(on: database)
            return newFollow
        }
    }

    func unfollowUser(_ id: String) async throws {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let following = try await Profile.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "The user you're trying to follow doesn't exist.")
        }
        if let existingFollow = try await Follower.query(on: request.db)
            .filter(\.$subscribedTo.$id == following.id!)
            .filter(\.$profile.$id == profile.id!)
            .first() {
            try await request.db.transaction { database in
                try await existingFollow.delete(on: database)
                profile.stats.following -= 1
                following.stats.followers -= 1
                try await profile.save(on: database)
                try await following.save(on: database)
            }
        } else {
            throw Abort(.notFound, reason: "You're currently not following this user, so there's nothing to unfollow.")
        }
    }
}

extension Request {
    var followerService: FollowerService {
        .init(request: self)
    }
}
