//
// Created by Alyx Mote on 10/26/22.
//

import Fluent

struct CreateComment: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("comments")
            .field("id", .string, .identifier(auto: false))
            .field("thread_id", .string, .required, .references("threads", "id", onDelete: .cascade))
            .field("profile_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("body", .string, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("comments").delete()
    }
}
