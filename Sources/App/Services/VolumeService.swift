//
//  Created by Alyx Mote on 11/14/22.
//

import Foundation
import Vapor
import Fluent
import SwiftSoup

struct VolumeService {
    let request: Request
    
    /// Fetches all volumes for a given work.
    func fetchVolumes(for workId: String, on release: Date? = nil) async throws -> [Volume] {
        let query = Volume.query(on: request.db).filter(\.$work.$id == workId).sort(\.$createdAt, .ascending)
        if let released = release {
            return try await query.filter(\.$publishedOn <= released).all()
        } else {
            return try await query.all()
        }
    }
    
    /// Creates a new volume for the provided `workId`.
    func createVolume(for workId: String, with formInfo: Volume.VolumeForm) async throws -> Volume {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await profile.$works.query(on: database).filter(\.$id == workId).first() else {
                throw Abort(.notFound, reason: "The work you're trying to modify doesn't exist.")
            }
            let newVolume = try Volume(with: formInfo)
            try await work.$volumes.create(newVolume, on: database)
            return newVolume
        }
    }
    
    /// Updates a volume for the provided `workId`.
    func updateVolume(_ id: String, for workId: String, with formInfo: Volume.VolumeForm) async throws -> Volume {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await profile.$works.query(on: database).filter(\.$id == workId).first() else {
                throw Abort(.notFound, reason: "The work you're trying to modify doesn't exist.")
            }
            guard let volume: Volume = try await work.$volumes.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The volume you're trying to modify doesn't exist.")
            }
            volume.title = try SwiftSoup.clean(formInfo.title, .none())!
            volume.desc = try SwiftSoup.clean(formInfo.desc, .none())!
            try await volume.save(on: database)
            return volume
        }
    }
    
    /// Updates a volume's cover art.
    func updateCoverArt(_ id: String, for workId: String, coverUrl: String) async throws -> Volume {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await profile.$works.query(on: database).filter(\.$id == workId).first() else {
                throw Abort(.notFound, reason: "The work you're trying to modify doesn't exist.")
            }
            guard let volume: Volume = try await work.$volumes.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The volume you're trying to modify doesn't exist.")
            }
            volume.coverArt = coverUrl
            try await volume.save(on: database)
            return volume
        }
    }

    /// Publishes a volume and all its associated sections with the given release date.
    func publishVolume(_ id: String, for workId: String, on release: Date? = nil) async throws -> Volume {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await profile.$works.query(on: database).filter(\.$id == workId).first() else {
                throw Abort(.notFound, reason: "The work you're trying to modify doesn't exist.")
            }
            guard let volume: Volume = try await work.$volumes.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The volume you're trying to modify doesn't exist.")
            }
            let sections: [Section] = try await volume.$sections.query(on: database).all()
            for section in sections {
                if (section.publishedOn == nil) {
                    section.publishedOn = release
                    try await section.save(on: database)
                }
            }
            volume.publishedOn = release
            try await volume.save(on: database)
            return volume
        }
    }
    
    /// Deletes a volume from a work.
    func deleteVolume(_ id: String, for workId: String) async throws {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            guard let work: Work = try await profile.$works.query(on: database).filter(\.$id == workId).first() else {
                throw Abort(.notFound, reason: "The work you're trying to modify doesn't exist.")
            }
            guard let volume: Volume = try await work.$volumes.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The volume you're trying to modify doesn't exist.")
            }
            try await volume.delete(on: database)
        }
    }
}

extension Request {
    var volumeService: VolumeService {
        .init(request: self)
    }
}
