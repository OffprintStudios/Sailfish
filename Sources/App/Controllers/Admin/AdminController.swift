//
// Created by Alyx Mote on 10/3/22.
//

import Vapor
import Fluent

struct AdminController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let admin = routes.grouped("admin").grouped([
            IdentityGuard(needs: [.moderator, .admin]),
            BannedGuard(),
        ])

        admin.get("fetch-users") { request async throws -> Page<Account> in
            try await request.adminService.fetchUsers()
        }

        admin.get("fetch-user", ":id") { request async throws -> Account in
            guard let account = try await request.adminService.fetchUser(request.parameters.get("id")!) else {
                throw Abort(.notFound, reason: "The user you're trying to view likely doesn't exist.")
            }
            return account
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

        admin.post("add-note") { request async throws -> AccountNote in
            let addNoteDTO = try request.content.decode(AddNoteDTO.self)
            let account = try request.authService.getUser().account
            return try await request.adminService.addNote(
                addNoteDTO.accountId,
                byWho: account.id!,
                message: addNoteDTO.reason
            )
        }

        admin.post("warn-user") { request async throws -> Response in
            let response = Response()
            let warnUserDTO = try request.content.decode(WarnUserDTO.self)
            let account = try request.authService.getUser().account
            try await request.adminService.warnUser(
                warnUserDTO.accountId,
                byWho: account.id!,
                reason: warnUserDTO.reason
            )
            response.status = .ok
            return response
        }

        admin.post("mute-user") { request async throws -> Response in
            let response = Response()
            let muteUserDTO = try request.content.decode(MuteUserDTO.self)
            let account = try request.authService.getUser().account
            try await request.adminService.muteUser(
                muteUserDTO.accountId,
                byWho: account.id!,
                reason: muteUserDTO.reason,
                duration: muteUserDTO.duration
            )
            response.status = .ok
            return response
        }

        admin.post("ban-user") { request async throws -> Response in
            let response = Response()
            let banUserDTO = try request.content.decode(BanUserDTO.self)
            let account = try request.authService.getUser().account
            try await request.adminService.banUser(
                banUserDTO.accountId,
                byWho: account.id!,
                reason: banUserDTO.reason,
                duration: banUserDTO.duration
            )
            response.status = .ok
            return response
        }
    }
}

extension AdminController {
    struct ChangeRolesDTO: Content {
        var newRoles: [Account.Roles]
    }

    struct AddNoteDTO: Content {
        var accountId: UUID
        var reason: String
    }

    struct WarnUserDTO: Content {
        var accountId: UUID
        var reason: String
    }

    struct MuteUserDTO: Content {
        var accountId: UUID
        var reason: String
        var duration: Date
    }

    struct BanUserDTO: Content {
        var accountId: UUID
        var reason: String
        var duration: Date?
    }
}
