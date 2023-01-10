//
// Created by Alyx Mote on 12/10/22.
//

import Fluent

struct CreateShelf: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("shelves")
            .field("id", .string, .identifier(auto: false))
            .field("profile_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("name", .string, .required)
            .field("desc", .string)
            .field("cover_art", .string)
            .field("works", .int64, .required)
            .field("is_public", .bool, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("shelves").delete()
    }
}
