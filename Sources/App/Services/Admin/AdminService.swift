//
// Created by Alyx Mote on 10/1/22.
//

import Foundation
import Vapor
import Fluent
import FluentSQL

/// Offprint Admin Service
///
/// Contains functions related to processing administration and moderation-related
/// tasks.
struct AdminService {
    let request: Request

    /// Fetches all users along with their profiles
    func fetchUsers(page: Int, per: Int) async throws -> Page<Account.AccountWithReports> {
        if let sqlDb = request.db as? SQLDatabase {
            let offset = per * (page - 1)
            let accounts = try await sqlDb.raw("""
                SELECT a.id, a.roles, a.terms_agree, a.email_confirmed, a.created_at, a.updated_at, COUNT(r.id) as total
                FROM accounts a LEFT JOIN account_reports r
                ON a.id = r.account_id
                WHERE r.closed_on IS NULL
                GROUP BY a.id ORDER BY total DESC
                LIMIT \(raw: per.description)
                OFFSET \(raw: offset.description);
            """).all(decoding: Account.AccountWithReports.self)
            var items: [Account.AccountWithReports] = []
            for account in accounts {
                let profiles = try await Profile.query(on: request.db).filter(\.$account.$id == account.id!).all()
                let newAccountObj: Account.AccountWithReports = .init(
                    id: account.id,
                    profiles: profiles,
                    roles: account.roles,
                    terms_agree: account.terms_agree,
                    email_confirmed: account.email_confirmed,
                    total: account.total
                )
                items.append(newAccountObj)
            }
            return .init(items: items, metadata: .init(page: page, per: per, total: try await Account.query(on: request.db).count()))
        } else {
            throw Abort(.notImplemented, reason: "This feature is only available with SQL databases.")
        }
    }

    /// Fetches a single user along with their profiles
    func fetchUser(_ id: UUID) async throws -> Account? {
        try await Account.query(on: request.db)
            .with(\.$profiles)
            .field(\.$id)
            .field(\.$roles)
            .field(\.$termsAgree)
            .field(\.$emailConfirmed)
            .field(\.$createdAt)
            .field(\.$updatedAt)
            .filter(\.$id == id)
            .first()
    }

    /// Fetches all reports for an account
    func fetchReports(_ id: UUID) async throws -> [AccountReport] {
        try await AccountReport.query(on: request.db)
            .filter(\.$account.$id == id)
            .all()
    }

    /// Fetches all notes for an account
    func fetchNotes(_ id: UUID) async throws -> [AccountNote] {
        try await AccountNote.query(on: request.db)
            .filter(\.$account.$id == id)
            .all()
    }

    /// Changes an account's designated roles
    func changeRoles(_ id: UUID, newRoles: [Account.Roles]) async throws -> ClientAccount {
        let accountToChange = try await Account.find(id, on: request.db)
        if let account = accountToChange {
            account.roles = newRoles
            try await account.save(on: request.db)
            return ClientAccount(from: account)
        } else {
            throw Abort(.forbidden, reason: "Account either doesn't exist or cannot be modified.")
        }
    }

    /// Adds a note to an account
    func addNote(_ id: UUID, byWho: UUID, message: String) async throws -> AccountNote {
        let note = try AccountNote(addedBy: byWho, formInfo: .init(accountId: id, message: message))
        try await note.save(on: request.db)
        return note
    }

    /// Warns a user
    func warnUser(_ id: UUID, byWho: UUID, reason: String) async throws {
        let warning = try AccountWarning(warnedBy: byWho, warningForm: .init(accountId: id, reason: reason))
        try await warning.save(on: request.db)
        try await request.auditLogService.warn(id, byWho: byWho, reason: reason)
    }

    /// Mutes a user for a given duration
    func muteUser(_ id: UUID, byWho: UUID, reason: String, duration: Date) async throws {
        let muted = try AccountMute(mutedBy: byWho, muteForm: .init(accountId: id, reason: reason, duration: duration))
        try await muted.save(on: request.db)
        try await request.auditLogService.mute(id, byWho: byWho, reason: reason, duration: duration)
    }

    /// Bans a user for a given duration. If no duration is set, the ban is permanent
    func banUser(_ id: UUID, byWho: UUID, reason: String, duration: Date? = nil) async throws {
        let banned = try AccountBan(bannedBy: byWho, banForm: .init(accountId: id, reason: reason, duration: duration))
        try await banned.save(on: request.db)
        try await request.auditLogService.ban(id, byWho: byWho, reason: reason, duration: duration)
    }
}

extension Request {
    var adminService: AdminService {
        .init(request: self)
    }
}
