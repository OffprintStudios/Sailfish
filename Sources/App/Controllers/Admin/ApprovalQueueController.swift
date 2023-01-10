//
//  Created by Alyx Mote on 12/12/22.
//

import Vapor
import Fluent

struct ApprovalQueueController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let queue = routes.grouped("approval-queue")
            .grouped([
                IdentityGuard(needs: [.admin, .moderator, .workApprover]),
                BannedGuard()
            ])
        let queueCheckProfile = routes.grouped("approval-queue")
            .grouped([
                IdentityGuard(needs: [.admin, .moderator, .workApprover], checkProfile: true),
                BannedGuard(),
            ])
        
        queue.get("fetch-all") { request async throws -> Page<ApprovalQueue> in
            struct FetchOptions: Content {
                var ascending: Bool?
                var status: ApprovalQueue.Status?
            }
            
            let query = try request.query.decode(FetchOptions.self)
            return try await request.approvalService.fetchQueue(
                ascending: query.ascending ?? true,
                status: query.status ?? .waiting
            )
        }
        
        queueCheckProfile.get("fetch-one") { request async throws -> ApprovalQueue in
            struct FetchOptions: Content {
                var workId: String?
            }
            
            let query = try request.query.decode(FetchOptions.self)
            if let id = query.workId {
                return try await request.approvalService.fetchQueueItem(id)
            }
            throw Abort(.badRequest, reason: "You must include the item ID in your request.")
        }
        
        queueCheckProfile.patch("claim-one") { request async throws -> ApprovalQueue in
            let itemId: String? = request.query["itemId"]
            if let id = itemId {
                let itemUUID = UUID(uuidString: id)
                if itemUUID == nil {
                    throw Abort(.badRequest, reason: "The ID provided is not valid.")
                }
                return try await request.approvalService.claimItem(itemUUID!)
            }
            throw Abort(.badRequest, reason: "You must provide the item ID in your request.")
        }
        
        queueCheckProfile.patch("approve") { request async throws -> ApprovalQueue in
            let itemId: String? = request.query["itemId"]
            if let id = itemId {
                let itemUUID = UUID(uuidString: id)
                if itemUUID == nil {
                    throw Abort(.badRequest, reason: "The ID provided is not valid.")
                }
                return try await request.approvalService.approveWork(itemUUID!)
            }
            throw Abort(.badRequest, reason: "You must provide the item ID in your request.")
        }
        
        queueCheckProfile.patch("reject") { request async throws -> ApprovalQueue in
            let itemId: String? = request.query["itemId"]
            if let id = itemId {
                let itemUUID = UUID(uuidString: id)
                if itemUUID == nil {
                    throw Abort(.badRequest, reason: "The ID provided is not valid.")
                }
                try ApprovalQueue.ProvideReason.validate(content: request)
                let formInfo = try request.content.decode(ApprovalQueue.ProvideReason.self)
                return try await request.approvalService.rejectWork(itemUUID!, reason: formInfo)
            }
            throw Abort(.badRequest, reason: "You must provide the item ID in your request.")
        }
    }
}
