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

    /// Fetches a thread of comments. If no thread exists, this will create one. This should only
    /// be used for content comments (e.g. blogs, stories, etc).
    func fetchOrCreateThread(_ threadId: String) async throws -> Thread {
        let thread = try await Thread.query(on: request.db)
            .with(\.$createdBy)
            .with(\.$blacklist) { blacklist in
                blacklist.with(\.$profile)
            }
            .filter(\.$id == threadId)
            .first()

        if let hasThread = thread {
            return hasThread
        } else {
            let newThread = Thread(id: threadId)
            try await newThread.save(on: request.db)
            return newThread
        }
    }

    /// Fetches comments for a given thread ID.
    func fetchComments(_ threadId: String) async throws -> Page<Comment> {
        let thread = try await Thread.query(on: request.db)
            .filter(\.$id == threadId)
            .first()
        if let hasThread = thread {
            return try await hasThread.$comments.query(on: request.db)
                .with(\.$profile)
                .with(\.$history)
                .sort(\.$createdAt, .ascending)
                .paginate(for: request)
        } else {
            throw Abort(.notFound, reason: "The thread you're trying to find doesn't exist.")
        }
    }

    /// Add a comment to an existing thread. If the comment is being added to a thread that doesn't
    /// exist, throw an error. Also, if the thread is closed (e.g. `thread.open == false`),
    /// throw an error.
    func addComment(with formInfo: Comment.CommentForm) async throws -> Comment {
        let profile = try request.authService.getUser(withProfile: true).profile!
        let thread = try await Thread.query(on: request.db)
            .filter(\.$id == formInfo.threadId)
            .first()
        if let hasThread = thread {
            if hasThread.open == true {
                let newComment = try Comment(by: profile.id!, with: formInfo)
                try await hasThread.$comments.create(newComment, on: request.db)
                try await newComment.$profile.load(on: request.db)
                try await newComment.$history.load(on: request.db)
                return newComment
            } else {
                throw Abort(.forbidden, reason: "This thread is currently closed.")
            }
        } else {
            throw Abort(.notFound, reason: "The thread you're trying to comment on does not exist.")
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

    /// Adds a user to a thread's blacklist. If no valid thread is found, throws an error.
    func addToBlacklist(from formInfo: ThreadBlacklist.BlacklistForm) async throws -> ThreadBlacklist {
        let profile = try request.authService.getUser(withProfile: true).profile!
        let thread = try await Thread.query(on: request.db)
            .filter(\.$id == formInfo.threadId)
            .filter(\.$createdBy.$id == profile.id)
            .first()
        if let hasThread = thread {
            let newBlacklist = try ThreadBlacklist(with: formInfo)
            try await hasThread.$blacklist.create(newBlacklist, on: request.db)
            return newBlacklist
        } else {
            throw Abort(.notFound, reason: "The thread you're trying to modify doesn't exist.")
        }
    }

    /// Removes a user from a thread's blacklist. If no valid thread is found, throws an error.
    func removeFromBlacklist(_ blacklistId: UUID, threadId: String) async throws {
        let profile = try request.authService.getUser(withProfile: true).profile!
        let thread = try await Thread.query(on: request.db)
            .filter(\.$id == threadId)
            .filter(\.$createdBy.$id == profile.id)
            .first()
        if let hasThread = thread {
            try await hasThread.$blacklist.query(on: request.db)
                .filter(\.$id == blacklistId)
                .delete()
        } else {
            throw Abort(.notFound, reason: "The thread you're trying to modify doesn't exist.")
        }
    }
}

extension Request {
    var commentService: CommentService {
        .init(request: self)
    }
}
