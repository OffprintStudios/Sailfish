//
//  Created by Alyx Mote on 12/12/22.
//

import Vapor
import Fluent
import SwiftSoup

struct ApprovalQueueService {
    let request: Request
    
    /// Fetches the approval queue.
    func fetchQueue(ascending: Bool = true, status: ApprovalQueue.Status = .waiting) async throws -> Page<ApprovalQueue> {
        try await ApprovalQueue.query(on: request.db)
            .with(\.$work) { $0.with(\.$author).with(\.$tags) { $0.with(\.$parent) } }
            .with(\.$claimedBy)
            .filter(\.$status == status)
            .sort(\.$createdAt, ascending ? .ascending : .descending)
            .paginate(for: request)
    }
    
    func fetchQueueItem(_ id: String) async throws -> ApprovalQueue {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let item = try await ApprovalQueue.query(on: request.db)
            .with(\.$claimedBy)
            .filter(\.$work.$id == id)
            .filter(\.$claimedBy.$id == profile.id!)
            .filter(\.$status == .claimed)
            .first() else {
            throw Abort(.notFound, reason: "The item you're trying to fetch does not exist.")
        }
        return item
    }
    
    /// Submits a work to the queue and updates its `approvalStatus` to the appropriate marker.
    func submitItem(_ id: String) async throws -> Response {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await request.db.transaction { database in
            if let queueItem = try await ApprovalQueue.query(on: database).filter(\.$work.$id == id).first() {
                if queueItem.attempts > 3 {
                    throw Abort(.forbidden, reason: "You've already reached the maximum number of attempts for this work.")
                }
                queueItem.attempts += 1
                queueItem.status = .waiting
                try await queueItem.save(on: database)
                return Response(status: .ok)
            } else {
                guard let work = try await profile.$works.query(on: database).filter(\.$id == id).first() else {
                    throw Abort(.notFound, reason: "The work you're trying to add to the queue doesn't exist.")
                }
                if work.kind != .poetry && work.words < MIN_WORD_COUNT {
                    throw Abort(.badRequest, reason: "Your work must meet a minimum word count of \(MIN_WORD_COUNT) words before submission.")
                }
                let newItem = ApprovalQueue(workId: id)
                try await newItem.save(on: database)
                work.approvalStatus = .pending
                try await work.save(on: database)
                return Response(status: .ok)
            }
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
        let item: ApprovalQueue = try await request.db.transaction { database in
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
                    hasItem.work.author.stats.works += 1
                    try await hasItem.work.author.save(on: database)
                    return hasItem
                }
                throw Abort(.forbidden, reason: "This work has already failed to pass three times and can no longer be approved.")
            }
            throw Abort(.notFound, reason: "This work was either claimed by someone else or its queue entry does not exist.")
        }
        try await request.queue.dispatch(AddNotificationJob.self, .init(
            to: item.work.author.id!,
            from: nil,
            event: .workApproved,
            entity: item.work.id,
            context: ["title": item.work.title]
        ))
        return item
    }
    
    /// Rejects a work in the queue. Reasons must be provided for all rejections. If the work has already failed to pass three times, this will throw with a `forbidden` error.
    /// Otherwise, this will throw if the claim doesn't exist.
    func rejectWork(_ id: UUID, reason: ApprovalQueue.ProvideReason) async throws -> ApprovalQueue {
        let profile = try request.authService.getUser(withProfile: true).profile!
        let item: ApprovalQueue = try await request.db.transaction { database in
            let item = try await ApprovalQueue.query(on: database)
                .with(\.$work) { $0.with(\.$author) }
                .filter(\.$id == id)
                .filter(\.$claimedBy.$id == profile.id!)
                .first()
            if let hasItem = item {
                if hasItem.attempts < 4 {
                    hasItem.status = .rejected
                    hasItem.reason = try SwiftSoup.clean(reason.reason, .none())!
                    try await hasItem.save(on: database)
                    hasItem.work.approvalStatus = .rejected
                    hasItem.$claimedBy.id = nil
                    try await hasItem.work.save(on: database)
                    return hasItem
                }
                throw Abort(.forbidden, reason: "This work has already failed to pass three times and can no longer be approved.")
            }
            throw Abort(.notFound, reason: "This work was either claimed by someone else or its queue entry does not exist.")
        }
        try await request.queue.dispatch(AddNotificationJob.self, .init(
            to: item.work.author.id!,
            from: nil,
            event: .workRejected,
            entity: item.work.id,
            context: ["title": item.work.title, "reason": item.reason!]
        ))
        return item
    }
}

extension Request {
    var approvalService: ApprovalQueueService {
        .init(request: self)
    }
}
