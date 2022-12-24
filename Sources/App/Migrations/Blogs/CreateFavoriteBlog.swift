//
// Created by Alyx Mote on 10/5/22.
//

import Fluent

struct CreateFavoriteBlog: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("favorite_blogs")
            .id()
            .field("blog_id", .string, .required, .references("blogs", "id", onDelete: .cascade))
            .field("profile_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .unique(on: "blog_id", "profile_id")
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("favorite_blogs").delete()
    }
}
