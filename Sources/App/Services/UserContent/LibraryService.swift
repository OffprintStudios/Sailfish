//
//  Created by Alyx Mote on 12/11/22.
//

import Foundation
import Vapor
import Fluent
import SwiftSoup

struct LibraryService {
    let request: Request
    
    /// Fetches a user's library.
    func fetchLibrary() async throws -> Page<Work> {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await profile.$library.query(on: request.db).paginate(for: request)
    }
    
    /// Returns any available library item to verify if a user already has the specified work in their library. Returns `nil` if
    /// no item is found.
    func fetchLibraryItem(for workId: String) async throws -> CheckLibrary {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let work = try await Work.find(workId, on: request.db) else {
            throw Abort(.notFound, reason: "The work you're trying to find does not exist.")
        }
        return .init(hasItem: try await profile.$library.isAttached(to: work, on: request.db))
    }
    
    /// Fetches a user's reading history.
    func fetchHistory() async throws -> Page<ReadingHistory> {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await profile.$history.query(on: request.db).with(\.$work).paginate(for: request)
    }
    
    /// Updates an existing `ReadingHistory` row with a new `viewedOn` value. If no row exists, creates a new one. In both cases, this
    /// will return the `ReadingHistory` data.
    func fetchHistory(_ workId: String) async throws -> ReadingHistory {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await Work.find(workId, on: database) else {
                throw Abort(.notFound, reason: "Couldn't find the work you're looking for.")
            }
            guard let existingHistory: ReadingHistory = try await profile.$history
                .query(on: database)
                .filter(\.$work.$id == work.id!)
                .first() else {
                let newHistory = ReadingHistory(workId: work.id!)
                try await profile.$history.create(newHistory, on: database)
                return newHistory
            }
            existingHistory.viewedOn = Date()
            try await existingHistory.save(on: database)
            return existingHistory
        }
    }
    
    /// Fetches a user's progress on the last thing they opened.
    func fetchLatestProgress() async throws -> CheckProgress {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            let historyInfo = try await profile.$history.query(on: database)
                .with(\.$work) { $0.with(\.$author) }
                .sort(\.$viewedOn, .descending)
                .first()
            if let history = historyInfo {
                let numSections = try await history.work.$sections.query(on: database).filter(\.$publishedOn <= Date()).count()
                if numSections > 0 {
                    let progress = history.sectionsRead.count / numSections
                    return CheckProgress(history: history, progress: Int32(progress))
                } else {
                    throw Abort(.expectationFailed, reason: "How could you have read anything if there's nothing to read?")
                }
            } else {
                throw Abort(.expectationFailed, reason: "For some reason, this work was never recorded in your reading history.")
            }
        }
    }
    
    /// Fetches all a user's shelves, while also checking to see if the given work ID is already attached to any of them.
    func fetchShelves(check workId: String) async throws -> [CheckShelf] {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let work = try await Work.find(workId, on: request.db) else {
            throw Abort(.notFound, reason: "The work you're trying to check for doesn't exist.")
        }
        let shelves: [Shelf] = try await profile.$shelves.query(on: request.db).all()
        var checkedShelves: [CheckShelf] = []
        for shelf in shelves {
            let hasItem = try await shelf.$items.isAttached(to: work, on: request.db)
            checkedShelves.append(CheckShelf(shelf: shelf, hasItem: hasItem))
        }
        return checkedShelves
    }
    
    /// Fetches shelves belonging to a specific user. If `isPublic` is `true`, this will fetch only public shelves.
    func fetchShelves(for profileId: String, onlyPublic: Bool = false) async throws -> Page<Shelf> {
        var query = Shelf.query(on: request.db)
            .filter(\.$profile.$id == profileId)
        
        if onlyPublic == true {
            query = query.filter(\.$isPublic == true)
        }
        
        return try await query.paginate(for: request)
    }
    
    /// Fetches a single shelf for a given user.
    func fetchShelf(_ id: String) async throws -> Shelf {
        guard let shelf = try await Shelf.find(id, on: request.db) else {
            throw Abort(.notFound, reason: "The shelf you're trying to access doesn't exist.")
        }
        return shelf
    }
    
    /// Fetches works belonging to a specific shelf. If no shelf exists, throws a `notFound` error.
    func fetchShelfItems(for shelfId: String) async throws -> Page<Work> {
        let shelf = try await Shelf.find(shelfId, on: request.db)
        if let hasShelf = shelf {
            return try await hasShelf.$items.query(on: request.db).paginate(for: request)
        } else {
            throw Abort(.notFound, reason: "The shelf you're trying to access doesn't exist.")
        }
    }
    
    /// Adds a work to a user's library. If the work doesn't exist, throws a `notFound` error. If the work *does* exist, but is already added,
    /// returns a `conflict` error.
    func addToLibrary(_ workId: String) async throws -> CheckLibrary {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await Work.find(workId, on: database) else {
                throw Abort(.notFound, reason: "Couldn't find the work you're looking for.")
            }
            if try await profile.$library.isAttached(to: work, on: database) == true {
                throw Abort(.conflict, reason: "You've already added this work to your library!")
            }
            try await profile.$library.attach(work, on: database)
            return CheckLibrary(hasItem: true)
        }
    }
    
    /// Removes a work from a user's library. If the work doesn't exist, throws a `notFound` error. If the work *does* exist, but isn't in
    /// the user's library, returns a `conflict` error.
    func removeFromLibrary(_ workId: String) async throws -> CheckLibrary {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await Work.find(workId, on: database) else {
                throw Abort(.notFound, reason: "Couldn't find the work you're looking for.")
            }
            if try await profile.$library.isAttached(to: work, on: database) == false {
                throw Abort(.conflict, reason: "This work isn't even in your library yet!")
            }
            try await profile.$library.detach(work, on: database)
            return CheckLibrary(hasItem: false)
        }
    }
    
    /// Hides a history row from view by the user. Naughty naughty.
    func hideHistory(_ id: UUID) async throws -> Response {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let history = try await profile.$history.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The history you're trying to edit doesn't exist.")
            }
            history.isPublic = false
            try await history.save(on: database)
            return Response(status: .ok)
        }
    }
    
    /// Sets the vote value for a user's reading history regarding a particular work. Also updates that work's `likes` and `dislikes` with
    /// their latest values.
    func setVote(for workId: String, vote: ReadingHistory.Vote) async throws -> ReadingHistory {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await Work.find(workId, on: database) else {
                throw Abort(.notFound, reason: "Couldn't find the work you're looking for.")
            }
            guard let historyInfo: ReadingHistory = try await profile.$history.query(on: database)
                .filter(\.$work.$id == work.id!)
                .first() else {
                throw Abort(.expectationFailed, reason: "For some reason, this work was never recorded in your reading history.")
            }
            historyInfo.vote = vote
            historyInfo.voteChanged = Date()
            try await historyInfo.save(on: database)
            work.likes = Int64(try await work.$votes.query(on: database).filter(\.$vote == ReadingHistory.Vote.liked).count())
            work.dislikes = Int64(try await work.$votes.query(on: database).filter(\.$vote == ReadingHistory.Vote.disliked).count())
            try await work.save(on: database)
            return historyInfo
        }
    }
    
    /// Bookmarks a section. If there's already a bookmark, this will just overwrite that one.
    func setSectionAsBookmark(_ sectionId: String, for workId: String) async throws -> ReadingHistory {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let section: Section = try await Section.query(on: database).filter(\.$id == sectionId).filter(\.$publishedOn != nil).first() else {
                throw Abort(.notFound, reason: "The section you're trying to bookmark doesn't exist.")
            }
            guard let historyInfo: ReadingHistory = try await profile.$history.query(on: database).filter(\.$work.$id == workId).first() else {
                throw Abort(.expectationFailed, reason: "For some reason, this work was never recorded in your reading history.")
            }
            historyInfo.$bookmarked.id = try section.requireID()
            try await historyInfo.save(on: database)
            return historyInfo
        }
    }
    
    /// Sets a section as read by adding its ID to the `sectionsRead` array of a user's `ReadingHistory`. If the section is already read (i.e already present in the array),
    /// this will ignore any potential changes and just return the unchanged `ReadingHistory` data.
    func setSectionAsRead(_ sectionId: String, for workId: String) async throws -> ReadingHistory {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let section: Section = try await Section.query(on: database).filter(\.$id == sectionId).filter(\.$publishedOn != nil).first() else {
                throw Abort(.notFound, reason: "The section you're trying to bookmark doesn't exist.")
            }
            guard let historyInfo: ReadingHistory = try await profile.$history.query(on: database).filter(\.$work.$id == workId).first() else {
                throw Abort(.expectationFailed, reason: "For some reason, this work was never recorded in your reading history.")
            }
            if historyInfo.sectionsRead.contains(section.id!)  {
                return historyInfo
            }
            historyInfo.sectionsRead.append(section.id!)
            try await historyInfo.save(on: database)
            return historyInfo
        }
    }
    
    /// Creates a new shelf with the specified `formInfo`.
    func createShelf(with formInfo: Shelf.ShelfForm) async throws -> Shelf {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            let newShelf = try Shelf(with: formInfo)
            try await profile.$shelves.create(newShelf, on: database)
            return newShelf
        }
    }
    
    /// Updates a shelf given the info provided in `formInfo`.
    func updateShelf(_ id: String, with formInfo: Shelf.ShelfForm) async throws -> Shelf {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let shelf = try await profile.$shelves.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The shelf you're trying to modify does not exist.")
            }
            shelf.name = try SwiftSoup.clean(formInfo.name, .none())!
            if let desc = formInfo.desc {
                shelf.desc = try SwiftSoup.clean(desc, .none())!
            }
            shelf.isPublic = formInfo.isPublic
            try await shelf.save(on: database)
            return shelf
        }
    }
    
    /// Adds a work to a shelf.
    func addToShelf(_ workId: String, to shelfId: String) async throws -> CheckShelf {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await Work.find(workId, on: database) else {
                throw Abort(.notFound, reason: "Couldn't find the work you're looking for.")
            }
            guard let shelf = try await profile.$shelves.query(on: database).filter(\.$id == shelfId).first() else {
                throw Abort(.notFound, reason: "The shelf you're trying to modify does not exist.")
            }
            if try await shelf.$items.isAttached(to: work, on: database) == true {
                throw Abort(.conflict, reason: "You've already added this work to this shelf!")
            }
            try await shelf.$items.attach(work, on: database)
            return CheckShelf(shelf: shelf, hasItem: true)
        }
    }
    
    /// Removes a work from a shelf.
    func removeFromShelf(_ workId: String, from shelfId: String) async throws -> CheckShelf {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await Work.find(workId, on: database) else {
                throw Abort(.notFound, reason: "Couldn't find the work you're looking for.")
            }
            guard let shelf = try await profile.$shelves.query(on: database).filter(\.$id == shelfId).first() else {
                throw Abort(.notFound, reason: "The shelf you're trying to modify does not exist.")
            }
            if try await shelf.$items.isAttached(to: work, on: database) == false {
                throw Abort(.conflict, reason: "This work isn't on this shelf to begin with!")
            }
            try await shelf.$items.detach(work, on: database)
            return CheckShelf(shelf: shelf, hasItem: false)
        }
    }
    
    /// Soft-deletes a shelf. As this does not fully remove the shelf from the database, any existing works attached to it are not detached. This behavior
    /// may change in the future, though.
    func deleteShelf(_ shelfId: String) async throws -> Response {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let shelf = try await profile.$shelves.query(on: database).filter(\.$id == shelfId).first() else {
                throw Abort(.notFound, reason: "The shelf you're trying to modify does not exist.")
            }
            try await shelf.delete(on: database)
            return Response(status: .ok)
        }
    }
}

extension LibraryService {
    struct CheckLibrary: Content {
        var hasItem: Bool
    }
    
    struct CheckShelf: Content {
        var shelf: Shelf
        var hasItem: Bool
    }
    
    struct CheckProgress: Content {
        var history: ReadingHistory
        var progress: Int32
    }
}

extension Request {
    var libraryService: LibraryService {
        .init(request: self)
    }
}
