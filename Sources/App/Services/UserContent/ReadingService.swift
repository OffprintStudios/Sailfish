//
//  Created by Alyx Mote on 7/31/23.
//

import Vapor
import Fluent

struct ReadingService {
    let request: Request
    
    func fetchWork(id: String) async throws -> WorkPage {
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
    
    func fetchSection(id: String) async throws -> SectionPage {
        let profile = try request.authService.getUser(withProfile: true).profile
        guard let section = try await SectionView.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "The section you're trying to view does not exist.")
        }
        let tableOfContents = try await SectionList.query(on: request.db)
            .filter(\.$work.$id == section.work.id)
            .sort(\.$rank, .ascending)
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
            try await request.workService.updateIpViews(for: section.work.id)
            return .init(
                section: section,
                tableOfContents: tableOfContents,
                readingHistory: readingHistory,
                highlights: highlights,
                cheer: cheer
            )
        }
        try await request.workService.updateIpViews(for: section.work.id)
        return .init(
            section: section,
            tableOfContents: tableOfContents,
            readingHistory: nil,
            highlights: [],
            cheer: nil
        )
    }
}

extension ReadingService {
    struct WorkPage {
        let work: Work
        let tableOfContents: [SectionList]
        let readingHistory: ReadingHistory?
        let libraryItem: LibraryService.CheckLibrary?
    }
    
    struct SectionPage {
        let section: SectionView
        let tableOfContents: [SectionList]
        let readingHistory: ReadingHistory?
        let highlights: [Highlight]
        let cheer: Cheer?
    }
}

extension Request {
    var readingService: ReadingService {
        .init(request: self)
    }
}
