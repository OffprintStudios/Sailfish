//
// Created by Alyx Mote on 8/24/22.
//

import Vapor
import Fluent

struct NewsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let news = routes.grouped("news")
        let newsWithAuth = news.grouped([
            IdentityGuard(needs: [.admin, .moderator, .contributor], checkProfile: true),
            StatusGuard()
        ])

        news.get("fetch-posts") { request async throws -> Page<Blog> in
            try await request.blogService.fetchNews()
        }

        newsWithAuth.patch("convert-to-news-post", ":blogId") { request async throws -> Blog in
            let blogId = request.parameters.get("blogId")!
            return try await request.blogService.convertToNewsPost(blogId)
        }
    }
}
