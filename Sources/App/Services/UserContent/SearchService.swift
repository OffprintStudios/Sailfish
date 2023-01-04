//
//  Created by Alyx Mote on 1/3/23.
//

import Vapor
import Fluent
import SwiftSoup

struct SearchService {
    let request: Request
    
    /// Finds all works related to the given `title`, `author`, and `categories`. If none are provided, returns all works.
    func findRelatedWorks(title: String?, author: String?, categories: [Work.Category]?, filter: ContentFilter) async throws -> Page<Work> {
        let withAuthor = try await findRelatedAuthor(username: author)
        if let hasAuthor = withAuthor, let hasTitle = title {
            let cleanedTitle = try SwiftSoup.clean(hasTitle, .none())!
            return try await hasAuthor.$works.query(on: request.db)
                .with(\.$author)
                .with(\.$tags, {$0.with(\.$parent)})
                .filter(\.$category ~~ (categories ?? [Work.Category.original, Work.Category.fanwork]))
                .filter(\.$title, .custom("@@"), cleanedTitle)
                .filter(\.$rating ~~ determineRatings(from: filter))
                .filter(\.$publishedOn <= Date())
                .sort(\.$publishedOn, .descending)
                .paginate(for: request)
        } else if let hasTitle = title {
            let cleanedTitle = try SwiftSoup.clean(hasTitle, .none())!
            return try await Work.query(on: request.db)
                .with(\.$author)
                .with(\.$tags, {$0.with(\.$parent)})
                .filter(\.$category ~~ (categories ?? [Work.Category.original, Work.Category.fanwork]))
                .filter(\.$rating ~~ determineRatings(from: filter))
                .filter(\.$title, .custom("@@"), cleanedTitle)
                .filter(\.$publishedOn <= Date())
                .sort(\.$publishedOn, .descending)
                .paginate(for: request)
        } else {
            return try await Work.query(on: request.db)
                .with(\.$author)
                .with(\.$tags, {$0.with(\.$parent)})
                .filter(\.$category ~~ (categories ?? [Work.Category.original, Work.Category.fanwork]))
                .filter(\.$rating ~~ determineRatings(from: filter))
                .filter(\.$publishedOn <= Date())
                .sort(\.$publishedOn, .descending)
                .paginate(for: request)
        }
    }
    
    /// Finds blogs related to the provided `title` and `author`. If no `author` is found or provided, returns any blogs matching only the `title`.
    /// If no `title` is provided, returns any blogs belonging to `author`. If neither are provided, returns all blogs.
    func findRelatedBlogs(title: String?, author: String?, filter: ContentFilter) async throws -> Page<Blog> {
        if let hasAuthor = try await findRelatedAuthor(username: author) {
            if let hasTitle = title {
                let cleanedTitle = try SwiftSoup.clean(hasTitle, .none())!
                return try await hasAuthor.$blogs.query(on: request.db)
                    .with(\.$author)
                    .filter(\.$title, .custom("@@"), cleanedTitle)
                    .filter(\.$rating ~~ determineRatings(from: filter))
                    .filter(\.$publishedOn <= Date())
                    .sort(\.$publishedOn, .descending)
                    .paginate(for: request)
            } else {
                return try await hasAuthor.$blogs.query(on: request.db)
                    .with(\.$author)
                    .filter(\.$rating ~~ determineRatings(from: filter))
                    .filter(\.$publishedOn <= Date())
                    .sort(\.$publishedOn, .descending)
                    .paginate(for: request)
            }
        } else {
            if let hasTitle = title {
                let cleanedTitle = try SwiftSoup.clean(hasTitle, .none())!
                return try await Blog.query(on: request.db)
                    .with(\.$author)
                    .filter(\.$title, .custom("@@"), cleanedTitle)
                    .filter(\.$rating ~~ determineRatings(from: filter))
                    .filter(\.$publishedOn <= Date())
                    .sort(\.$publishedOn, .descending)
                    .paginate(for: request)
            } else {
                return try await Blog.query(on: request.db)
                    .with(\.$author)
                    .filter(\.$rating ~~ determineRatings(from: filter))
                    .filter(\.$publishedOn <= Date())
                    .sort(\.$publishedOn, .descending)
                    .paginate(for: request)
            }
        }
    }
    
    /// Finds profiles related to the provided `username`. If `username` is `nil`, returns all profiles.
    func findRelatedProfiles(username: String?) async throws -> Page<ClientProfile> {
        if let hasUsername = username {
            let cleanedUsername = try SwiftSoup.clean(hasUsername, .none())!
            let profiles = try await Profile.query(on: request.db)
                .with(\.$account)
                .filter(\.$username, .custom("@@"), cleanedUsername)
                .paginate(for: request)
            let clientProfiles = profiles.items.map { ClientProfile.init(from: $0) }
            return .init(items: clientProfiles, metadata: profiles.metadata)
        }
        let profiles = try await Profile.query(on: request.db)
            .with(\.$account)
            .paginate(for: request)
        let clientProfiles = profiles.items.map { ClientProfile.init(from: $0) }
        return .init(items: clientProfiles, metadata: profiles.metadata)
    }
    
    /// Finds an author given the provided username. If no author is found, or no username is provided, returns `nil`. Otherwise, returns the author's ID.
    private func findRelatedAuthor(username: String?) async throws -> Profile? {
        if let hasUsername = username {
            let cleanedUsername = try SwiftSoup.clean(hasUsername, .none())!
            print(cleanedUsername)
            return try await Profile.query(on: request.db)
                .filter(\.$username, .custom("@@"), cleanedUsername)
                .first()
        }
        return nil
    }
}

extension Request {
    var searchService: SearchService {
        .init(request: self)
    }
}
