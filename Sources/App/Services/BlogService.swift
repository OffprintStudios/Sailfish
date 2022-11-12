//
// Created by Alyx Mote on 8/5/22.
//

import Foundation
import Vapor
import Fluent
import SwiftSoup

struct BlogService {
    let request: Request

    /// Fetches a blog post given its ID. If no such post exists, throws a `notFound` error.
    func fetchBlog(_ id: String) async throws -> Blog {
        try await request.db.transaction { database in
            guard let blog: Blog = try await Blog.query(on: database).with(\.$author).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "Blog not found. Are you sure you're looking for the right one?")
            }
            if blog.publishedOn != nil {
                blog.stats.views += 1
                try await blog.save(on: database)
            }
            return blog;
        }
    }

    /// Fetches a paginated list of published blogs based on the provided Content Filter.
    func fetchBlogs(filter: ContentFilter) async throws -> Page<Blog> {
        try await Blog.query(on: request.db)
            .with(\.$author)
            .filter(\.$rating ~~ determineRatings(from: filter))
            .filter(\.$publishedOn <= Date())
            .sort(\.$publishedOn)
            .paginate(for: request)
    }

    /// Fetches a paginated list of blogs specific to an author and based on the provided Content Filter. If the provided
    /// `status` is `.draft`, returns only drafts. If the provided `status` is `.published`, returns only published posts.
    /// Otherwise, this will return any pending posts, i.e. posts with publish dates that have not yet occurred.
    func fetchBlogs(for authorId: String, status: ApprovalStatus, filter: ContentFilter) async throws -> Page<Blog> {
        let query = Blog.query(on: request.db)
            .with(\.$author)
            .filter(\.$author.$id == authorId)
            .filter(\.$rating ~~ determineRatings(from: filter))

        switch status {
        case .draft:
            return try await query
                .filter(\.$publishedOn == nil)
                .sort(\.$createdAt)
                .paginate(for: request)
        case .published:
            return try await query
                .filter(\.$publishedOn <= Date())
                .sort(\.$publishedOn)
                .paginate(for: request)
        default:
            return try await query
                .filter(\.$publishedOn > Date())
                .sort(\.$publishedOn)
                .paginate(for: request)
        }
    }

    /// Fetches newsposts.
    func fetchNews() async throws -> Page<Blog> {
        try await Blog.query(on: request.db)
            .with(\.$author)
            .filter(\.$newsPost == true)
            .filter(\.$rating ~~ [.everyone, .teen])
            .filter(\.$publishedOn <= Date())
            .sort(\.$publishedOn)
            .paginate(for: request)
    }

    /// Creates a blog given the provided `formInfo`.
    func createBlog(with formInfo: Blog.BlogForm) async throws -> Blog {
        let profile = try request.authService.getUser(withProfile: true).profile!
        let newBlog = try Blog.init(from: formInfo)
        try await profile.$blogs.create(newBlog, on: request.db)
        try await newBlog.$author.load(on: request.db)
        return newBlog
    }

    /// Updates an existing blog given the provided `formInfo`.
    func updateBlog(_ id: String, with formInfo: Blog.BlogForm) async throws -> Blog {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog: Blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Could not find blog to update. Are you sure it exists?")
        }

        blog.title = try SwiftSoup.clean(formInfo.title, Whitelist.none())!
        if let hasDesc = formInfo.desc {
            blog.desc = try SwiftSoup.clean(hasDesc, Whitelist.none())!
        }
        blog.body = try SwiftSoup.clean(formInfo.body, defaultWhitelist())!
        blog.rating = formInfo.rating
        blog.stats.words = try SwiftSoup.clean(formInfo.body, Whitelist.none())!.split { !$0.isLetter }.count
        blog.editedOn = Date()

        try await blog.save(on: request.db)
        return blog
    }

    /// Updates a blog's cover image.
    func updateCover(_ id: String, coverUrl: String? = nil) async throws -> Blog {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog: Blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Could not find blog to update. Are you sure it exists?")
        }
        blog.cover = coverUrl
        try await blog.save(on: request.db)
        return blog
    }

    /// Publishes a blog by updating its `publishedOn` field with the specified `publishDate`.
    func publishBlog(_ id: String, on publishDate: Date? = nil) async throws -> Blog {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog: Blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Could not find blog to update. Are you sure it exists?")
        }

        blog.publishedOn = publishDate

        try await blog.save(on: request.db)
        return blog
    }

    /// Converts a blog to a news post. Also forces a rating conversion to Everyone, though this should be enforced with
    /// site policy.
    func convertToNewsPost(_ id: String) async throws -> Blog {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog: Blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Could not find blog to update. Are you sure it exists?")
        }

        blog.newsPost = !blog.newsPost
        blog.rating = .everyone

        try await blog.save(on: request.db)
        return blog
    }

    /// Deletes a blog. Since all blogs have a `deletedAt` field, this deletion is just a soft delete, for moderation
    /// purposes.
    func deleteBlog(_ id: String) async throws {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Could not find blog to delete. Are you sure it exists?")
        }

        try await blog.delete(on: request.db)
    }

    /// Fetches all favorited blogs for a given profile
    func fetchFavorites(profileId: String) async throws -> Page<FavoriteBlog> {
        try await FavoriteBlog.query(on: request.db)
            .with(\.$blog) { blog in
                blog.with(\.$author)
            }
            .filter(\.$profile.$id == profileId)
            .paginate(for: request)
    }

    /// Fetches a single favorited blog for a given profile
    func fetchFavorite(blogId: String, profileId: String) async throws -> FavoriteBlog {
        if let blog = try await FavoriteBlog.query(on: request.db)
            .filter(\.$blog.$id == blogId)
            .filter(\.$profile.$id == profileId)
            .first() {
            return blog
        } else {
            throw Abort(.notFound, reason: "No favorite found.")
        }
    }

    /// Adds a blog to a profile's list of favorites
    func addFavorite(_ blogId: String, profileId: String) async throws -> FavoriteBlog {
        try await request.db.transaction { database in
            let blog: Blog? = try await Blog.query(on: database).filter(\.$id == blogId).first()
            if let hasBlog = blog {
                let newFave = FavoriteBlog(blogId, for: profileId)
                try await newFave.save(on: database)

                let totalFaves: Int = try await FavoriteBlog.query(on: database).filter(\.$blog.$id == blogId).count()
                hasBlog.stats.favorites = totalFaves
                try await hasBlog.save(on: database)

                return newFave
            } else {
                throw Abort(.notFound, reason: "The blog you're trying to add doesn't exist.")
            }
        }
    }

    /// Removes a blog from a profile's list of favorites
    func removeFavorite(_ blogId: String, profileId: String) async throws {
        try await FavoriteBlog.query(on: request.db)
            .filter(\.$blog.$id == blogId)
            .filter(\.$profile.$id == profileId)
            .delete()
    }
}

extension Request {
    var blogService: BlogService {
        .init(request: self)
    }
}
