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

        blogsWithAuth.on(.PATCH, "update-cover", ":blogId", body: .collect(maxSize: "5mb")) { request async throws -> Blog in
            let blogId = request.parameters.get("blogId")!
            let data: UtilityService.UploadImage = try request.content.decode(UtilityService.UploadImage.self)
            let coverUrl = try await request.utilityService.uploadImage(
                data,
                itemId: blogId,
                folder: "blog-banners"
            )
            return try await request.blogService.updateCover(blogId, coverUrl: coverUrl)
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
            guard let profile = try request.authService.getUser(withProfile: true).profile else {
                throw Abort(.unauthorized, reason: "No profile found to complete this request.")
            }
            return try await request.blogService.fetchFavorites(profileId: profile.id!)
        }

        blogsWithAuth.get("fetch-favorite", ":id") { request async throws -> FavoriteBlog in
            guard let profile = try request.authService.getUser(withProfile: true).profile else {
                throw Abort(.unauthorized, reason: "No profile found to complete this request.")
            }
            let blogId = request.parameters.get("id")!
            return try await request.blogService.fetchFavorite(blogId: blogId, profileId: profile.id!)
        }

        blogsWithAuth.post("add-favorite", ":id") { request async throws -> FavoriteBlog in
            guard let profile = try request.authService.getUser(withProfile: true).profile else {
                throw Abort(.unauthorized, reason: "No profile found to complete this request.")
            }
            let blogId = request.parameters.get("id")!
            return try await request.blogService.addFavorite(blogId, profileId: profile.id!)
        }

        blogsWithAuth.delete("remove-favorite", ":id") { request async throws -> Response in
            guard let profile = try request.authService.getUser(withProfile: true).profile else {
                throw Abort(.unauthorized, reason: "No profile found to complete this request.")
            }
            let blogId = request.parameters.get("id")!
            try await request.blogService.removeFavorite(blogId, profileId: profile.id!)
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
}
