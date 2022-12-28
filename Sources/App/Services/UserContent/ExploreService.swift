//
//  Created by Alyx Mote on 12/27/22.
//

import Vapor
import Fluent
import FluentSQL

struct ExploreService {
    let request: Request
    
    /// Fetches all recently-published works, in order of newest to oldest.
    func fetchNewWorks(filter: ContentFilter) async throws -> Page<Work> {
        try await Work.query(on: request.db)
            .with(\.$author)
            .with(\.$tags) { $0.with(\.$parent) }
            .filter(\.$rating ~~ determineRatings(from: filter))
            .filter(\.$publishedOn <= Date())
            .sort(\.$publishedOn, .descending)
            .paginate(for: request)
    }
    
    /// Fetches all recently-updated works, in order of newest to oldest.
    func fetchUpdatedWorks(filter: ContentFilter) async throws -> Page<Work> {
        try await Work.query(on: request.db)
            .with(\.$author)
            .with(\.$tags)
            .filter(\.$rating ~~ determineRatings(from: filter))
            .filter(\.$lastSectionUpdate != nil)
            .filter(\.$publishedOn <= Date())
            .sort(\.$lastSectionUpdate, .descending)
            .paginate(for: request)
    }
    
    /// Fetches all genres.
    func fetchGenres() async throws -> [TagService.FetchTag] {
        let tags: [Tag] = try await Tag.query(on: request.db)
            .filter(\.$kind == .genre)
            .sort(\.$name, .ascending)
            .all()
        var tagsWithCounts: [TagService.FetchTag] = []
        for tag in tags {
            let works = try await tag.$works.query(on: request.db).count()
            tagsWithCounts.append(.init(
                tag: tag,
                works: UInt64(works)
            ))
        }
        return tagsWithCounts
    }
    
    /// Fetches all fandoms.
    func fetchFandoms() async throws -> [TagService.FetchTag] {
        let tags = try await Tag.query(on: request.db)
            .with(\.$parent)
            .filter(\.$kind == .fandom)
            .sort(\.$name, .ascending)
            .all()
        var tagsWithCounts: [TagService.FetchTag] = []
        for tag in tags {
            let works = try await tag.$works.query(on: request.db).count()
            tagsWithCounts.append(.init(
                tag: tag,
                works: UInt64(works)
            ))
        }
        return tagsWithCounts
    }
    
    /// Fetches the top tags.
    func fetchTopTags(kind: Tag.Kind) async throws -> [Tag.TopTag] {
        if let sql = request.db as? SQLDatabase {
            return try await sql.raw("""
                SELECT t.*, COUNT(w.id) as total FROM tags t LEFT JOIN work_tags w ON t.id = w.tag_id WHERE t.kind = '\(raw: kind.rawValue)' GROUP BY t.id ORDER BY total DESC LIMIT 6
            """).all(decoding: Tag.TopTag.self)
        } else {
            throw Abort(.notImplemented, reason: "This feature is only available with SQL databases.")
        }
    }
    
    /// Fetches all works belonging to a tag.
    func fetchWorksByTag(tagId: String, filter: ContentFilter) async throws -> Page<Work> {
        guard let tag: Tag = try await Tag.find(tagId, on: request.db) else {
            throw Abort(.notFound, reason: "The tag you're trying to look up doesn't exist!")
        }
        return try await tag.$works.query(on: request.db)
            .with(\.$author)
            .with(\.$tags)
            .filter(\.$rating ~~ determineRatings(from: filter))
            .filter(\.$publishedOn <= Date())
            .sort(\.$publishedOn, .descending)
            .paginate(for: request)
    }
}

extension Request {
    var exploreService: ExploreService {
        .init(request: self)
    }
}
