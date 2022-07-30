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

        auth.get("logout") { request async throws in
            try await request.authService.logout()
        }
    }
}