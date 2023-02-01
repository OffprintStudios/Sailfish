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
            ConfirmationGuard(),
            BannedGuard(),
        ])
        let blogComments = blogs.grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            ConfirmationGuard(),
            MutedGuard(),
            BannedGuard(),
        ])

        blogs.get(":id") { request async throws -> BlogService.FetchBlog in
            let id = request.parameters.get("id")!
            return try await request.blogService.fetchBlog(id)
        }

        blogs.get("fetch") { request async throws -> Page<Blog> in
            let query = try request.query.decode(FetchBlogsQuery.self)
            if let authorId = query.authorId {
                return try await request.blogService.fetchBlogs(for: authorId, status: query.status ?? .published, filter: query.filter ?? .restricted)
            } else {
                return try await request.blogService.fetchBlogs(filter: query.filter ?? .restricted)
            }
        }
        
        blogs.get(":id", "comments") { request async throws -> Page<Comment> in
            let id = request.parameters.get("id")!
            return try await request.blogService.fetchComments(for: id)
        }
        
        blogComments.post(":id", "comments", "add") { request async throws -> Comment in
            let id = request.parameters.get("id")!
            try Comment.CommentForm.validate(content: request)
            let commentForm = try request.content.decode(Comment.CommentForm.self)
            return try await request.blogService.addComment(for: id, with: commentForm)
        }
        
        blogComments.patch(":id", "comments", ":commentId", "edit") { request async throws -> Comment in
            let id = request.parameters.get("id")!
            let commentId = request.parameters.get("commentId")!
            try Comment.CommentForm.validate(content: request)
            let commentForm = try request.content.decode(Comment.CommentForm.self)
            return try await request.blogService.editComment(commentId, for: id, with: commentForm)
        }

        blogsWithAuth.post("create") { request async throws -> Blog in
            try Blog.BlogForm.validate(content: request)
            let blogForm = try request.content.decode(Blog.BlogForm.self)
            return try await request.blogService.createBlog(with: blogForm)
        }

        blogsWithAuth.patch(":id", "update") { request async throws -> Blog in
            let blogId = request.parameters.get("id")!
            try Blog.BlogForm.validate(content: request)
            let blogForm = try request.content.decode(Blog.BlogForm.self)
            return try await request.blogService.updateBlog(blogId, with: blogForm)
        }

        blogsWithAuth.on(.PATCH, ":id", "update-cover", body: .collect(maxSize: "5mb")) { request async throws -> Blog in
            let blogId = request.parameters.get("id")!
            let data: UtilityService.UploadImage = try request.content.decode(UtilityService.UploadImage.self)
            let bannerUrl = try await request.utilityService.uploadImage(
                data,
                itemId: blogId,
                folder: "blog-banners"
            )
            return try await request.blogService.updateBannerArt(blogId, bannerUrl: bannerUrl)
        }

        blogsWithAuth.patch(":id", "publish") { request async throws -> Blog in
            let blogId = request.parameters.get("id")!
            try Blog.PublishBlogForm.validate(content: request)
            let blogForm = try request.content.decode(Blog.PublishBlogForm.self)
            return try await request.blogService.publishBlog(blogId, on: blogForm.pubDate)
        }

        blogsWithAuth.delete(":id", "delete") { request async throws -> Response in
            let blogId = request.parameters.get("id")!
            try await request.blogService.deleteBlog(blogId)
            return Response(status: .ok)
        }

        blogsWithAuth.get("fetch-favorites") { request async throws -> Page<Blog> in
            return try await request.blogService.fetchFavorites()
        }

        blogsWithAuth.get(":id", "fetch-favorite") { request async throws -> BlogService.CheckFavorite in
            let blogId = request.parameters.get("id")!
            return try await request.blogService.checkFavorite(blogId)
        }

        blogsWithAuth.post(":id", "add-favorite") { request async throws -> BlogService.CheckFavorite in
            let blogId = request.parameters.get("id")!
            return try await request.blogService.addFavorite(blogId)
        }

        blogsWithAuth.post(":id", "remove-favorite") { request async throws -> BlogService.CheckFavorite in
            let blogId = request.parameters.get("id")!
            return try await request.blogService.removeFavorite(blogId)
        }
    }
}

extension BlogController {
    struct FetchBlogsQuery: Content {
        var authorId: String?
        var status: BlogService.PublishStatus?
        var filter: ContentFilter?
        var page: Int?
        var per: Int?
    }
}
