//
// Created by Alyx Mote on 11/12/22.
//

import Foundation
import Vapor
import Fluent
import LexoRank
import SwiftSoup

struct WorkService: HasComments {    
    let request: Request

    /// Fetches a work given its ID. If no such work exists, throws a `notFound` error.
    func fetchWork(_ id: String, sectionId: String? = nil) async throws -> FetchWork {
        guard let work: Work = try await Work.query(on: request.db)
            .with(\.$author)
            .with(\.$tags, { $0.with(\.$parent) })
            .filter(\.$id == id)
            .first() else {
            throw Abort(.notFound, reason: "Work not found. Are you sure you're looking for the right one?")
        }
        
        if work.publishedOn != nil {
            if let ipAddress = request.headers.first(name: "X-Offprint-Client-IP") {
                let existingView = try await work.$ipViews.query(on: request.db).filter(\.$ipAddress == ipAddress).first()
                if existingView == nil {
                    let newView = WorkIPView(ipAddress: ipAddress)
                    try await request.db.transaction { database in
                        try await work.$ipViews.create(newView, on: database)
                    }
                }
            }
            work.views = Int64(try await work.$ipViews.query(on: request.db).count())
            try await request.db.transaction { database in
                try await work.save(on: database)
            }
            var commentsQuery = work.$comments.query(on: request.db)
                .with(\.$profile)
                .with(\.$history)
            if let hasSectionId = sectionId {
                commentsQuery = commentsQuery.filter(\.$section.$id == hasSectionId)
            }
            return .init(
                work: work,
                comments: try await commentsQuery.paginate(for: request)
            )
        }
        return .init(work: work, comments: nil)
    }
    
    /// Fetches a paginated list of published works based on the provided `ContentFilter`.
    func fetchWorks(filter: ContentFilter) async throws -> Page<Work> {
        try await Work.query(on: request.db)
            .with(\.$author)
            .with(\.$tags) { tag in
                tag.with(\.$parent)
            }
            .filter(\.$rating ~~ determineRatings(from: filter))
            .filter(\.$publishedOn <= Date())
            .sort(\.$publishedOn, .descending)
            .paginate(for: request)
    }
    
    /// Fetches a paginated list of works specific to an author based on the provided `ContentFilter`.
    /// If `published` is `true`, this will return only published works. Otherwise, this will return all
    /// works—published or unpublished.
    func fetchWorks(for authorId: String, published: Bool = false, filter: ContentFilter) async throws -> Page<Work> {
        let query = Work.query(on: request.db)
            .with(\.$author)
            .with(\.$tags) { tag in
                tag.with(\.$parent)
            }
            .filter(\.$author.$id == authorId)
        
        if published == true {
            return try await query
                .filter(\.$publishedOn <= Date())
                .filter(\.$rating ~~ determineRatings(from: filter))
                .sort(\.$publishedOn, .descending)
                .paginate(for: request)
        } else {
            return try await query
                .filter(\.$publishedOn == nil)
                .sort(\.$createdAt, .descending)
                .paginate(for: request)
        }
    }
    
    /// Creates a new work given the provided `formInfo`.
    func createWork(with formInfo: Work.WorkForm) async throws -> Work {
        let profile = try request.authService.getUser(withProfile: true).profile!
        let newWork = try Work(with: formInfo)
        return try await request.db.transaction { database in
            try await profile.$works.create(newWork, on: database)
            
            for tagId in formInfo.tags {
                guard let tag: Tag = try await Tag.query(on: database).filter(\.$id == tagId).first() else {
                    throw Abort(.notFound, reason: "One of the tags you tried to add does not exist. All tags must be valid.")
                }
                try await newWork.$tags.attach(tag, on: database)
            }
            
            newWork.$author.value = profile
            try await newWork.$tags.load(on: database)
            
            return newWork
        }
    }
    
    /// Updates a given work with the provided `formInfo`.
    func updateWork(_ id: String, with formInfo: Work.WorkForm) async throws -> Work {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await profile.$works.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "Could not find a work to update. Are you sure it exists?")
            }
            work.title = try SwiftSoup.clean(formInfo.title, .none())!
            work.shortDesc = try SwiftSoup.clean(formInfo.shortDesc, .none())!
            work.longDesc = try SwiftSoup.clean(formInfo.longDesc, defaultWhitelist())!
            work.category = formInfo.category
            work.rating = formInfo.rating
            work.status = formInfo.status
            work.kind = formInfo.kind
            try await work.save(on: database)
            
            try await work.$tags.detachAll(on: database)
            for tagId in formInfo.tags {
                guard let tag: Tag = try await Tag.query(on: database).filter(\.$id == tagId).first() else {
                    throw Abort(.notFound, reason: "One of the tags you tried to add does not exist. All tags must be valid.")
                }
                try await work.$tags.attach(tag, method: .ifNotExists, on: database)
            }
            work.$author.value = profile
            try await work.$tags.load(on: database)
            
            return work
        }
    }
    
    /// Updates a work's cover art with the given `coverUrl`.
    func updateCoverArt(_ id: String, coverUrl: String? = nil) async throws -> Work {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await profile.$works
                .query(on: database)
                .with(\.$tags, { $0.with(\.$parent) })
                .filter(\.$id == id)
                .first() else {
                throw Abort(.notFound, reason: "Could not find a work to update. Are you sure it exists?")
            }
            work.coverArt = coverUrl
            try await work.save(on: database)
            work.$author.value = profile
            return work
        }
    }
    
    /// Updates a work's banner art with the given `bannerUrl`.
    func updateBannerArt(_ id: String, bannerUrl: String? = nil) async throws -> Work {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await profile.$works.query(on: database).with(\.$tags, { $0.with(\.$parent)}).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "Could not find a work to update. Are you sure it exists?")
            }
            work.bannerArt = bannerUrl
            try await work.save(on: database)
            work.$author.value = profile
            try await work.$tags.load(on: database)
            return work
        }
    }
    
    /// Updates a work's word count.
    func updateWordCount(_ work: Work) async throws {
        let sections: [Section] = try await work.$sections.query(on: request.db).field(\.$words).filter(\.$publishedOn <= Date()).all()
        let wordCount: Int64 = sections.map({ $0.words }).reduce(0, +)
        try await request.db.transaction { database in
            work.words = wordCount
            try await work.save(on: database)
        }
    }
    
    /// Publishes a work by submitting it to the approval queue.
    func publishWork(_ id: String) async throws -> Response {
        try await request.approvalService.submitItem(id)
    }
    
    /// Hides/shows a work by messing with its publishing date. Throws if the work in question either doesn't exist or is not approved.
    func hideShow(_ id: String) async throws -> Response {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let work = try await profile.$works.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Could not find a work to update. Are you sure it exists?")
        }
        try await request.db.transaction { database in
            if work.approvalStatus == .approved {
                work.publishedOn = work.publishedOn == nil ? Date() : nil
                try await work.save(on: database)
            } else {
                throw Abort(.forbidden, reason: "Your work must be approved before this function becomes available.")
            }
        }
        return Response(status: .ok)
    }
    
    /// Deletes a work. Since all works have a `deletedAt` field, this deletion is just a soft delete for moderation purposes.
    func deleteWork(_ id: String) async throws {
        let profile = try request.authService.getUser(withProfile: true).profile!
        try await request.db.transaction { database in
            guard let work: Work = try await profile.$works.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "Could not find a work to delete. Are you sure it exists?")
            }
            try await work.delete(on: database)
        }
    }
    
    /// Fetches a new page of comments for the specified work.
    func fetchComments(for id: String, sectionId: String? = nil) async throws -> Page<Comment> {
        guard let work: Work = try await Work.query(on: request.db)
            .filter(\.$id == id)
            .first() else {
            throw Abort(.notFound, reason: "Work not found. Are you sure you're looking for the right one?")
        }
        if work.publishedOn != nil {
            var commentsQuery = work.$comments.query(on: request.db)
                .with(\.$profile)
                .with(\.$history)
                .sort(\.$createdAt, .ascending)
            if let hasSectionId = sectionId {
                commentsQuery = commentsQuery.filter(\.$section.$id == hasSectionId)
            }
            
            return try await commentsQuery.paginate(for: request)
        }
        throw Abort(.badRequest, reason: "This work is not published, so comments are inaccessible.")
    }
    
    /// Adds a comment to the specified work.
    func addComment(for id: String, with formInfo: Comment.CommentForm) async throws -> Comment {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let work: Work = try await Work.query(on: request.db)
            .filter(\.$id == id)
            .first() else {
            throw Abort(.notFound, reason: "The work you're commenting on doesn't seem to exist.")
        }
        if work.publishedOn != nil {
            let comment: Comment = try await request.db.transaction { database in
                let newComment = try Comment(by: profile.id!, with: formInfo)
                try await newComment.save(on: database)
                try await work.$comments.attach(newComment, on: database)
                newComment.$profile.value = profile
                try await newComment.$history.load(on: database)
                return newComment
            }
            let repliesTo = try await work.$comments.query(on: request.db).filter(\.$id ~~ formInfo.repliesTo).all()
            try await request.db.transaction { database in
                try await comment.$repliesTo.attach(repliesTo, on: database)
            }
            for reply in repliesTo {
                try await request.queue.dispatch(AddNotificationJob.self, .init(
                    to: reply.$profile.id,
                    from: comment.profile.id,
                    event: .newReply,
                    entity: comment.id,
                    context: ["title": work.title, "url": "\(formInfo.locationUrl)#comment-\(comment.id ?? "nil")"]
                ))
            }
            if work.$author.id != profile.id {
                try await request.queue.dispatch(AddNotificationJob.self, .init(
                    to: work.$author.id,
                    from: comment.profile.id,
                    event: .newWorkComment,
                    entity: work.id,
                    context: ["title": work.title, "url": "\(formInfo.locationUrl)#comment-\(comment.id ?? "nil")"]
                ))
            }
            return comment
        }
        throw Abort(.badRequest, reason: "Comments are disabled for drafts.")
    }
    
    /// Edits a work comment.
    func editComment(_ id: String, for itemId: String, with formInfo: Comment.CommentForm) async throws -> Comment {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let work: Work = try await Work.query(on: request.db)
            .filter(\.$id == id)
            .first() else {
            throw Abort(.notFound, reason: "The work you're commenting on doesn't seem to exist.")
        }
        if work.publishedOn != nil {
            guard let comment = try await work.$comments.query(on: request.db)
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
}

extension WorkService {
    struct FetchWork: Content {
        var work: Work
        var comments: Page<Comment>?
    }
}

extension Request {
    var workService: WorkService {
        .init(request: self)
    }
}
