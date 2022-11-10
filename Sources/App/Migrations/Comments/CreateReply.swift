//
// Created by Alyx Mote on 11/9/22.
//

import Fluent

struct CreateReply: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("comment_replies")
            .id()
            .field("comment_id", .string, .required, .references("comments", "id", onDelete: .cascade))
            .field("replies_to", .string, .required, .references("comments", "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("comment_replies").delete()
    }
}
