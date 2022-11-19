//
//  Created by Alyx Mote on 11/14/22.
//

import Foundation
import Vapor
import Fluent
import SwiftSoup

struct TagService {
    let request: Request
    
    /// Fetches a single tag via its `id`, along with any direct parent or direct children it may have.
    func fetchTag(_ id: String) async throws -> FetchTag {
        let tag = try await Tag
            .query(on: request.db)
            .filter(\.$id == id)
            .with(\.$parent)
            .with(\.$children)
            .first()
        
        if let hasTag = tag {
            let works = try await hasTag.$works.query(on: request.db).count()
            return FetchTag(tag: hasTag, works: UInt64(works))
        } else {
            throw Abort(.notFound, reason: "The tag you're looking for doesn't exist.")
        }
    }
    
    /// Fetches all tags by kind, along with the number of works per tag.
    func fetchTags(kinds: [Tag.Kind], withCounts: Bool = false, ascending: Bool = true) async throws -> [FetchTag] {
        let tags = try await Tag
            .query(on: request.db)
            .with(\.$parent)
            .filter(\.$kind ~~ kinds)
            .sort(\.$name, ascending ? .ascending : .descending)
            .all()
        
        if withCounts == true {
            var toReturn: [FetchTag] = []
            for tag in tags {
                let works = try await tag.$works.query(on: request.db).count()
                toReturn.append(FetchTag(tag: tag, works: UInt64(works)))
            }
            return toReturn
        } else {
            return tags.map { tag in
                FetchTag(tag: tag)
            }
        }
    }
    
    /// Creates a new tag.
    func createTag(with formInfo: Tag.TagForm) async throws -> Tag {
        let newTag = try Tag(from: formInfo)
        try await newTag.save(on: request.db)
        return newTag
    }
    
    /// Updates a tag given the supplied `formInfo`.
    func updateTag(_ id: String, with formInfo: Tag.TagForm) async throws -> Tag {
        return try await request.db.transaction { database in
            guard let tag: Tag = try await Tag.find(id, on: database) else {
                throw Abort(.notFound, reason: "The tag you're trying to modify doesn't exist.")
            }
            tag.name = try SwiftSoup.clean(formInfo.name, .none())!
            if let hasDesc = formInfo.desc {
                tag.desc = try SwiftSoup.clean(hasDesc, .none())!
            }
            try await tag.save(on: database)
            return tag
        }
    }
    
    /// Deletes a tag from the database.
    func deleteTag(_ id: String) async throws {
        try await request.db.transaction { database in
            guard let tag: Tag = try await Tag.find(id, on: database) else {
                throw Abort(.notFound, reason: "The tag you're trying to delete doesn't exist.")
            }
            try await tag.delete(on: database)
        }
    }
    
}

extension TagService {
    struct FetchTag: Content {
        var tag: Tag
        var works: UInt64?
    }
}

extension Request {
    var tagService: TagService {
        .init(request: self)
    }
}
