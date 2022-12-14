//
//  Created by Alyx Mote on 12/12/22.
//

import Vapor
import Fluent
import SwiftSoup

struct ApprovalQueueService {
    let request: Request
    
    /// Fetches the approval queue.
    func fetchQueue() async throws -> Page<ApprovalQueue> {
        try await ApprovalQueue.query(on: request.db)
            .with(\.$work) { $0.with(\.$author) }
            .with(\.$claimedBy)
            .group(.or) { group in
                group.filter(\.$status == .waiting).filter(\.$status == .claimed)
            }
            .sort(\.$createdAt, .ascending)
            .paginate(for: request)
    }
    
    /// Submits a work to the queue and updates its `approvalStatus` to the appropriate marker.
    func submitItem(_ id: String) async throws -> Response {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            if try await ApprovalQueue.query(on: database).filter(\.$work.$id == id).first() != nil {
                throw Abort(.conflict, reason: "This work has already been submitted to the queue.")
            }
            guard let work = try await profile.$works.query(on: database).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The work you're trying to add to the queue doesn't exist.")
            }
            let newItem = ApprovalQueue(workId: id)
            try await newItem.save(on: database)
            work.approvalStatus = .pending
            try await work.save(on: database)
            return Response(status: .ok)
        }
    }
    
    /// Claims an item in the queue. Throws if the item has already been claimed.
    func claimItem(_ id: UUID) async throws -> ApprovalQueue {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            let item = try await ApprovalQueue.query(on: database)
                .with(\.$work) { $0.with(\.$author) }
                .filter(\.$id == id)
                .filter(\.$status == .waiting)
                .first()
            if let hasItem = item {
                hasItem.$claimedBy.id = try profile.requireID()
                hasItem.status = .claimed
                try await hasItem.save(on: database)
                hasItem.$claimedBy.value = profile
                return hasItem
            }
            throw Abort(.notFound, reason: "Either this item has already been claimed, or it does not exist.")
        }
    }
    
    /// Approves a work in the queue. Throws if the item being approved has not been claimed by the user doing the approving, if the queue entry doesn't exist,
    /// or if the work has already reached the `attempts` limit.
    func approveWork(_ id: UUID) async throws -> ApprovalQueue {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            let item = try await ApprovalQueue.query(on: database)
                .with(\.$work) { $0.with(\.$author) }
                .filter(\.$id == id)
                .filter(\.$claimedBy.$id == profile.id!)
                .first()
            if let hasItem = item {
                if hasItem.attempts < 4 {
                    hasItem.status = .approved
                    try await hasItem.save(on: database)
                    hasItem.work.approvalStatus = .approved
                    hasItem.work.publishedOn = Date()
                    try await hasItem.work.save(on: database)
                    return hasItem
                }
                throw Abort(.forbidden, reason: "This work has already failed to pass three times and can no longer be approved.")
            }
            throw Abort(.notFound, reason: "This work was either claimed by someone else or its queue entry does not exist.")
        }
    }
    
    /// Rejects a work in the queue. Reasons must be provided for all rejections. If the work has already failed to pass three times, this will throw with a `forbidden` error.
    /// Otherwise, this will throw if the claim doesn't exist.
    func rejectWork(_ id: UUID, reason: ApprovalQueue.ProvideReason) async throws -> ApprovalQueue {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            let item = try await ApprovalQueue.query(on: database)
                .with(\.$work) { $0.with(\.$author) }
                .filter(\.$id == id)
                .filter(\.$claimedBy.$id == profile.id!)
                .first()
            if let hasItem = item {
                if hasItem.attempts < 4 {
                    hasItem.status = .rejected
                    hasItem.attempts += 1
                    hasItem.reason = try SwiftSoup.clean(reason.reason, .none())!
                    try await hasItem.save(on: database)
                    hasItem.work.approvalStatus = .rejected
                    try await hasItem.work.save(on: database)
                    return hasItem
                }
                throw Abort(.forbidden, reason: "This work has already failed to pass three times and can no longer be approved.")
            }
            throw Abort(.notFound, reason: "This work was either claimed by someone else or its queue entry does not exist.")
        }
    }
}

extension Request {
    var approvalService: ApprovalQueueService {
        .init(request: self)
    }
}