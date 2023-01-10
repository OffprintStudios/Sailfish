//
// Created by Alyx Mote on 10/1/22.
//

import Fluent

struct CreateAccountWarning: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("account_warnings")
            .id()
            .field("account_id", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("warned_by", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("reason", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("account_warnings").delete()
    }
}
