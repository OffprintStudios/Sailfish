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
        
        queue.get("fetch-all") { request async throws -> Page<ApprovalQueue> in
            try await request.approvalService.fetchQueue()
        }
        
        queue.patch("claim-one") { request async throws -> ApprovalQueue in
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
        
        queue.patch("approve") { request async throws -> ApprovalQueue in
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
        
        queue.patch("reject") { request async throws -> ApprovalQueue in
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
