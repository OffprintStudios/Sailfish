//
// Created by Alyx Mote on 7/20/22.
//

import Fluent

struct CreateInviteCode: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("invite_codes")
            .id()
            .field("code", .string, .required)
            .field("used", .bool)
            .field("byWho", .string)
            .unique(on: "code")
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("invite_codes").delete()
    }
}
