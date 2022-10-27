//
// Created by Alyx Mote on 10/26/22.
//

import Fluent

struct CreateThread: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("threads")
            .field("id", .string, .identifier(auto: false))
            .field("created_by", .string, .references("profiles", "id", onDelete: .cascade))
            .field("open", .bool, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("threads").delete()
    }
}
