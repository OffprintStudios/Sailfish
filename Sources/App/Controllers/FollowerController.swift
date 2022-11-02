//
//  Created by Alyx Mote on 10/31/22.
//

import Vapor
import Fluent

struct FollowerController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let followers = routes.grouped("followers")
        let followersWithAuth = followers.grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            StatusGuard()
        ])

        followers.get("fetch-followers", ":id") { request async throws -> Page<Follower> in
            let profileId = request.parameters.get("id")!
            return try await request.followerService.fetchFollowers(profileId)
        }

        followers.get("fetch-following", ":id") { request async throws -> Page<Follower> in
            let profileId = request.parameters.get("id")!
            return try await request.followerService.fetchFollowing(profileId)
        }

        followersWithAuth.get("check-if-following", ":id") { request async throws -> Follower in
            let profileId = request.parameters.get("id")!
            return try await request.followerService.checkIfFollowing(profileId)
        }

        followersWithAuth.post("follow-user", ":id") { request async throws -> Follower in
            let profileId = request.parameters.get("id")!
            return try await request.followerService.followUser(profileId)
        }

        followersWithAuth.delete("unfollow-user", ":id") { request async throws -> Response in
            let profileId = request.parameters.get("id")!
            try await request.followerService.unfollowUser(profileId)
            return .init(status: .ok)
        }
    }
}
