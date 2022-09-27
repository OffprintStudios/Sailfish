//
// Created by Alyx Mote on 9/17/22.
//

import Fluent

struct AddFieldEditedOn: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("blogs")
            .field("edited_on", .datetime)
            .update()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("blogs")
            .deleteField("edited_on")
            .update()
    }
}
