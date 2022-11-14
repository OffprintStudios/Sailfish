//
// Created by Alyx Mote on 11/12/22.
//

import Fluent

struct CreateTag: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("tags")
            .field("id", .string, .identifier(auto: false))
            .field("name", .string, .required)
            .field("desc", .string)
            .field("parent", .string, .references("tags", "id", onDelete: .cascade))
            .field("kind", .string, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("tags").delete()
    }
}
