//
//  Created by Alyx Mote on 12/12/22.
//

import Vapor
import Fluent

struct HistoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let history = routes.grouped("history")
            .grouped([
                IdentityGuard(needs: [.user], checkProfile: true),
                ConfirmationGuard(),
                BannedGuard(),
            ])
        
        history.get("fetch-all") { request async throws -> Page<ReadingHistory> in
            try await request.libraryService.fetchHistory()
        }
        
        history.get("fetch-one") { request async throws -> ReadingHistory in
            let workId: String? = request.query["workId"]
            if let id = workId {
                return try await request.libraryService.fetchHistory(id)
            }
            throw Abort(.badRequest, reason: "You must include the work ID in your request.")
        }
        
        history.get("fetch-latest-progress") { request async throws -> LibraryService.CheckProgress in
            try await request.libraryService.fetchLatestProgress()
        }
        
        history.patch("set-vote") { request async throws -> ReadingHistory in
            let workId: String? = request.query["workId"]
            if let id = workId {
                try ReadingHistory.ChangeVote.validate(content: request)
                let voteChange = try request.content.decode(ReadingHistory.ChangeVote.self)
                return try await request.libraryService.setVote(for: id, vote: voteChange.vote)
            }
            throw Abort(.badRequest, reason: "You must include the work ID in your request.")
        }
        
        history.patch("set-bookmark") { request async throws -> ReadingHistory in
            let workId: String? = request.query["workId"]
            let sectionId: String? = request.query["sectionId"]
            if let work = workId, let section = sectionId {
                return try await request.libraryService.setSectionAsBookmark(section, for: work)
            }
            throw Abort(.badRequest, reason: "You must include the work ID and section ID in your request.")
        }
        
        history.patch("set-as-read") { request async throws -> ReadingHistory in
            let workId: String? = request.query["workId"]
            let sectionId: String? = request.query["sectionId"]
            if let work = workId, let section = sectionId {
                return try await request.libraryService.setSectionAsRead(section, for: work)
            }
            throw Abort(.badRequest, reason: "You must include the work ID and section ID in your request.")
        }
        
        history.patch("hide") { request async throws -> Response in
            struct HideHistoryQuery: Content {
                var id: UUID?
            }
            
            let info = try request.content.decode(HideHistoryQuery.self)
            if let id = info.id {
                return try await request.libraryService.hideHistory(id)
            }
            throw Abort(.badRequest, reason: "You must include the history ID in your request.")
        }
    }
}
