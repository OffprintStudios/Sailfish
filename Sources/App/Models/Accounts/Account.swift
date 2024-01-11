//
//  Account.swift
//
//
//  Created by Alyx Mote on 10/15/23.
//

import Vapor
import Fluent
import NanoID
import SwiftSoup
import Argon2Swift

final class Account: Model, Content, Authenticatable {
    static let schema = "accounts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.email)
    var email: String
    
    @Field(key: FieldKeys.password)
    var password: String
    
    @Field(key: FieldKeys.roles)
    var roles: [Roles]
    
    @Field(key: FieldKeys.termsAgree)
    var termsAgree: Bool
    
    @Field(key: FieldKeys.emailConfirmed)
    var emailConfirmed: Bool
    
    @Children(for: \.$account)
    var profiles: [ProfileView]
    
    @Children(for: \.$account)
    var profilesRaw: [Profile]
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, with formInfo: RegisterForm) {
        self.id = id
        self.email = formInfo.email
        self.password = formInfo.password
        self.roles = [.user]
        self.termsAgree = formInfo.termsAgree
        self.emailConfirmed = false
    }
}

extension Account {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Account.schema)
                .id()
                .field(FieldKeys.email, .string, .required)
                .field(FieldKeys.password, .string, .required)
                .field(FieldKeys.roles, .array(of: .string), .required)
                .field(FieldKeys.termsAgree, .bool, .required)
                .field(FieldKeys.emailConfirmed, .bool, .required)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .unique(on: FieldKeys.email)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(Account.schema).delete()
        }
    }
    
    struct Middleware: AsyncModelMiddleware {
        func create(model: Account, on db: Database, next: AnyAsyncModelResponder) async throws {
            let existingEmail = try await Account.query(on: db).filter(\.$email == model.email).first()
            if existingEmail != nil {
                throw Abort(.conflict, reason: "An account with this email already exists!")
            }
            
            model.email = try SwiftSoup.clean(model.email, .none())!
            guard let hashedPassword = try? Argon2Swift.hashPasswordString(password: model.password, salt: Salt.newSalt(), type: Argon2Type.id) else {
                throw Abort(.internalServerError, reason: "Failed to create your account. Contact an administrator for assistance.")
            }
            model.password = hashedPassword.encodedString().trimmingCharacters(in: CharacterSet(charactersIn: "\0"))
            return try await next.create(model, on: db)
        }
    }
    
    struct RegisterForm: Content, Validatable {
        var email: String
        var password: String
        var ageCheck: Bool
        var termsAgree: Bool
        
        static func validations(_ validations: inout Validations) {
            validations.add("email", as: String.self, is: .email)
            validations.add("password", as: String.self, is: .count(8...))
        }
    }
    
    struct Client: Content {
        var id: UUID?
        var roles: [Roles]
        var termsAgree: Bool
        var emailConfirmed: Bool
        var createdAt: Date?
        var updatedAt: Date?
        var token: String?
        
        init(from account: Account, token: String? = nil) {
            self.id = account.id
            self.roles = account.roles
            self.termsAgree = account.termsAgree
            self.emailConfirmed = account.emailConfirmed
            self.createdAt = account.createdAt
            self.updatedAt = account.updatedAt
            self.token = token
        }
    }
    
    enum Roles: String, Codable {
        case admin = "Admin"
        case moderator = "Moderator"
        case workApprover = "WorkApprover"
        case chatModerator = "ChatModerator"
        case contributor = "Contributor"
        case venti = "Ventí"
        case grande = "Grandé"
        case tall = "Tall"
        case user = "User"
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let email: FieldKey = "email"
        static let password: FieldKey = "password"
        static let roles: FieldKey = "roles"
        static let termsAgree: FieldKey = "terms_agree"
        static let emailConfirmed: FieldKey = "email_confirmed"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}

extension Account: ModelAuthenticatable {
    static let usernameKey = \Account.$email
    static let passwordHashKey = \Account.$password
    
    func verify(password: String) throws -> Bool {
        return try Argon2Swift.verifyHashString(password: password, hash: self.password, type: .id)
    }
}
