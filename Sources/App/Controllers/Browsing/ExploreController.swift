//
//  Created by Alyx Mote on 12/27/22.
//

import Vapor
import Fluent

struct ExploreController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let explore = routes.grouped("explore")
        
        explore.get("new-works") { request async throws -> Page<Work> in
            let query = try request.query.decode(FetchFilter.self)
            return try await request.exploreService.fetchNewWorks(filter: query.filter ?? .restricted)
        }
        
        explore.get("updated-works") { request async throws -> Page<Work> in
            let query = try request.query.decode(FetchFilter.self)
            return try await request.exploreService.fetchUpdatedWorks(filter: query.filter ?? .restricted)
        }
        
        explore.get("genres") { request async throws -> [TagService.FetchTag] in
            return try await request.exploreService.fetchGenres()
        }
        
        explore.get("fandoms") { request async throws -> [TagService.FetchTag] in
            return try await request.exploreService.fetchFandoms()
        }
        
        explore.get("top-tags") { request async throws -> [Tag.TopTag] in
            let query = try request.query.decode(FetchFilter.self)
            if let tagKind = query.tagKind {
                return try await request.exploreService.fetchTopTags(kind: tagKind)
            }
            throw Abort(.badRequest, reason: "You must include the tag kind in this request.")
        }
        
        explore.get("works-by-tag") { request async throws -> Page<Work> in
            let query = try request.query.decode(FetchFilter.self)
            if let id = query.tagId {
                return try await request.exploreService.fetchWorksByTag(tagId: id, filter: query.filter ?? .restricted)
            }
            throw Abort(.badRequest, reason: "You must include a tag ID in this request.")
        }
    }
}

extension ExploreController {
    struct FetchFilter: Content {
        var tagId: String?
        var tagKind: Tag.Kind?
        var filter: ContentFilter?
    }
}
