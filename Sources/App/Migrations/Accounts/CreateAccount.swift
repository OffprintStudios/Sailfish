//
// Created by Alyx Mote on 7/20/22.
//

import Fluent

struct CreateAccount: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("accounts")
            .field("id", .string, .identifier(auto: false))
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("roles", .array(of: .string), .required)
            .field("terms_agree", .bool)
            .field("email_confirmed", .bool)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("accounts").delete()
    }
}
