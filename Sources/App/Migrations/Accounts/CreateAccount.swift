//
// Created by Alyx Mote on 7/20/22.
//

import Fluent

struct CreateAccount: AsyncMigration {
    private typealias AccountKeys = Account.FieldKeys
    
    func prepare(on database: Database) async throws {
        return try await database.schema(Account.schema)
            .id()
            .field(AccountKeys.email, .string, .required)
            .field(AccountKeys.password, .string, .required)
            .field(AccountKeys.roles, .array(of: .string), .required)
            .field(AccountKeys.termsAgree, .bool, .required)
            .field(AccountKeys.emailConfirmed, .bool, .required)
            .field(AccountKeys.createdAt, .datetime)
            .field(AccountKeys.updatedAt, .datetime)
            .unique(on: AccountKeys.email)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema(Account.schema).delete()
    }
}
