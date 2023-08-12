//
//  Created by Alyx Mote on 7/31/23.
//

import Vapor
import Fluent
import SwiftSoup

struct ReadingService {
    let request: Request
    
    func fetchWork(_ id: String) async throws -> WorkPage {
        let profile = try request.authService.getUser(withProfile: true).profile
        guard let work: Work = try await Work.query(on: request.db)
            .with(\.$author)
            .with(\.$tags, { $0.with(\.$parent) })
            .filter(\.$id == id)
            .first()
        else {
            throw Abort(.notFound, reason: "Work not found. Are you sure you're looking for the right one?")
        }
        let tableOfContents = try await SectionList.query(on: request.db)
            .filter(\.$work.$id == work.requireID())
            .sort(\.$rank, .ascending)
            .all()
        if profile != nil {
            let readingHistory = try await request.libraryService.fetchHistory(work.id!)
            let libraryItem = try await request.libraryService.fetchLibraryItem(for: work.id!)
            try await request.workService.updateIpViews(for: work)
            return .init(
                work: work,
                tableOfContents: tableOfContents,
                readingHistory: readingHistory,
                libraryItem: libraryItem
            )
        }
        try await request.workService.updateIpViews(for: work)
        return .init(
            work: work,
            tableOfContents: tableOfContents,
            readingHistory: nil,
            libraryItem: nil
        )
    }
    
    func fetchSection(_ id: String) async throws -> SectionPage {
        let profile = try request.authService.getUser(withProfile: true).profile
        guard let section = try await SectionView.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "The section you're trying to view does not exist.")
        }
        let tableOfContents = try await SectionList.query(on: request.db)
            .filter(\.$work.$id == section.work.id)
            .sort(\.$rank, .ascending)
            .all()
        let topComments = try await SectionCommentView.query(on: request.db)
            .filter(\.$section.$id == section.id!)
            .limit(3)
            .sort(\.$likes, .descending)
            .all()
        if let hasProfile = profile {
            let readingHistory = try await request.libraryService.fetchHistory(section.work.id)
            let cheer = try await Cheer.query(on: request.db)
                .filter(\.$profile.$id == hasProfile.id!)
                .filter(\.$section.$id == section.id!)
                .first()
            let highlights = try await Highlight.query(on: request.db)
                .filter(\.$profile.$id == hasProfile.id!)
                .filter(\.$section.$id == section.id!)
                .all()
            let libraryItem = try await request.libraryService.fetchLibraryItem(for: section.work.id)
            try await request.workService.updateIpViews(for: section.work.id)
            return .init(
                section: section,
                tableOfContents: tableOfContents,
                readingHistory: readingHistory,
                highlights: highlights,
                cheer: cheer,
                topComments: topComments,
                libraryItem: libraryItem
            )
        }
        try await request.workService.updateIpViews(for: section.work.id)
        return .init(
            section: section,
            tableOfContents: tableOfContents,
            readingHistory: nil,
            highlights: [],
            cheer: nil,
            topComments: topComments,
            libraryItem: nil
        )
    }
    
    func fetchSectionComments(for sectionId: String) async throws -> FetchCommentsResponse {
        let profile = try request.authService.getUser(withProfile: true).profile
        let comments = try await SectionCommentView.query(on: request.db)
            .filter(\.$section.$id == sectionId)
            .sort(\.$createdAt, .ascending)
            .paginate(for: request)
        if profile != nil {
            var ids: [String] = []
            for comment in comments.items {
                ids.append(comment.$comment.id)
            }
            let votesPer = try await CommentVote.query(on: request.db)
                .filter(\.$comment.$id ~~ ids)
                .filter(\.$profile.$id == profile!.id!)
                .all()
            return .init(page: comments, votes: votesPer)
        }
        return .init(page: comments, votes: [])
    }
    
    func toggleCheer(for sectionId: String) async throws -> ToggleCheerResponse {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let section = try await Section.find(sectionId, on: request.db) else {
            throw Abort(.notFound, reason: "The section you're trying to modify does not exist.")
        }
        if section.publishedOn == nil {
            throw Abort(.methodNotAllowed, reason: "The section you're trying to modify is not published.")
        }
        if try await section.$cheers.query(on: request.db).filter(\.$profile.$id == profile.requireID()).first() == nil {
            // if this has not been cheered by this user before
            let newCheer = Cheer(by: try profile.requireID())
            try await request.db.transaction { database in
                try await section.$cheers.create(newCheer, on: database)
            }
            return ToggleCheerResponse(cheer: newCheer)
        } else {
            try await request.db.transaction { database in
                try await section.$cheers.query(on: database).filter(\.$profile.$id == profile.requireID()).delete()
            }
            return ToggleCheerResponse(cheer: nil)
        }
    }
    
    func addSectionComment(for sectionId: String, with formInfo: Comment.CommentForm) async throws -> SectionCommentView {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let section = try await Section.find(sectionId, on: request.db) else {
            throw Abort(.notFound, reason: "The section you're trying to modify does not exist.")
        }
        if section.publishedOn == nil {
            throw Abort(.methodNotAllowed, reason: "The section you're trying to modify is not published.")
        }
        let newComment = try Comment(by: try profile.requireID(), with: formInfo)
        try await request.db.transaction { database in
            try await section.$comments.attach(newComment, on: database)
        }
        guard let commentView = try await SectionCommentView.query(on: request.db).filter(\.$comment.$id == newComment.requireID()).first() else {
            throw Abort(.internalServerError, reason: "Something went wrong saving your comment! Try again in a little bit.")
        }
        return commentView
    }
    
    func editSectionComment(_ commentId: String, for sectionId: String, with formInfo: Comment.CommentForm) async throws -> SectionCommentView {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let section = try await Section.find(sectionId, on: request.db) else {
            throw Abort(.notFound, reason: "The comment you're trying to modify does not exist.")
        }
        guard let comment = try await section.$comments.query(on: request.db)
            .filter(\.$id == commentId)
            .filter(\.$profile.$id == profile.requireID())
            .first() else {
            throw Abort(.notFound, reason: "The comment you're trying to modify does not exist.")
        }
        let newHistory = CommentHistory(oldBody: comment.body)
        comment.body = try SwiftSoup.clean(formInfo.body, defaultWhitelist())!
        comment.spoiler = formInfo.spoiler
        try await request.db.transaction { database in
            try await comment.$history.create(newHistory, on: database)
            try await comment.save(on: database)
        }
        guard let commentView = try await SectionCommentView.query(on: request.db)
            .filter(\.$comment.$id == comment.requireID())
            .first() else {
            throw Abort(.internalServerError, reason: "Something went wrong saving your comment! Try again in a little bit.")
        }
        return commentView
    }
}

extension ReadingService {
    struct WorkPage: Content {
        let work: Work
        let tableOfContents: [SectionList]
        let readingHistory: ReadingHistory?
        let libraryItem: LibraryService.CheckLibrary?
    }
    
    struct SectionPage: Content {
        let section: SectionView
        let tableOfContents: [SectionList]
        let readingHistory: ReadingHistory?
        let highlights: [Highlight]
        let cheer: Cheer?
        let topComments: [SectionCommentView]
        let libraryItem: LibraryService.CheckLibrary?
    }
    
    struct ToggleCheerResponse: Content {
        let cheer: Cheer?
    }
    
    struct FetchCommentsResponse: Content {
        let page: Page<SectionCommentView>
        let votes: [CommentVote]
    }
}

extension Request {
    var readingService: ReadingService {
        .init(request: self)
    }
}
