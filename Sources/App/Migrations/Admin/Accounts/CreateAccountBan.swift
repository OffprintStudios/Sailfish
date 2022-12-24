//
// Created by Alyx Mote on 10/1/22.
//

import Fluent

struct CreateAccountBan: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("account_bans")
            .id()
            .field("account_id", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("banned_by", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("reason", .string, .required)
            .field("expires_on", .datetime)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("account_bans").delete()
    }
}
