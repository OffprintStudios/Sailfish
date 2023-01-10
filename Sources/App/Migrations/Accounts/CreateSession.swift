//
// Created by Alyx Mote on 7/20/22.
//

import Fluent

struct CreateSession: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("sessions")
            .id()
            .field("account_id", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("device_info", .dictionary(of: .string), .required)
            .field("expires", .datetime)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("sessions").delete()
    }
}
