//
// Created by Alyx Mote on 10/30/22.
//

import Fluent

struct CreateNotification: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("notifications")
            .id()
            .field("sender_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("recipient_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("event_kind", .string, .required)
            .field("item_kind", .string, .required)
            .field("blog_id", .string, .references("blogs", "id", onDelete: .cascade))
            .field("comment_id", .string, .references("comments", "id", onDelete: .cascade))
            .field("context", .dictionary(of: .string))
            .field("marked_as_read", .bool, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("notifications").delete()
    }
}
