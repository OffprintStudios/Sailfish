//
// Created by Alyx Mote on 8/5/22.
//

import Foundation
import Vapor
import Fluent
import SwiftSoup

struct BlogService: HasComments {
    let request: Request

    /// Fetches a blog post given its ID. If no such post exists, throws a `notFound` error.
    func fetchBlog(_ id: String) async throws -> FetchBlog {
        guard let blog: Blog = try await Blog.query(on: request.db).with(\.$author).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Blog not found. Are you sure you're looking for the right one?")
        }
        if blog.publishedOn != nil {
            if let ipAddress = request.headers.first(name: "X-Offprint-Client-IP") {
                let existingView = try await blog.$ipViews.query(on: request.db).filter(\.$ipAddress == ipAddress).first()
                if existingView == nil {
                    let newView = BlogIPView(ipAddress: ipAddress)
                    try await request.db.transaction { database in
                        try await blog.$ipViews.create(newView, on: database)
                    }
                }
            }
            blog.stats.views = try await blog.$ipViews.query(on: request.db).count()
            try await request.db.transaction { database in
                try await blog.save(on: database)
            }
            return .init(
                blog: blog,
                comments: try await blog.$comments
                    .query(on: request.db)
                    .with(\.$profile)
                    .with(\.$history)
                    .sort(\.$createdAt, .ascending)
                    .paginate(for: request)
            )
        }
        return .init(blog: blog, comments: nil)
    }

    /// Fetches a paginated list of published blogs based on the provided `ContentFilter`.
    func fetchBlogs(filter: ContentFilter) async throws -> Page<Blog> {
        try await Blog.query(on: request.db)
            .with(\.$author)
            .filter(\.$rating ~~ determineRatings(from: filter))
            .filter(\.$publishedOn <= Date())
            .sort(\.$publishedOn, .descending)
            .paginate(for: request)
    }

    /// Fetches a paginated list of blogs specific to an author and based on the provided Content Filter. If the provided
    /// `status` is `.draft`, returns only drafts. If the provided `status` is `.published`, returns only published posts.
    /// Otherwise, this will return any pending posts, i.e. posts with publish dates that have not yet occurred.
    func fetchBlogs(for authorId: String, status: PublishStatus, filter: ContentFilter) async throws -> Page<Blog> {
        let query = Blog.query(on: request.db)
            .with(\.$author)
            .filter(\.$author.$id == authorId)
            .filter(\.$rating ~~ determineRatings(from: filter))

        switch status {
        case .draft:
            return try await query
                .filter(\.$publishedOn == nil)
                .sort(\.$createdAt, .descending)
                .paginate(for: request)
        case .pending:
            return try await query
                .filter(\.$publishedOn > Date())
                .sort(\.$createdAt, .descending)
                .paginate(for: request)
        case .published:
            return try await query
                .filter(\.$publishedOn <= Date())
                .sort(\.$publishedOn, .descending)
                .paginate(for: request)
        }
    }
    
    /// Fetches a new page of comments for a blog.
    func fetchComments(for id: String, sectionId: String? = nil) async throws -> Page<Comment> {
        guard let blog: Blog = try await Blog.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Blog not found. Are you sure you're looking for the right one?")
        }
        if blog.publishedOn != nil {
            return try await blog.$comments
                .query(on: request.db)
                .with(\.$profile)
                .with(\.$history)
                .sort(\.$createdAt, .ascending)
                .paginate(for: request)
        }
        throw Abort(.badRequest, reason: "This work is not published, so comments are inaccessible.")
    }
    
    /// Adds a comment to the specified blog.
    func addComment(for id: String, with formInfo: Comment.CommentForm) async throws -> Comment {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog: Blog = try await Blog.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "The blog you're commenting on doesn't seem to exist.")
        }
        if blog.publishedOn != nil {
            let comment: Comment = try await request.db.transaction { database in
                let newComment = try Comment(by: profile.id!, with: formInfo)
                try await newComment.save(on: database)
                try await blog.$comments.attach(newComment, on: database)
                blog.stats.comments += 1
                try await blog.save(on: database)
                newComment.$profile.value = profile
                try await newComment.$history.load(on: database)
                return newComment
            }
            let repliesTo = try await blog.$comments.query(on: request.db).filter(\.$id ~~ formInfo.repliesTo).all()
            try await request.db.transaction { database in
                try await comment.$repliesTo.attach(repliesTo, on: database)
            }
            for reply in repliesTo {
                try await request.queue.dispatch(AddNotificationJob.self, .init(
                    to: reply.$profile.id,
                    from: comment.profile.id,
                    event: .newReply,
                    entity: comment.id,
                    context: ["title": blog.title, "url": "\(formInfo.locationUrl)#comment-\(comment.id ?? "nil")"]
                ))
            }
            if blog.$author.id != profile.id {
                try await request.queue.dispatch(AddNotificationJob.self, .init(
                    to: blog.$author.id,
                    from: comment.profile.id,
                    event: .newBlogComment,
                    entity: blog.id,
                    context: ["title": blog.title, "url": "\(formInfo.locationUrl)#comment-\(comment.id ?? "nil")"]
                ))
            }
            return comment
        }
        throw Abort(.badRequest, reason: "Comments are disabled for drafts.")
    }
    
    /// Edits a blog comment.
    func editComment(_ id: String, for itemId: String, with formInfo: Comment.CommentForm) async throws -> Comment {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog: Blog = try await Blog.query(on: request.db).filter(\.$id == itemId).first() else {
            throw Abort(.notFound, reason: "The blog you're commenting on doesn't seem to exist.")
        }
        if blog.publishedOn != nil {
            guard let comment = try await blog.$comments
                .query(on: request.db)
                .filter(\.$id == id)
                .filter(\.$profile.$id == profile.id!)
                .first() else {
                throw Abort(.notFound, reason: "The comment you're trying to edit doesn't seem to exist.")
            }
            let newHistory = CommentHistory(oldBody: comment.body)
            comment.body = try SwiftSoup.clean(formInfo.body, defaultWhitelist())!
            comment.spoiler = formInfo.spoiler
            try await request.db.transaction { database in
                try await comment.$history.create(newHistory, on: database)
                try await comment.save(on: database)
            }
            comment.$profile.value = profile
            try await comment.$history.load(on: request.db)
            return comment
        }
        throw Abort(.badRequest, reason: "Comments are disabled for drafts.")
    }

    /// Fetches newsposts.
    func fetchNews() async throws -> Page<Blog> {
        try await Blog.query(on: request.db)
            .with(\.$author)
            .filter(\.$newsPost == true)
            .filter(\.$rating ~~ [.everyone, .teen])
            .filter(\.$publishedOn <= Date())
            .sort(\.$publishedOn, .descending)
            .paginate(for: request)
    }

    /// Creates a blog given the provided `formInfo`.
    func createBlog(with formInfo: Blog.BlogForm) async throws -> Blog {
        let account = try request.authService.getUser().account
        let profile = try request.authService.getUser(withProfile: true).profile
        if canAccess(needs: [.admin, .moderator, .contributor], has: account.roles) == false {
            if formInfo.newsPost == true {
                throw Abort(.forbidden, reason: "You aren't allowed to do that.")
            }
        }
        let newBlog = try Blog(from: formInfo)
        try await profile!.$blogs.create(newBlog, on: request.db)
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
        blog.newsPost = formInfo.newsPost
        blog.editedOn = Date()

        try await blog.save(on: request.db)
        return blog
    }

    /// Updates a blog's cover image.
    func updateBannerArt(_ id: String, bannerUrl: String? = nil) async throws -> Blog {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog: Blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Could not find blog to update. Are you sure it exists?")
        }
        blog.bannerArt = bannerUrl
        try await blog.save(on: request.db)
        return blog
    }

    /// Publishes a blog by updating its `publishedOn` field with the specified `publishDate`.
    func publishBlog(_ id: String, on publishDate: Date? = nil) async throws -> Blog {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let blog: Blog = try await profile.$blogs.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "Could not find blog to update. Are you sure it exists?")
            }
            blog.publishedOn = publishDate
            if blog.firstPublished == nil {
                blog.firstPublished = publishDate
            }
            try await blog.save(on: database)
            
            profile.stats.blogs = try await profile.$blogs.query(on: database).filter(\.$publishedOn <= Date()).count()
            try await profile.save(on: database)
            
            return blog
        }
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
    func fetchFavorites() async throws -> Page<Blog> {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await profile.$favoriteBlogs
            .query(on: request.db)
            .with(\.$author)
            .paginate(for: request)
    }

    /// Checks for a single favorited blog for a given profile
    func checkFavorite(_ blogId: String) async throws -> CheckFavorite {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return .init(hasFavorited: try await profile.$favoriteBlogs.isAttached(toID: blogId, on: request.db))
    }

    /// Adds a blog to a profile's list of favorites
    func addFavorite(_ blogId: String) async throws -> CheckFavorite {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let blog = try await Blog.query(on: request.db).with(\.$author).filter(\.$id == blogId).first() else {
            throw Abort(.notFound, reason: "The blog you're trying to add doesn't exist.")
        }
        try await request.db.transaction { database in
            try await profile.$favoriteBlogs.attach(blog, on: database)
            blog.stats.favorites = try await blog.$favoritedBy.query(on: database).count()
            try await blog.save(on: database)
        }
        try await request.queue.dispatch(AddNotificationJob.self, .init(
            to: blog.author.id!,
            from: profile.id,
            event: .addFavorite,
            entity: blog.id,
            context: ["title": blog.title]
        ))
        return .init(hasFavorited: true)
    }

    /// Removes a blog from a profile's list of favorites
    func removeFavorite(_ blogId: String) async throws -> CheckFavorite {
        let profile = try request.authService.getUser(withProfile: true).profile!
        if try await profile.$favoriteBlogs.isAttached(toID: blogId, on: request.db) {
            guard let blog = try await Blog.find(blogId, on: request.db) else {
                throw Abort(.notFound, reason: "The blog you're trying to remove doesn't exist.")
            }
            try await request.db.transaction { database in
                try await profile.$favoriteBlogs.detach(blog, on: database)
                blog.stats.favorites = try await blog.$favoritedBy.query(on: database).count()
                try await blog.save(on: database)
            }
            return .init(hasFavorited: false)
        } else {
            throw Abort(.notFound, reason: "You haven't even favorited this blog yet!")
        }
        
    }
        
    enum PublishStatus: String, Codable {
        case draft = "draft"
        case pending = "pending"
        case published = "published"
    }
}

extension BlogService {
    struct FetchBlog: Content {
        var blog: Blog
        var comments: Page<Comment>?
    }
    
    struct CheckFavorite: Content {
        var hasFavorited: Bool
    }
}

extension Request {
    var blogService: BlogService {
        .init(request: self)
    }
}
