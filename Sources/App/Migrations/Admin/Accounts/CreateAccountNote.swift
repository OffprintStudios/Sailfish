//
// Created by Alyx Mote on 10/1/22.
//

import Fluent

struct CreateAccountNote: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("account_notes")
            .id()
            .field("added_by", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("account_id", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("message", .string, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("account_notes").delete()
    }
}
