//
// Created by Alyx Mote on 10/28/22.
//

import Fluent

struct CreateCommentHistory: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("comment_history")
            .id()
            .field("comment_id", .string, .required, .references("comments", "id", onDelete: .cascade))
            .field("old_body", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("comment_history").delete()
    }
}
