//
// Created by Alyx Mote on 7/21/22.
//

import Vapor
import Fluent
import Argon2Swift
import NanoID

final class Account: Model, Content {
    static let schema = "accounts"

    @ID(custom: "id", generatedBy: .user)
    var id: String?

    @Field(key: "email")
    var email: String

    @Field(key: "password")
    var password: String

    @Children(for: \.$account)
    var profiles: [Profile]

    @Field(key: "roles")
    var roles: [Roles]

    @Field(key: "terms_agree")
    var termsAgree: Bool

    @Field(key: "email_confirmed")
    var emailConfirmed: Bool

    @Children(for: \.$account)
    var sessions: [Session]

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: String? = nil, formData: RegisterForm) throws {
        guard let hashedPassword = try? Argon2Swift.hashPasswordString(password: formData.password, salt: Salt.newSalt(), type: Argon2Type.id) else {
            throw Abort(.internalServerError)
        }

        if let hasId = id {
            self.id = hasId
        } else {
            self.id = NanoID.with(size: NANO_ID_SIZE)
        }

        email = formData.email
        password = hashedPassword.encodedString().trimmingCharacters(in: CharacterSet(charactersIn: "\0"))
        roles = [.user]
        termsAgree = formData.termsAgree
        emailConfirmed = false
    }
}

extension Account {
    struct RegisterForm: Content {
        var email: String
        var password: String
        var termsAgree: Bool
        var inviteCode: String
    }

    struct LoginForm: Content {
        var email: String
        var password: String
        var rememberMe: Bool
    }

    struct ChangeEmail: Content {
        var email: String
        var password: String
    }

    struct ChangePassword: Content {
        var newPassword: String
        var oldPassword: String
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
        validations.add("inviteCode", as: String.self, is: !.empty)
    }
}

extension Account.LoginForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: !.empty)
    }
}
