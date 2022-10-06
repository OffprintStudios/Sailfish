//
// Created by Alyx Mote on 8/5/22.
//

import Vapor
import Fluent

struct BlogController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let blogs = routes.grouped("blogs")
        let blogsWithAuth = blogs.grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            StatusGuard()
        ])

        blogs.get("fetch-blog", ":blogId") { request async throws -> Blog in
            let blogId = request.parameters.get("blogId")!
            return try await request.blogService.fetchBlog(blogId)
        }

        blogs.get("fetch-blogs") { request async throws -> Page<Blog> in
            let query = try request.query.decode(FetchBlogsQuery.self)
            if let authorId = query.authorId, let status = query.status {
                return try await request.blogService.fetchBlogs(for: authorId, status: status, filter: query.filter ?? .restricted)
            } else if let authorId = query.authorId {
                return try await request.blogService.fetchBlogs(for: authorId, status: .published, filter: query.filter ?? .restricted)
            } else {
                return try await request.blogService.fetchBlogs(filter: query.filter ?? .restricted)
            }
        }

        blogsWithAuth.post("create-blog") { request async throws -> Blog in
            try Blog.BlogForm.validate(content: request)
            let blogForm = try request.content.decode(Blog.BlogForm.self)
            return try await request.blogService.createBlog(with: blogForm)
        }

        blogsWithAuth.patch("update-blog", ":blogId") { request async throws -> Blog in
            let blogId = request.parameters.get("blogId")!
            try Blog.BlogForm.validate(content: request)
            let blogForm = try request.content.decode(Blog.BlogForm.self)
            return try await request.blogService.updateBlog(blogId, with: blogForm)
        }

        blogsWithAuth.patch("publish-blog", ":blogId") { request async throws -> Blog in
            let blogId = request.parameters.get("blogId")!
            try Blog.PublishBlogForm.validate(content: request)
            let blogForm = try request.content.decode(Blog.PublishBlogForm.self)
            return try await request.blogService.publishBlog(blogId, on: blogForm.pubDate)
        }

        blogsWithAuth.delete("delete-blog", ":blogId") { request async throws -> Response in
            let blogId = request.parameters.get("blogId")!
            try await request.blogService.deleteBlog(blogId)
            return Response(status: .ok)
        }

        blogsWithAuth.get("fetch-favorites") { request async throws -> Page<FavoriteBlog> in
            guard let profile = try request.authService.getUser().profile else {
                throw Abort(.unauthorized, reason: "No profile found to complete this request.")
            }
            return try await request.blogService.fetchFavorites(profileId: profile.id!)
        }

        blogsWithAuth.get("fetch-favorite") { request async throws -> FavoriteBlog in
            guard let profile = try request.authService.getUser().profile else {
                throw Abort(.unauthorized, reason: "No profile found to complete this request.")
            }
            let favoriteBlog = try request.content.decode(FavoriteBlogDTO.self)
            return try await request.blogService.fetchFavorite(blogId: favoriteBlog.blogId, profileId: profile.id!)
        }

        blogsWithAuth.post("add-favorite") { request async throws -> FavoriteBlog in
            guard let profile = try request.authService.getUser().profile else {
                throw Abort(.unauthorized, reason: "No profile found to complete this request.")
            }
            let favoriteBlog = try request.content.decode(FavoriteBlogDTO.self)
            return try await request.blogService.addFavorite(favoriteBlog.blogId, profileId: profile.id!)
        }

        blogsWithAuth.delete("remove-favorite") { request async throws -> Response in
            guard let profile = try request.authService.getUser().profile else {
                throw Abort(.unauthorized, reason: "No profile found to complete this request.")
            }
            let favoriteBlog = try request.content.decode(FavoriteBlogDTO.self)
            try await request.blogService.removeFavorite(favoriteBlog.blogId, profileId: profile.id!)
            return Response(status: .ok)
        }
    }
}

extension BlogController {
    struct FetchBlogsQuery: Content {
        var authorId: String?
        var status: ApprovalStatus?
        var filter: ContentFilter?
        var page: Int?
        var per: Int?
    }

    struct FavoriteBlogDTO: Content {
        var blogId: String
    }
}
