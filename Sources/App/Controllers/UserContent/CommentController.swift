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
            MutedGuard(),
            BannedGuard(),
        ])

        commentsWithAuth.post("add-comment") { request async throws -> Comment in
            let formInfo = try request.content.decode(Comment.CommentForm.self)
            return try await request.commentService.addComment(with: formInfo)
        }

        commentsWithAuth.patch("edit-comment", ":commentId") { request async throws -> Comment in
            let commentId = request.parameters.get("commentId")!
            let formInfo = try request.content.decode(Comment.CommentForm.self)
            return try await request.commentService.editComment(commentId, with: formInfo)
        }
    }
}
