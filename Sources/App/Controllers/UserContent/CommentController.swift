//
//  Created by Alyx Mote on 8/6/23.
//

import Vapor
import Fluent

struct CommentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let comments = routes.grouped("comments")
        let commentsWithAuth = routes.grouped("comments")
            .grouped([
                IdentityGuard(needs: [.user], checkProfile: true),
                ConfirmationGuard(),
                MutedGuard(),
                BannedGuard(),
            ])
        
        comments.get("fetch-history", ":id") { request async throws -> [CommentHistory] in
            let id = request.parameters.get("id")!
            return try await request.commentService.fetchHistory(id)
        }
        
        commentsWithAuth.post("upvote", ":id") { request async throws -> CommentVote in
            let id = request.parameters.get("id")!
            return try await request.commentService.adjustVote(id, rating: .liked)
        }
        
        commentsWithAuth.post("downvote", ":id") { request async throws -> CommentVote in
            let id = request.parameters.get("id")!
            return try await request.commentService.adjustVote(id, rating: .disliked)
        }
        
        commentsWithAuth.delete("remove-vote", ":id") { request async throws -> HTTPResponseStatus in
            let id = request.parameters.get("id")!
            return try await request.commentService.removeVote(id)
        }
    }
}
