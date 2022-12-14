//
//  Created by Alyx Mote on 11/13/22.
//

import Foundation
import Vapor
import Fluent
import SwiftSoup

struct SectionService {
    let request: Request
    
    /// Fetches a single section belonging to a work given the specified `workId`.
    func fetchSection(_ id: String, for workId: String) async throws -> Section {
        return try await request.db.transaction { database in
            guard let work: Work = try await Work.query(on: database).filter(\.$id == workId).first() else {
                throw Abort(.notFound, reason: "The section you're trying to fetch belongs to a work that doesn't exist.")
            }
            guard let section: Section = try await work.$sections.query(on: database)
                .with(\.$volume)
                .filter(\.$id == id)
                .first() else {
                throw Abort(.notFound, reason: "The section you're trying to fetch doesn't exist.")
            }
            
            if work.publishedOn != nil && section.publishedOn != nil {
                work.views += 1
                try await work.save(on: database)
            }
            
            return section
        }
    }
    
    /// Fetches sections of a work sorted by their rank.
    func fetchSections(for workId: String, in volumeId: String? = nil, published: Bool = false) async throws -> [SectionInfo] {
        return try await request.db.transaction { database in
            guard let work: Work = try await Work.query(on: database).filter(\.$id == workId).first() else {
                throw Abort(.notFound, reason: "The work you're trying to query doesn't exist.")
            }
            
            let query = work.$sections.query(on: database)
                .with(\.$volume)
                .sort(\.$rank, .ascending)
            
            if let volId = volumeId {
                if published == true {
                    let results: [Section] = try await query.filter(\.$volume.$id == volId).filter(\.$publishedOn <= Date()).all()
                    return results.map { item in
                        SectionInfo(from: item, with: item.volume)
                    }
                } else {
                    let results: [Section] = try await query.filter(\.$volume.$id == volId).all()
                    return results.map { item in
                        SectionInfo(from: item, with: item.volume)
                    }
                }
            } else {
                if published == true {
                    let results: [Section] = try await query.filter(\.$publishedOn <= Date()).all()
                    return results.map { item in
                        SectionInfo(from: item, with: item.volume)
                    }
                } else {
                    let results: [Section] = try await query.all()
                    return results.map { item in
                        SectionInfo(from: item, with: item.volume)
                    }
                }
            }
        }
    }
    
    /// Creates a new section for the given `workId` with the provided `formInfo`. If a `volumeId` is also present, this will automatically
    /// add the section to that volume.
    func createSection(for workId: String, in volumeId: String? = nil, with formInfo: Section.SectionForm) async throws -> Section {
        return try await request.db.transaction { database in
            let profile: Profile = try request.authService.getUser(withProfile: true).profile!
            guard let work: Work = try await profile.$works.query(on: database).filter(\.$id == workId).first() else {
                throw Abort(.notFound, reason: "The work you're trying to query doesn't exist.")
            }
            
            if let highestRank = try await work.$sections.query(on: database).max(\.$rank) {
                let newSection = try Section(with: formInfo, in: volumeId, rank: highestRank + 1000)
                try await work.$sections.create(newSection, on: database)
                return newSection
            } else {
                let newSection = try Section(with: formInfo, in: volumeId, rank: 1000)
                try await work.$sections.create(newSection, on: database)
                return newSection
            }
        }
    }
    
    /// Updates a section belonging to a work given the provided `formInfo`.
    func updateSection(_ id: String, for workId: String, with formInfo: Section.SectionForm) async throws -> Section {
        let profile: Profile = try request.authService.getUser(withProfile: true).profile!
        guard let work: Work = try await profile.$works.query(on: request.db).filter(\.$id == workId).first() else {
            throw Abort(.notFound, reason: "The work you're trying to update doesn't exist.")
        }
        let section: Section = try await request.db.transaction { database in
            guard let section: Section = try await work.$sections.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The section you're trying to edit doesn't exist.")
            }
            section.title = try SwiftSoup.clean(formInfo.title, .none())!
            section.body = try SwiftSoup.clean(formInfo.body, defaultWhitelist())!
            if let noteTop = formInfo.noteTop {
                section.noteTop = try SwiftSoup.clean(noteTop, defaultWhitelist())!
            }
            if let noteBottom = formInfo.noteBottom {
                section.noteBottom = try SwiftSoup.clean(noteBottom, defaultWhitelist())!
            }
            section.words = Int64(try SwiftSoup.clean(formInfo.body, Whitelist.none())!.split { !$0.isLetter }.count)
            try await section.save(on: database)
            return section
        }
        try await request.workService.updateWordCount(work)
        return section
    }
    
    /// Publishes a section if unpublished, unpublishes a section if published. If a section becomes published here, the parent work will have its wordcount updated to reflect it.
    func publishSection(_ id: String, for workId: String) async throws -> Section {
        let profile: Profile = try request.authService.getUser(withProfile: true).profile!
        guard let work: Work = try await profile.$works.query(on: request.db).filter(\.$id == workId).first() else {
            throw Abort(.notFound, reason: "The work you're trying to update doesn't exist.")
        }
        let section: Section = try await request.db.transaction { database in
            guard let section: Section = try await work.$sections.query(on: database).with(\.$volume).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The section you're trying to edit doesn't exist.")
            }
            if section.publishedOn != nil {
                // if it already has a publish date
                section.publishedOn = nil
            } else {
                // if it doesn't already have a publish date
                let pubDate = Date()
                section.publishedOn = pubDate
                if section.firstPublished == nil {
                    section.firstPublished = pubDate
                    if work.publishedOn != nil {
                        work.lastSectionUpdate = pubDate
                    }
                }
            }
            try await section.save(on: database)
            try await work.save(on: database)
            return section
        }
        try await request.workService.updateWordCount(work)
        return section
    }
    
    /// Adds a section to a volume
    func addToVolume(_ id: String, volumeId: String, for workId: String) async throws -> SectionInfo {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let work: Work = try await profile.$works.query(on: request.db).filter(\.$id == workId).first() else {
            throw Abort(.notFound, reason: "The work you're trying to update doesn't exist.")
        }
        guard let section: Section = try await work.$sections.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "The section you're trying to modify doesn't exist.")
        }
        guard let volume: Volume = try await work.$volumes.query(on: request.db).filter(\.$id == volumeId).first() else {
            throw Abort(.notFound, reason: "The volume you're trying to modify doesn't exist.")
        }
        section.$volume.id = volume.id!
        try await request.db.transaction { database in
            try await section.save(on: database)
        }
        return .init(from: section, with: volume)
    }
    
    /// Removes a volume from a work
    func removeFromVolume(_ id: String, for workId: String) async throws -> SectionInfo {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let work: Work = try await profile.$works.query(on: request.db).filter(\.$id == workId).first() else {
            throw Abort(.notFound, reason: "The work you're trying to update doesn't exist.")
        }
        guard let section: Section = try await work.$sections.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "The section you're trying to modify doesn't exist.")
        }
        section.$volume.id = nil
        try await request.db.transaction { database in
            try await section.save(on: database)
        }
        return .init(from: section, with: nil)
    }
    
    /// Deletes a section from a work.
    func deleteSection(_ id: String, for workId: String) async throws {
        let profile: Profile = try request.authService.getUser(withProfile: true).profile!
        guard let work: Work = try await profile.$works.query(on: request.db).filter(\.$id == workId).first() else {
            throw Abort(.notFound, reason: "The work you're trying to update doesn't exist.")
        }
        try await request.db.transaction { database in
            guard let section: Section = try await work.$sections.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The section you're trying to edit doesn't exist.")
            }
            try await section.delete(on: database)
        }
        try await request.workService.updateWordCount(work)
    }
    
    /// Moves a section between two other sections given their ranks.
    func moveSection(_ id: String, for workId: String, prev: Int64, next: Int64) async throws {
        // TODO: this needs to be updated to check if the new rank is already taken before saving
        return try await request.db.transaction { database in
            let profile: Profile = try request.authService.getUser(withProfile: true).profile!
            guard let work: Work = try await profile.$works.query(on: database).filter(\.$id == workId).first() else {
                throw Abort(.notFound, reason: "The work you're trying to update doesn't exist.")
            }
            guard let section: Section = try await work.$sections.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The section you're trying to edit doesn't exist.")
            }
            section.rank = (prev + next) / 2
            try await section.save(on: database)
        }
    }
}

extension SectionService {
    struct SectionInfo: Content {
        var id: String?
        var title: String
        var words: Int64
        var lang: Language
        var rank: Int64
        var publishedOn: Date?
        var createdAt: Date?
        var volume: Volume?

        init(from section: Section, with volume: Volume? = nil) {
            id = section.id
            title = section.title
            words = section.words
            lang = section.lang
            rank = section.rank
            publishedOn = section.publishedOn
            createdAt = section.createdAt
            self.volume = volume
        }
    }
}

extension Request {
    var sectionService: SectionService {
        .init(request: self)
    }
}
