//
// Created by Alyx Mote on 8/4/22.
//

import Fluent

struct CreateBlog: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("blogs")
            .field("id", .string, .identifier(auto: false))
            .field("author_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("title", .string, .required)
            .field("desc", .string)
            .field("body", .string, .required)
            .field("rating", .string, .required)
            .field("stats", .dictionary(of: .int), .required)
            .field("status", .string, .required)
            .field("published_on", .datetime)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("blogs").delete()
    }
}
