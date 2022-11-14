//
// Created by Alyx Mote on 11/12/22.
//

import Foundation
import Vapor
import Fluent
import LexoRank
import SwiftSoup

struct WorkService {
    let request: Request

    /// Fetches a work given its ID. If no such work exists, throws a `notFound` error.
    func fetchWork(_ id: String) async throws -> Work {
        try await request.db.transaction { database in
            let work = try await Work.query(on: database)
                .with(\.$author)
                .with(\.$tags) { tag in
                    tag.with(\.$parent)
                }
                .filter(\.$id == id)
                .first()
            
            if let hasWork = work {
                if hasWork.publishedOn != nil {
                    hasWork.views += 1
                    try await hasWork.save(on: database)
                }
                return hasWork
            } else {
                throw Abort(.notFound, reason: "Work not found. Are you sure you're looking for the right one?")
            }
        }
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
            .filter(\.$rating ~~ determineRatings(from: filter))
        
        if published == true {
            return try await query
                .filter(\.$publishedOn == nil)
                .sort(\.$createdAt, .descending)
                .paginate(for: request)
        } else {
            return try await query
                .filter(\.$publishedOn <= Date())
                .sort(\.$publishedOn, .descending)
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
            guard let work: Work = try await profile.$works.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "Could not find a work to update. Are you sure it exists?")
            }
            work.coverArt = coverUrl
            try await work.save(on: database)
            work.$author.value = profile
            try await work.$tags.load(on: database)
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
            return work
        }
    }
    
    // TODO: Add publishing functions here
    // func publishWork(_ id: String) {}
    
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
}

extension Request {
    var workService: WorkService {
        .init(request: self)
    }
}
