//
//  Created by Alyx Mote on 1/3/23.
//

import Vapor
import Fluent

struct SearchController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let search = routes.grouped("search")
        
        search.get("works") { request async throws -> Page<Work> in
            let query = try request.query.decode(SearchQuery.self)
            print(query)
            return try await request.searchService.findRelatedWorks(
                title: query.title,
                author: query.username,
                categories: query.categories,
                filter: query.filter ?? .restricted
            )
        }
        
        search.get("blogs") { request async throws -> Page<Blog> in
            let query = try request.query.decode(SearchQuery.self)
            print(query)
            return try await request.searchService.findRelatedBlogs(
                title: query.title,
                author: query.username,
                filter: query.filter ?? .restricted
            )
        }
        
        search.get("users") { request async throws -> Page<ClientProfile> in
            let query = try request.query.decode(SearchQuery.self)
            return try await request.searchService.findRelatedProfiles(username: query.username)
        }
    }
}

extension SearchController {
    struct SearchQuery: Content {
        var title: String?
        var username: String?
        var categories: [Work.Category]?
        var filter: ContentFilter?
    }
}
