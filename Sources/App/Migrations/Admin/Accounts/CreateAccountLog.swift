//
// Created by Alyx Mote on 10/1/22.
//

import Fluent

struct CreateAccountLog: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("account_logs")
            .id()
            .field("account_id", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("event_type", .string, .required)
            .field("event_detail", .string, .required)
            .field("action_taken", .string)
            .field("action_by", .uuid, .references("accounts", "id", onDelete: .cascade))
            .field("action_reason", .string)
            .field("action_duration", .datetime)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("account_logs").delete()
    }
}
