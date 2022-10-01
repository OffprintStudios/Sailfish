//
// Created by Alyx Mote on 9/27/22.
//

import Fluent

struct CreateAccountReport: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("account_reports")
            .id()
            .field("reported_by", .string, .required, .references("accounts", "id", onDelete: .cascade))
            .field("account_id", .string, .required, .references("accounts", "id", onDelete: .cascade))
            .field("type", .string, .required)
            .field("metadata", .dictionary(of: .string))
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("account_reports").delete()
    }
}
