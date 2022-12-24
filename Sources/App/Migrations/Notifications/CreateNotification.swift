//
// Created by Alyx Mote on 10/30/22.
//

import Fluent

struct CreateNotification: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("notifications")
            .id()
            .field("to_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("from_id", .string, .references("profiles", "id", onDelete: .cascade))
            .field("event_type", .string, .required)
            .field("entity_id", .string)
            .field("context", .dictionary(of: .string), .required)
            .field("read_on", .datetime)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("notifications").delete()
    }
}
