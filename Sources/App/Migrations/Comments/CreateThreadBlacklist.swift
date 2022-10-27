//
// Created by Alyx Mote on 10/26/22.
//

import Fluent

struct CreateThreadBlacklist: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("thread_blacklist")
            .id()
            .field("thread_id", .string, .required, .references("threads", "id", onDelete: .cascade))
            .field("profile_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("reason", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("thread_blacklist").delete()
    }
}
