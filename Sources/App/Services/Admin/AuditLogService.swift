//
// Created by Alyx Mote on 10/3/22.
//

import Foundation
import Vapor
import Fluent

/// Offprint Audit Log Service
///
/// Contains functions related to the processing of auditing events for user accounts
struct AuditLogService {
    let request: Request

    /// Fetches an account's audit log
    func fetchLog(_ id: UUID) async throws -> [AccountLog] {
        try await AccountLog.query(on: request.db)
            .filter(\.$account.$id == id)
            .all()
    }

    /// Logs an event
    func log(_ id: UUID, event: AccountLog.LogForm) async throws {
        let newEvent = try AccountLog(for: id, eventInfo: event)
        try await newEvent.save(on: request.db)
    }

    /// Logs a CREATE event
    func create(_ id: UUID, reason: String) async throws {
        let newEvent = try AccountLog(for: id, eventInfo: .init(type: .create, detail: reason))
        try await newEvent.save(on: request.db)
    }

    /// Logs an UPDATE event
    func update(_ id: UUID, reason: String) async throws {
        let newEvent = try AccountLog(for: id, eventInfo: .init(type: .update, detail: reason))
        try await newEvent.save(on: request.db)
    }

    /// Logs a WARN action
    func warn(_ id: UUID, byWho: UUID, reason: String) async throws {
        let newEvent = try AccountLog(for: id, eventInfo: .init(
            type: .update,
            detail: reason,
            actionTaken: .warn,
            actionBy: byWho,
            actionReason: reason
        ))
        try await newEvent.save(on: request.db)
    }

    /// Logs a MUTE action
    func mute(_ id: UUID, byWho: UUID, reason: String, duration: Date) async throws {
        let newEvent = try AccountLog(for: id, eventInfo: .init(
            type: .update,
            detail: reason,
            actionTaken: .mute,
            actionBy: byWho,
            actionReason: reason,
            actionDuration: duration
        ))
        try await newEvent.save(on: request.db)
    }

    /// Logs a BAN action
    func ban(_ id: UUID, byWho: UUID, reason: String, duration: Date? = nil) async throws {
        let newEvent = try AccountLog(for: id, eventInfo: .init(
            type: .update,
            detail: reason,
            actionTaken: .ban,
            actionBy: id,
            actionReason: reason,
            actionDuration: duration
        ))
        try await newEvent.save(on: request.db)
    }

    /// Logs a DELETE event
    func delete(_ id: UUID, reason: String) async throws {
        let newEvent = try AccountLog(for: id, eventInfo: .init(type: .delete, detail: reason))
        try await newEvent.save(on: request.db)
    }
}

extension Request {
    var auditLogService: AuditLogService {
        .init(request: self)
    }
}
