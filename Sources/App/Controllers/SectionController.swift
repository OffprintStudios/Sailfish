//
//  Created by Alyx Mote on 11/14/22.
//

import Vapor
import Fluent

struct SectionController: RouteCollection {
    let noWorkIdReason = "You must include a `workId` query parameter with your request."
    
    func boot(routes: RoutesBuilder) throws {
        let sections = routes.grouped("sections")
        let sectionsWithAuth = sections.grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            StatusGuard()
        ])
        
        sections.get("fetch-section", ":id") { request async throws -> Section in
            let id = request.parameters.get("id")!
            let query = try request.query.decode(SectionQuery.self)
            if let hasWorkId = query.workId {
                return try await request.sectionService.fetchSection(id, for: hasWorkId)
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
        }
        
        sections.get("fetch-sections") { request async throws -> [Section] in
            let query = try request.query.decode(SectionQuery.self)
            if let workId = query.workId {
                return try await request.sectionService.fetchSections(
                    for: workId,
                    in: query.volumeId,
                    published: query.published != nil ? query.published! : false
                )
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
        }
        
        sectionsWithAuth.post("create-section") { request async throws -> Section in
            let query = try request.query.decode(SectionQuery.self)
            if let workId = query.workId {
                try Section.SectionForm.validate(content: request)
                let formInfo = try request.content.decode(Section.SectionForm.self)
                return try await request.sectionService.createSection(
                    for: workId,
                    in: query.volumeId,
                    with: formInfo
                )
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
        }
        
        sectionsWithAuth.patch("update-section", ":id") { request async throws -> Section in
            let query = try request.query.decode(SectionQuery.self)
            if let workId = query.workId {
                try Section.SectionForm.validate(content: request)
                let id = request.parameters.get("id")!
                let formInfo = try request.content.decode(Section.SectionForm.self)
                return try await request.sectionService.updateSection(id, for: workId, with: formInfo)
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
        }
        
        sectionsWithAuth.patch("publish-section", ":id") { request async throws -> Section in
            let query = try request.query.decode(SectionQuery.self)
            if let workId = query.workId {
                let id = request.parameters.get("id")!
                return try await request.sectionService.publishSection(id, for: workId)
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
        }
        
        sectionsWithAuth.delete("delete-section", ":id") { request async throws -> HTTPResponseStatus in
            let query = try request.query.decode(SectionQuery.self)
            if let workId = query.workId {
                let id = request.parameters.get("id")!
                try await request.sectionService.deleteSection(id, for: workId)
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
            
            return .ok
        }
        
        sectionsWithAuth.patch("move-section", ":id") { request async throws -> HTTPResponseStatus in
            let query = try request.query.decode(SectionQuery.self)
            if let workId = query.workId, let prev = query.prev, let next = query.next {
                let id = request.parameters.get("id")!
                try await request.sectionService.moveSection(id, for: workId, prev: prev, next: next)
            } else {
                throw Abort(.notFound, reason: "You need to include the `workId`, `prev` rank, and `next` rank in query parameters when making this request.")
            }
            
            return .ok
        }
    }
}

extension SectionController {
    struct SectionQuery: Content {
        var workId: String?
        var volumeId: String?
        var published: Bool?
        var prev: Int64?
        var next: Int64?
    }
}
