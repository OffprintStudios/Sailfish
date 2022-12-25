//
// Created by Alyx Mote on 7/20/22.
//

import Fluent

struct CreateProfile: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("profiles")
            .field("id", .string, .identifier(auto: false))
            .field("account_id", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("username", .string, .required)
            .field("avatar", .string, .required)
            .field("banner_art", .string)
            .field("info", .dictionary(of: .string), .required)
            .field("links", .dictionary(of: .string), .required)
            .field("stats", .dictionary(of: .int), .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .unique(on: "username")
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("profiles").delete()
    }
}
