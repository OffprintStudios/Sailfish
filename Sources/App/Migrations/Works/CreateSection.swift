 //
//  Created by Alyx Mote on 11/12/22.
//

import Fluent

struct CreateSection: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("sections")
            .field("id", .string, .identifier(auto: false))
            .field("work_id", .string, .required, .references("works", "id", onDelete: .cascade))
            .field("volume_id", .string, .references("volumes", "id", onDelete: .setNull))
            .field("title", .string, .required)
            .field("body", .string, .required)
            .field("words", .int64, .required, .sql(.default(0)))
            .field("note_top", .string)
            .field("note_bottom", .string)
            .field("lang", .string, .required, .sql(.default("en")))
            .field("rank", .int64, .required)
            .field("published_on", .datetime)
            .field("first_published", .datetime)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("sections").delete()
    }
}
