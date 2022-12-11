//
// Created by Alyx Mote on 12/10/22.
//

import Fluent

struct CreateShelfItem: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("shelf_items")
            .id()
            .field("shelf_id", .string, .required, .references("shelves", "id", onDelete: .cascade))
            .field("work_id", .string, .required, .references("works", "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .unique(on: "shelf_id", "work_id")
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("shelf_items").delete()
    }
}
