//
// Created by Alyx Mote on 8/5/22.
//

import Vapor
import Fluent
import SwiftSoup

struct BlogService {
    let request: Request

    /// Fetches a blog post given its ID. If no such post exists, throws a `notFound` error.
    func fetchBlog(_ id: String) async throws -> Blog {
        guard let blog: Blog = try await Blog.query(on: request.db).with(\.$author).filter(\.$id == id).first() else {
            throw Abort(.notFound)
        }

        return blog;
    }

    /// Fetches a paginated list of published blogs based on the provided Content Filter.
    func fetchBlogs(filter: ContentFilter) async throws -> Page<Blog> {
        try await Blog.query(on: request.db)
            .with(\.$author)
            .filter(\.$rating ~~ determineRatings(from: filter))
            .filter(\.$publishedOn <= Date.now)
            .sort(\.$publishedOn)
            .paginate(for: request)
    }

    /// Fetches a paginated list of published blogs specific to an author and based on the provided Content Filter.
    /// If a `publishDate` is provided, it fetches any already-published posts. If none is provided, it only fetches
    /// drafts.
    func fetchBlogs(for authorId: String, from publishDate: Date? = nil, filter: ContentFilter) async throws -> Page<Blog> {
        if let pubDate = publishDate {
            return try await Blog.query(on: request.db)
                .with(\.$author)
                .filter(\.$author.$id == authorId)
                .filter(\.$rating ~~ determineRatings(from: filter))
                .filter(\.$publishedOn <= pubDate)
                .sort(\.$publishedOn)
                .paginate(for: request)
        } else {
            return try await Blog.query(on: request.db)
                .with(\.$author)
                .filter(\.$author.$id == authorId)
                .filter(\.$rating ~~ determineRatings(from: filter))
                .filter(\.$publishedOn == nil)
                .sort(\.$createdAt)
                .paginate(for: request)
        }
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
            throw Abort(.notFound)
        }

        blog.title = try SwiftSoup.clean(formInfo.title, Whitelist.none())!
        if let hasDesc = formInfo.desc {
            blog.desc = try SwiftSoup.clean(hasDesc, Whitelist.none())!
        }
        blog.body = try SwiftSoup.clean(formInfo.body, Whitelist.relaxed())!
        blog.rating = formInfo.rating

        try await blog.save(on: request.db)
        return blog
    }

    /// Publishes a blog by updating its `publishedOn` field. If `publishedOn` already contains a value, it's `nil`'d.
    /// If it doesn't, it's given the value of `publishDate`.
    func publishBlog(_ id: String, on publishDate: Date) async throws -> Blog {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog: Blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound)
        }

        if blog.publishedOn != nil {
            blog.publishedOn = nil
        } else {
            blog.publishedOn = publishDate
        }

        try await blog.save(on: request.db)
        return blog
    }

    /// Deletes a blog. Since all blogs have a `deletedAt` field, this deletion is just a soft delete, for moderation
    /// purposes.
    func deleteBlog(_ id: String) async throws {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound)
        }

        try await blog.delete(on: request.db)
    }

    /// Determines the ratings appropriate for the specified `filter`.
    private func determineRatings(from filter: ContentFilter) -> [ContentRating] {
        switch filter {
        case .mature:
            return [.everyone, .teen, .mature]
        case .explicit:
            return [.everyone, .teen, .explicit]
        case .everything:
            return [.everyone, .teen, .mature, .explicit]
        default:
            return [.everyone, .teen]
        }
    }
}

extension Request {
    var blogService: BlogService {
        .init(request: self)
    }
}
