//
//  AuthController.swift
//
//
//  Created by Alyx Mote on 11/28/23.
//

import Vapor
import Fluent

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        
        auth.post("register") { request async throws -> HTTPStatus in
            try Account.RegisterForm.validate(content: request)
            let formInfo = try request.content.decode(Account.RegisterForm.self)
            if formInfo.ageCheck != true {
                throw Abort(.unauthorized, reason: "You must be at least 13 years of age or older to register.")
            }
            if formInfo.termsAgree != true {
                throw Abort(.unauthorized, reason: "You must agree to the Terms of Service, Privacy Policy, and Offprint Constitution in order to register.")
            }
            
            // start the registration process
            let newAccount = Account(with: formInfo)
            try await newAccount.save(on: request.db)
            
            return .ok
        }
        
        auth.grouped(Account.authenticator()).post("log-in") { request async throws -> Account.Client in
            let account = try request.auth.require(Account.self)
            let payload = try SessionToken(account: account)
            return Account.Client(from: account, token: try request.jwt.sign(payload))
        }
    }
}
