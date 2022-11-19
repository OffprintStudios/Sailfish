//
//  Created by Alyx Mote on 11/14/22.
//

import Vapor
import Fluent

struct TagController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tags = routes.grouped("tags")
        let tagsWithAuth = tags.grouped([
            IdentityGuard(needs: [.admin, .moderator]),
            StatusGuard()
        ])
        
        tags.get("fetch-tag", ":id") { request async throws -> TagService.FetchTag in
            let id = request.parameters.get("id")!
            return try await request.tagService.fetchTag(id)
        }
        
        tags.get("fetch-tags") { request async throws -> [TagService.FetchTag] in
            let query = try request.query.decode(FetchTagsQuery.self)
            if let hasKind = query.kind, let hasCounts = query.withCounts, let hasAscending = query.ascending {
                return try await request.tagService.fetchTags(kinds: [hasKind], withCounts: hasCounts, ascending: hasAscending)
            } else if let hasKind = query.kind, let hasCounts = query.withCounts {
                return try await request.tagService.fetchTags(kinds: [hasKind], withCounts: hasCounts)
            } else {
                return try await request.tagService.fetchTags(kinds: [.genre, .fandom])
            }
        }
        
        tagsWithAuth.post("create-tag") { request async throws -> Tag in
            try Tag.TagForm.validate(content: request)
            let formInfo = try request.content.decode(Tag.TagForm.self)
            return try await request.tagService.createTag(with: formInfo)
        }
        
        tagsWithAuth.patch("update-tag", ":id") { request async throws -> Tag in
            let id = request.parameters.get("id")!
            try Tag.TagForm.validate(content: request)
            let formInfo = try request.content.decode(Tag.TagForm.self)
            return try await request.tagService.updateTag(id, with: formInfo)
        }
        
        tagsWithAuth.delete("delete-tag", ":id") { request async throws -> HTTPResponseStatus in
            let id = request.parameters.get("id")!
            try await request.tagService.deleteTag(id)
            return .ok
        }
    }
}

extension TagController {
    struct FetchTagsQuery: Content {
        var kind: Tag.Kind?
        var withCounts: Bool?
        var ascending: Bool?
    }
}
