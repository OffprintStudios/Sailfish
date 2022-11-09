//
// Created by Alyx Mote on 10/26/22.
//

import Vapor
import Fluent

struct CommentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let comments = routes.grouped("comments")
        let commentsWithAuth = comments.grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            StatusGuard(),
            ThreadBlacklistGuard(),
        ])

        comments.get("fetch-content-thread", ":threadId") { request async throws -> CommentService.ThreadPage in
            let threadId = request.parameters.get("threadId")!
            return try await request.commentService.fetchOrCreateThread(threadId)
        }

        commentsWithAuth.post("add-comment") { request async throws -> Comment in
            request.logger.info("Entering route...")
            let formInfo = try request.content.decode(Comment.CommentForm.self)
            return try await request.commentService.addComment(with: formInfo)
        }

        commentsWithAuth.patch("edit-comment", ":commentId") { request async throws -> Comment in
            let commentId = request.parameters.get("commentId")!
            let formInfo = try request.content.decode(Comment.CommentForm.self)
            return try await request.commentService.editComment(commentId, with: formInfo)
        }

        commentsWithAuth.post("add-to-blacklist") { request async throws -> ThreadBlacklist in
            let formInfo = try request.content.decode(ThreadBlacklist.BlacklistForm.self)
            return try await request.commentService.addToBlacklist(from: formInfo)
        }

        commentsWithAuth.delete("remove-from-blacklist") { request async throws -> Response in
            let query = try request.query.decode(RemoveFromBlacklistQuery.self)
            try await request.commentService.removeFromBlacklist(query.blacklistId, threadId: query.threadId)
            return .init(status: .ok)
        }
    }
}

extension CommentController {
    struct RemoveFromBlacklistQuery: Content {
        var blacklistId: UUID
        var threadId: String
    }
}
