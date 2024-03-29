//
// Created by Alyx Mote on 10/3/22.
//

import Vapor
import Fluent

struct AdminController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let admin = routes.grouped("admin").grouped([
            IdentityGuard(needs: [.moderator, .admin]),
            ConfirmationGuard(),
            BannedGuard(),
        ])
        
        let adminCheckProfile = routes.grouped("admin").grouped([
            IdentityGuard(needs: [.moderator, .admin], checkProfile: true),
            ConfirmationGuard(),
            BannedGuard()
        ])

        admin.get("fetch-users") { request async throws -> Page<Account.AccountWithReports> in
            struct FetchPage: Content {
                var page: Int?
                var per: Int?
            }
            
            let query = try request.query.decode(FetchPage.self)
            return try await request.adminService.fetchUsers(page: query.page ?? 1, per: query.per ?? 20)
        }

        admin.get("fetch-user", ":id") { request async throws -> Account.AccountWithReports in
            guard let id = UUID(uuidString: request.parameters.get("id")!) else {
                throw Abort(.badRequest, reason: "Invalid UUID supplied.")
            }
            return try await request.adminService.fetchUser(id)
        }

        admin.get("fetch-reports", ":id") { request async throws -> [AccountReport] in
            guard let id = UUID(uuidString: request.parameters.get("id")!) else {
                throw Abort(.badRequest, reason: "Invalid UUID supplied.")
            }
            return try await request.adminService.fetchReports(id)
        }

        admin.get("fetch-notes", ":id") { request async throws -> [AccountNote] in
            guard let id = UUID(uuidString: request.parameters.get("id")!) else {
                throw Abort(.badRequest, reason: "Invalid UUID supplied.")
            }
            return try await request.adminService.fetchNotes(id)
        }

        admin.get("fetch-log", ":id") { request async throws -> [AccountLog] in
            guard let id = UUID(uuidString: request.parameters.get("id")!) else {
                throw Abort(.badRequest, reason: "Invalid UUID supplied.")
            }
            return try await request.auditLogService.fetchLog(id)
        }

        admin.patch("change-roles", ":id") { request async throws -> ClientAccount in
            guard let id = UUID(uuidString: request.parameters.get("id")!) else {
                throw Abort(.badRequest, reason: "Invalid UUID supplied.")
            }
            let changeRolesDTO = try request.content.decode(ChangeRolesDTO.self)
            return try await request.adminService.changeRoles(id, newRoles: changeRolesDTO.newRoles)
        }

        adminCheckProfile.post("add-note") { request async throws -> AccountNote in
            try AccountNote.NoteForm.validate(content: request)
            let addNote = try request.content.decode(AccountNote.NoteForm.self)
            let profile = try request.authService.getUser(withProfile: true).profile!
            return try await request.adminService.addNote(
                addNote.accountId,
                byWho: profile.id!,
                message: addNote.message
            )
        }

        adminCheckProfile.post("warn-user") { request async throws -> Response in
            try AccountWarning.WarningForm.validate(content: request)
            let formInfo = try request.content.decode(AccountWarning.WarningForm.self)
            try await request.adminService.warnUser(using: formInfo)
            return .init(status: .ok)
        }

        adminCheckProfile.post("mute-user") { request async throws -> Response in
            try AccountMute.MuteForm.validate(content: request)
            let formInfo = try request.content.decode(AccountMute.MuteForm.self)
            try await request.adminService.muteUser(using: formInfo)
            return .init(status: .ok)
        }

        adminCheckProfile.post("ban-user") { request async throws -> Response in
            try AccountBan.BanForm.validate(content: request)
            let formInfo = try request.content.decode(AccountBan.BanForm.self)
            try await request.adminService.banUser(using: formInfo)
            return .init(status: .ok)
        }
    }
}

extension AdminController {
    struct ChangeRolesDTO: Content {
        var newRoles: [Account.Roles]
    }
}
