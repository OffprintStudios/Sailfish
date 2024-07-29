import Vapor
import Fluent
import struct Foundation.Date

final class PasswordReset: Model, @unchecked Sendable {
    static let schema = "password_reset_codes"

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

extension PasswordReset {
    struct Create: AsyncMigration {
        typealias AccountKeys = Account.FieldKeys
        typealias ResetKeys = FieldKeys

        func prepare(on database: any Database) async throws {
            try await database.schema(PasswordReset.schema)
                .field(ResetKeys.id, .string, .identifier(auto: false))
                .field(ResetKeys.accountId, .uuid, .required, .references(Account.schema, AccountKeys.id, onDelete: .cascade))
                .field(ResetKeys.used, .bool, .required)
                .field(ResetKeys.expiresOn, .datetime, .required)
                .field(ResetKeys.createdAt, .datetime)
                .create()
        }

        func revert(on database: any Database) async throws {
            try await database.schema(PasswordReset.schema).delete()
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