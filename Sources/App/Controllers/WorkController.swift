//
//  Created by Alyx Mote on 11/14/22.
//

import Vapor
import Fluent

struct WorkController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let works = routes.grouped("works")
        let worksWithAuth = works.grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            StatusGuard()
        ])
        
        works.get("fetch-work", ":id") { request async throws -> Work in
            let id = request.parameters.get("id")!
            return try await request.workService.fetchWork(id)
        }
        
        works.get("fetch-works") { request async throws -> Page<Work> in
            let query = try request.query.decode(FetchWorksQuery.self)
            if let authorId = query.authorId, let status = query.published {
                return try await request.workService.fetchWorks(for: authorId, published: status, filter: query.filter ?? .restricted)
            } else if let authorId = query.authorId {
                return try await request.workService.fetchWorks(for: authorId, published: true, filter: query.filter ?? .restricted)
            } else {
                return try await request.workService.fetchWorks(filter: query.filter ?? .restricted)
            }
        }
        
        worksWithAuth.post("create-work") { request async throws -> Work in
            try Work.WorkForm.validate(content: request)
            let workForm = try request.content.decode(Work.WorkForm.self)
            return try await request.workService.createWork(with: workForm)
        }
        
        worksWithAuth.patch("update-work", ":id") { request async throws -> Work in
            let id = request.parameters.get("id")!
            try Work.WorkForm.validate(content: request)
            let workForm = try request.content.decode(Work.WorkForm.self)
            return try await request.workService.updateWork(id, with: workForm)
        }
        
        worksWithAuth.on(.PATCH, "update-cover", ":id", body: .collect(maxSize: "5mb")) { request async throws -> Work in
            let id = request.parameters.get("id")!
            let data = try request.content.decode(UtilityService.UploadImage.self)
            let coverUrl = try await request.utilityService.uploadImage(
                data,
                itemId: id,
                folder: "coverart"
            )
            return try await request.workService.updateCoverArt(id, coverUrl: coverUrl)
        }
        
        worksWithAuth.on(.PATCH, "update-banner", ":id", body: .collect(maxSize: "5mb")) { request async throws -> Work in
            let id = request.parameters.get("id")!
            let data = try request.content.decode(UtilityService.UploadImage.self)
            let coverUrl = try await request.utilityService.uploadImage(
                data,
                itemId: id,
                folder: "work-banners"
            )
            return try await request.workService.updateCoverArt(id, coverUrl: coverUrl)
        }
        
        // TODO: Add publishing route here
        // worksWithAuth.post("publish-work", ":id") { request async throws in }
        
        worksWithAuth.delete("delete-work", ":id") { request async throws -> HTTPResponseStatus in
            let id = request.parameters.get("id")!
            try await request.workService.deleteWork(id)
            return .ok
        }
    }
}

extension WorkController {
    struct FetchWorksQuery: Content {
        var authorId: String?
        var published: Bool?
        var filter: ContentFilter?
        var page: Int?
        var per: Int?
    }
}
