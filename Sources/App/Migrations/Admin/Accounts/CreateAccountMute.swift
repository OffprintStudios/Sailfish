//
// Created by Alyx Mote on 10/1/22.
//

import Fluent

struct CreateAccountMute: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("accounts_muted")
            .id()
            .field("account_id", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("muted_by", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("reason", .string, .required)
            .field("expires_on", .datetime, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("accounts_muted").delete()
    }
}
