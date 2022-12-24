//
// Created by Alyx Mote on 8/24/22.
//

import Vapor
import Fluent

struct NewsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let news = routes.grouped("news")

        news.get("fetch-posts") { request async throws -> Page<Blog> in
            try await request.blogService.fetchNews()
        }
    }
}
