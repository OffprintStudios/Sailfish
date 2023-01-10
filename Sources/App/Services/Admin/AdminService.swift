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
    func fetchUser(_ id: UUID) async throws -> Account.AccountWithReports {
        guard let account = try await Account.query(on: request.db)
            .with(\.$profiles)
            .field(\.$id)
            .field(\.$roles)
            .field(\.$termsAgree)
            .field(\.$emailConfirmed)
            .field(\.$createdAt)
            .field(\.$updatedAt)
            .filter(\.$id == id)
            .first() else {
            throw Abort(.notFound, reason: "The user you're trying to look up doesn't exist.")
        }
        let accountWithReports: Account.AccountWithReports = .init(
            id: account.id,
            profiles: account.profiles,
            roles: account.roles,
            terms_agree: account.termsAgree,
            email_confirmed: account.emailConfirmed,
            total: Int64(try await account.$reports.query(on: request.db).filter(\.$closedOn == nil).count())
        )
        return accountWithReports
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
            .with(\.$addedBy)
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
    func addNote(_ id: UUID, byWho: String, message: String) async throws -> AccountNote {
        let note = try AccountNote(addedBy: byWho, formInfo: .init(accountId: id, message: message))
        try await note.save(on: request.db)
        try await note.$addedBy.load(on: request.db)
        return note
    }
    
    /// Files a new report
    func reportUser(with formInfo: AccountReport.ReportForm) async throws -> Response {
        let account = try request.authService.getUser().account
        let newReport = try AccountReport(reportedBy: account.id!, formInfo: formInfo)
        try await request.db.transaction { database in
            try await newReport.save(on: database)
        }
        return .init(status: .ok)
    }

    /// Warns a user
    func warnUser(using formInfo: AccountWarning.WarningForm) async throws {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let toWarn = try await Account.find(formInfo.accountId, on: request.db) else {
            throw Abort(.notFound, reason: "The account you're trying to action does not exist.")
        }
        if try canAction(toWarn) == false {
            throw Abort(.forbidden, reason: "Insufficient privileges.")
        }
        let warning = try AccountWarning(warnedBy: profile.id!, warningForm: formInfo)
        try await warning.save(on: request.db)
        try await request.auditLogService.warn(try toWarn.requireID(), byWho: profile.id!, reason: warning.reason)
        try await notifyAccount(toWarn, event: .userWarned, reason: warning.reason)
    }

    /// Mutes a user for a given duration
    func muteUser(using formInfo: AccountMute.MuteForm) async throws {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let toMute = try await Account.find(formInfo.accountId, on: request.db) else {
            throw Abort(.notFound, reason: "The account you're trying to action does not exist.")
        }
        if try canAction(toMute) == false {
            throw Abort(.forbidden, reason: "Insufficient privileges.")
        }
        let muted = try AccountMute(mutedBy: profile.id!, muteForm: formInfo)
        try await muted.save(on: request.db)
        try await request.auditLogService.mute(try toMute.requireID(), byWho: profile.id!, reason: formInfo.reason, duration: muted.expiresOn)
        try await notifyAccount(toMute, event: .userMuted, reason: muted.reason, duration: formInfo.duration)
    }

    /// Bans a user for a given duration. If no duration is set, the ban is permanent
    func banUser(using formInfo: AccountBan.BanForm) async throws {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let toBan = try await Account.find(formInfo.accountId, on: request.db) else {
            throw Abort(.notFound, reason: "The account you're trying to action does not exist.")
        }
        if try canAction(toBan) == false {
            throw Abort(.forbidden, reason: "Insufficient privileges.")
        }
        let banned = try AccountBan(bannedBy: profile.id!, banForm: formInfo)
        try await banned.save(on: request.db)
        try await request.auditLogService.ban(try toBan.requireID(), byWho: profile.id!, reason: formInfo.reason, duration: banned.expiresOn)
        try await notifyAccount(toBan, event: .userBanned, reason: banned.reason, duration: formInfo.duration)
    }
    
    private func canAction(_ toAction: Account) throws -> Bool {
        let account = try request.authService.getUser().account
        if canAccess(needs: [.admin], has: toAction.roles) {
            // if the user being actioned is an admin
            return false
        } else if canAccess(needs: [.moderator], has: toAction.roles) && canAccess(needs: [.moderator], has: account.roles) {
            // if a moderator is trying to action another moderator
            return false
        } else {
            return true
        }
    }
    
    private func notifyAccount(_ account: Account, event: Notification.EventType, reason: String, duration: Durations? = nil) async throws {
        let profiles = try await account.$profiles.get(on: request.db)
        for profile in profiles {
            try await request.queue.dispatch(AddNotificationJob.self, .init(
                to: profile.id!,
                from: nil,
                event: event,
                context: ["reason": reason, "duration": duration == nil ? "nil" : duration!.rawValue]
            ))
        }
    }
}

extension Request {
    var adminService: AdminService {
        .init(request: self)
    }
}
