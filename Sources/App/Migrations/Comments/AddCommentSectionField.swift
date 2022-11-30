//
// Created by Alyx Mote on 11/29/22.
//

import Fluent

struct AddCommentSectionField: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("comments")
            .field("section_id", .string, .references("sections", "id", onDelete: .cascade))
            .update()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("comments")
            .deleteField("section_id")
            .update()
    }
}
