//
//  Created by Alyx Mote on 11/14/22.
//

import Vapor
import Fluent

struct VolumeController: RouteCollection {
    let noWorkIdReason = "You must include a `workId` query parameter with your request."
    
    func boot(routes: RoutesBuilder) throws {
        let volumes = routes.grouped("volumes")
        let volumesWithAuth = volumes.grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            BannedGuard()
        ])
        
        volumes.get("fetch-volumes") { request async throws -> [Volume] in
            let query = try request.query.decode(VolumeQuery.self)
            if let workId = query.workId {
                return try await request.volumeService.fetchVolumes(for: workId, status: query.status ?? .published)
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
        }
        
        volumesWithAuth.post("create-volume") { request async throws -> Volume in
            let query = try request.query.decode(VolumeQuery.self)
            if let workId = query.workId {
                try Volume.VolumeForm.validate(content: request)
                let formInfo = try request.content.decode(Volume.VolumeForm.self)
                return try await request.volumeService.createVolume(for: workId, with: formInfo)
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
        }
        
        volumesWithAuth.patch("update-volume", ":id") { request async throws -> Volume in
            let query = try request.query.decode(VolumeQuery.self)
            if let workId = query.workId {
                try Volume.VolumeForm.validate(content: request)
                let id = request.parameters.get("id")!
                let formInfo = try request.content.decode(Volume.VolumeForm.self)
                return try await request.volumeService.updateVolume(id, for: workId, with: formInfo)
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
        }
        
        volumesWithAuth.on(.PATCH, "update-cover", ":id", body: .collect(maxSize: "5mb")) { request async throws -> Volume in
            let query = try request.query.decode(VolumeQuery.self)
            if let workId = query.workId {
                let id = request.parameters.get("id")!
                let data = try request.content.decode(UtilityService.UploadImage.self)
                let coverUrl = try await request.utilityService.uploadImage(
                    data,
                    itemId: id,
                    folder: "volume-covers"
                )
                return try await request.volumeService.updateCoverArt(id, for: workId, coverUrl: coverUrl)
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
        }

        volumesWithAuth.patch("publish-volume", ":id") { request async throws -> Volume in
            let query = try request.query.decode(VolumeQuery.self)
            if let workId = query.workId {
                let id = request.parameters.get("id")!
                return try await request.volumeService.publishVolume(id, for: workId, on: query.release ?? Date())
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
        }
        
        volumesWithAuth.delete("delete-volume", ":id") { request async throws -> HTTPResponseStatus in
            let query = try request.query.decode(VolumeQuery.self)
            if let workId = query.workId {
                let id = request.parameters.get("id")!
                try await request.volumeService.deleteVolume(id, for: workId)
            } else {
                throw Abort(.badRequest, reason: noWorkIdReason)
            }
            return .ok
        }
    }
}

extension VolumeController {
    struct VolumeQuery: Content {
        var workId: String?
        var release: Date?
        var status: VolumeService.FetchStatus?
    }
}
