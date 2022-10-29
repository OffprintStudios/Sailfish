//
// Created by Alyx Mote on 10/28/22.
//

import Fluent

struct AddCommentSpoilerField: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("comments")
            .field("spoiler", .bool)
            .update()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("comments")
            .deleteField("spoiler")
            .update()
    }
}
