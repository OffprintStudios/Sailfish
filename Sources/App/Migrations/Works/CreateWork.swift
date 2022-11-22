//
// Created by Alyx Mote on 11/12/22.
//

import Fluent

struct CreateWork: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("works")
            .field("id", .string, .identifier(auto: false))
            .field("author_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("title", .string, .required)
            .field("short_desc", .string, .required)
            .field("long_desc", .string, .required)
            .field("category", .string, .required)
            .field("rating", .string, .required)
            .field("status", .string, .required)
            .field("cover_art", .string)
            .field("banner_art", .string)
            .field("words", .int64, .required, .sql(.default(0)))
            .field("views", .int64, .required, .sql(.default(0)))
            .field("likes", .int64, .required, .sql(.default(0)))
            .field("dislikes", .int64, .required, .sql(.default(0)))
            .field("comments", .int64, .required, .sql(.default(0)))
            .field("kind", .string, .required)
            .field("approval_status", .string, .required)
            .field("published_on", .datetime)
            .field("last_section_update", .datetime)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("works").delete()
    }
}
