//
// Created by Alyx Mote on 7/21/22.
//

import Vapor
import Fluent
import Argon2Swift
import NanoID

final class Account: Model, Content {
    static let schema = "accounts"

    @ID(key: .id)
    var id: UUID?

    @Field(key: FieldKeys.email)
    var email: String

    @Field(key: FieldKeys.password)
    var password: String

    @Children(for: \.$account)
    var profiles: [Profile]

    @Field(key: FieldKeys.roles)
    var roles: [Roles]

    @Field(key: FieldKeys.termsAgree)
    var termsAgree: Bool

    @Field(key: FieldKeys.emailConfirmed)
    var emailConfirmed: Bool

    @Children(for: \.$account)
    var sessions: [Session]
    
    @Children(for: \.$account)
    var reports: [AccountReport]

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, formData: RegisterForm) throws {
        guard let hashedPassword = try? Argon2Swift.hashPasswordString(password: formData.password, salt: Salt.newSalt(), type: Argon2Type.id) else {
            throw Abort(.internalServerError, reason: "Failed to create your account. Contact an administrator for assistance.")
        }

        self.id = id
        email = formData.email
        password = hashedPassword.encodedString().trimmingCharacters(in: CharacterSet(charactersIn: "\0"))
        roles = [.user]
        termsAgree = formData.termsAgree
        emailConfirmed = false
    }
}

extension Account {
    enum FieldKeys {
        static let email: FieldKey = "email"
        static let password: FieldKey = "password"
        static let roles: FieldKey = "roles"
        static let termsAgree: FieldKey = "terms_agree"
        static let emailConfirmed: FieldKey = "email_confirmed"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
    
    struct RegisterForm: Content {
        var email: String
        var password: String
        var termsAgree: Bool
    }

    struct LoginForm: Content {
        var email: String
        var password: String
    }

    struct ChangeEmail: Content {
        var email: String
        var password: String
    }

    struct ChangePassword: Content {
        var newPassword: String
        var oldPassword: String
    }
    
    struct AccountWithReports: Content {
        var id: UUID?
        var profiles: [Profile]?
        var roles: [Roles]
        var terms_agree: Bool
        var email_confirmed: Bool
        var created_at: Date?
        var updated_at: Date?
        var total: Int64
    }

    enum Roles: String, Codable {
        case admin = "Admin"
        case moderator = "Moderator"
        case workApprover = "Work Approver"
        case chatModerator = "Chat Moderator"
        case maintainer = "Maintainer"
        case contributor = "Contributor"
        case vip = "VIP"
        case supporter = "Supporter"
        case user = "User"
    }
}
extension Account.RegisterForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .alphanumeric)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension Account.LoginForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: !.empty)
    }
}
