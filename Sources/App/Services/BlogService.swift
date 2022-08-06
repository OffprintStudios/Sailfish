//
// Created by Alyx Mote on 8/5/22.
//

import Vapor
import Fluent

struct BlogService {
    let request: Request

    func fetchBlog(_ id: String) async throws -> Blog {
        if let blog = try await Blog.find(id, on: request.db) {
            return blog
        } else {
            throw Abort(.notFound)
        }
    }

    func fetchBlogs(filter: ContentFilter) async throws -> Page<Blog> {
        try await Blog.query(on: request.db)
            .filter(\.$rating ~~ determineRatings(from: filter))
            .filter(\.$status == ApprovalStatus.published)
            .sort(\.$publishedOn)
            .paginate(for: request)
    }

    func fetchBlogs(for authorId: String, status: ApprovalStatus = .published, filter: ContentFilter) async throws -> Page<Blog> {
        try await Blog.query(on: request.db)
            .filter(\.$id == authorId)
            .filter(\.$rating ~~ determineRatings(from: filter))
            .filter(\.$status == status)
            .paginate(for: request)
    }

    func createBlog(with formInfo: Blog.BlogForm) async throws -> Blog {
        let profile = try request.authService.getUser(withProfile: true).profile!
        let newBlog = Blog.init(from: formInfo)
        try await profile.$blogs.create(newBlog, on: request.db)
        try await newBlog.$author.load(on: request.db)
        return newBlog
    }

    func updateBlog(_ id: String, with formInfo: Blog.BlogForm) async throws -> Blog {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound)
        }

        blog.title = formInfo.title
        blog.desc = formInfo.desc
        blog.body = formInfo.body
        blog.rating = formInfo.rating

        try await blog.save(on: request.db)
        return blog
    }

    func publishBlog(_ id: String) async throws -> Blog {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound)
        }

        if blog.status == .draft {
            blog.status = .published
        } else {
            blog.status = .draft
        }

        try await blog.save(on: request.db)
        return blog
    }

    func deleteBlog(_ id: String) async throws {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound)
        }

        try await blog.delete(on: request.db)
    }

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
