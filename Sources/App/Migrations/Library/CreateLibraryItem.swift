//
// Created by Alyx Mote on 12/10/22.
//

import Fluent

struct CreateLibraryItem: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("library_items")
            .id()
            .field("profile_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("work_id", .string, .required, .references("works", "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .unique(on: "profile_id", "work_id")
            .create()
    }

    func revert(on database: Database) async throws {}
}
