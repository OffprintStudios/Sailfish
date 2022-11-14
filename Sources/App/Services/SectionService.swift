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
            guard let section: Section = try await work.$sections.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The section you're trying to fetch doesn't exist.")
            }
            
            if work.publishedOn != nil && section.publishedOn != nil {
                work.views += 1
                try await work.save(on: database)
            }
            
            return section
        }
    }
    
    /// Fetches sections of a work sorted by their rank, as determined via LexoRank.
    func fetchSections(for workId: String, in volumeId: String? = nil) async throws -> [Section] {
        return try await request.db.transaction { database in
            guard let work: Work = try await Work.query(on: database).filter(\.$id == workId).first() else {
                throw Abort(.notFound, reason: "The work you're trying to query doesn't exist.")
            }
            
            let query = work.$sections.query(on: database)
                .field(\.$id)
                .field(\.$title)
                .field(\.$words)
                .field(\.$lang)
                .field(\.$rank)
                .field(\.$publishedOn)
                .field(\.$createdAt)
                .sort(\.$rank, .ascending)
            
            if let volId = volumeId {
                return try await query.filter(\.$volume.$id == volId).all()
            } else {
                return try await query.all()
            }
        }
    }
}

extension Request {
    var sectionService: SectionService {
        .init(request: self)
    }
}
