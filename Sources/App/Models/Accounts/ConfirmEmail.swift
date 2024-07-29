import Vapor
import Fluent
import struct Foundation.Date

final class ConfirmEmail: Model, @unchecked Sendable {
    static let schema = "confirm_email_codes"

    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?

    @Parent(key: FieldKeys.accountId)
    var account: Account

    @Field(key: FieldKeys.used)
    var used: Bool

    @Field(key: FieldKeys.expiresOn)
    var expiresOn: Date

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    init() { }

    init(id: String? = nil, expiresOn: Date) {
        self.id = generateId(with: id)
        self.used = false
        self.expiresOn = expiresOn
    }
}

extension ConfirmEmail {
    struct Create: AsyncMigration {
        typealias AccountKeys = Account.FieldKeys
        typealias ConfirmKeys = FieldKeys

        func prepare(on database: any Database) async throws {
            try await database.schema(ConfirmEmail.schema)
                .field(ConfirmKeys.id, .string, .identifier(auto: false))
                .field(ConfirmKeys.accountId, .uuid, .required, .references(Account.schema, AccountKeys.id, onDelete: .cascade))
                .field(ConfirmKeys.used, .bool, .required)
                .field(ConfirmKeys.expiresOn, .datetime, .required)
                .field(ConfirmKeys.createdAt, .datetime)
                .create()
        }

        func revert(on database: any Database) async throws {
            try await database.schema(ConfirmEmail.schema).delete()
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let accountId: FieldKey = "account_id"
        static let used: FieldKey = "used"
        static let expiresOn: FieldKey = "expires_on"
        static let createdAt: FieldKey = "created_at"
    }
}