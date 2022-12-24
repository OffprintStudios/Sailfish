//
// Created by Alyx Mote on 10/26/22.
//

import Foundation
import Vapor
import Fluent
import SwiftSoup

/// Offprint Comment Service
///
/// Contains functions pertaining to comments, threads, and any related functionality.
struct CommentService {
    let request: Request
    
    /// Add a comment to an existing thread. If the comment is being added to a thread that doesn't
    /// exist, throw an error. Also, if the thread is closed (e.g. `thread.open == false`),
    /// throw an error.
    func addComment(with formInfo: Comment.CommentForm) async throws -> Comment {
        let profile = try request.authService.getUser(withProfile: true).profile!
        switch formInfo.type {
        case .blog:
            guard let blog = try await Blog.query(on: request.db).with(\.$author).filter(\.$id == formInfo.itemId).filter(\.$publishedOn <= Date()).first() else {
                throw Abort(.notFound, reason: "The blog you're trying to comment on doesn't exist.")
            }
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
            try await request.queue.dispatch(AddNotificationJob.self, .init(
                to: blog.author.id!,
                from: comment.profile.id,
                event: .newBlogComment,
                entity: blog.id,
                context: ["title": blog.title]
            ))
            return comment
        case .work:
            guard let work = try await Work.query(on: request.db).with(\.$author).filter(\.$id == formInfo.itemId).filter(\.$publishedOn <= Date()).first() else {
                throw Abort(.notFound, reason: "The work you're trying to comment on doesn't exist.")
            }
            let comment: Comment = try await request.db.transaction { database in
                let newComment = try Comment(by: profile.id!, with: formInfo)
                try await newComment.save(on: database)
                try await work.$comments.attach(newComment, on: database)
                newComment.$profile.value = profile
                try await newComment.$history.load(on: database)
                return newComment
            }
            try await request.queue.dispatch(AddNotificationJob.self, .init(
                to: work.author.id!,
                from: comment.profile.id,
                event: .newWorkComment,
                entity: work.id,
                context: ["title": work.title]
            ))
            return comment
        }
    }
    
    /// Edits an existing comment belonging to a specific user. Can be done regardless of thread,
    /// but why would you?
    func editComment(_ id: String, with formInfo: Comment.CommentForm) async throws -> Comment {
        let profile = try request.authService.getUser(withProfile: true).profile!
        let comment = try await Comment.query(on: request.db)
            .with(\.$profile)
            .with(\.$history)
            .filter(\.$id == id)
            .filter(\.$profile.$id == profile.id!)
            .first()
        
        if let hasComment = comment {
            let newHistory = CommentHistory(oldBody: hasComment.body)
            hasComment.body = try SwiftSoup.clean(formInfo.body, defaultWhitelist())!
            hasComment.spoiler = formInfo.spoiler
            try await hasComment.$history.create(newHistory, on: request.db)
            try await hasComment.save(on: request.db)
            return hasComment
        } else {
            throw Abort(.badRequest, reason: "No such comment exists.")
        }
    }
}

extension Request {
    var commentService: CommentService {
        .init(request: self)
    }
}
