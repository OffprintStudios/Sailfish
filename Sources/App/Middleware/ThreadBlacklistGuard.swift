//
// Created by Alyx Mote on 10/30/22.
//

import Vapor
import Fluent


/// Checks to see if the user attempting to post a comment to a thread is
/// currently blacklisted. Use only on comment threads, and only after all other
/// guards.
struct ThreadBlacklistGuard: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let profile = try request.authService.getUser(withProfile: true).profile!
        let formInfo = try request.content.decode(Comment.CommentForm.self)

        let blacklisted = try await ThreadBlacklist.query(on: request.db)
            .filter(\.$thread.$id == formInfo.threadId)
            .filter(\.$profile.$id == profile.id!)
            .first()

        if blacklisted != nil {
            throw Abort(.forbidden, reason: "You are blacklisted from posting in this thread.")
        } else {
            return try await next.respond(to: request)
        }
    }
}
