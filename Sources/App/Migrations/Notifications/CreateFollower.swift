//
// Created by Alyx Mote on 10/30/22.
//

import Fluent

struct CreateFollower: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("followers")
            .id()
            .field("profile_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("subscribed_to", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .unique(on: "profile_id", "subscribed_to")
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("followers").delete()
    }
}
