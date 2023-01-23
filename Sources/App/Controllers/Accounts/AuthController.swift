//
// Created by Alyx Mote on 7/27/22.
//

import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")

        auth.post("register") { request async throws -> Session.ClientPackage in
            try Account.RegisterForm.validate(content: request)
            let registerForm = try request.content.decode(Account.RegisterForm.self)
            return try await request.authService.register(with: registerForm)
        }

        auth.post("login") { request async throws -> Session.ClientPackage in
            try Account.LoginForm.validate(content: request)
            let loginForm = try request.content.decode(Account.LoginForm.self)
            return try await request.authService.login(with: loginForm)
        }
        
        auth.post("refresh") { request async throws -> Session.RefreshPackage in
            let info = try request.content.decode(SessionService.SessionInfo.self)
            return try await request.sessionService.refreshSession(with: info)
        }

        auth.post("logout") { request async throws -> Response in
            let logoutInfo = try request.content.decode(SessionService.SessionInfo.self)
            return try await request.authService.logout(with: logoutInfo)
        }
        
        auth.get("send-recovery-email") { request async throws -> Response in
            let accountId: String? = request.query["accountId"]
            guard let accountUuid = UUID(uuidString: accountId ?? "nil") else {
                throw Abort(.badRequest, reason: "Invalid account ID provided")
            }
            return try await request.accountService.sendPasswordResetEmail(accountId: accountUuid)
        }
        
        auth.patch("reset-password") { request async throws -> Response in
            try PasswordReset.PasswordResetForm.validate(content: request)
            let formInfo = try request.content.decode(PasswordReset.PasswordResetForm.self)
            return try await request.accountService.resetPassword(with: formInfo)
        }

        auth.grouped(IdentityGuard(needs: [.user])).post("check-roles") { request async throws -> HasRoles in
            let info = try request.content.decode(CheckRoles.self)
            let account = try request.authService.getUser().account
            return HasRoles(goodToGo: canAccess(needs: info.needs, has: account.roles))
        }
    }
}

extension AuthController {
    struct CheckRoles: Content {
        var needs: [Account.Roles]
    }
    struct HasRoles: Content {
        var goodToGo: Bool
    }
}
