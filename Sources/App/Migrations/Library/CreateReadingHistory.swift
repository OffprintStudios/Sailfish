//
//  Created by Alyx Mote on 12/10/22.
//

import Fluent

struct CreateReadingHistory: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("reading_history")
            .id()
            .field("profile_id", .string, .required, .references("profiles", "id", onDelete: .cascade))
            .field("work_id", .string, .required, .references("works", "id", onDelete: .cascade))
            .field("viewed_on", .datetime, .required)
            .field("vote", .int32, .required)
            .field("sections_read", .array(of: .string), .required)
            .field("bookmarked", .string, .references("sections", "id", onDelete: .setNull))
            .field("is_public", .bool, .required)
            .field("vote_changed", .datetime)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .unique(on: "profile_id", "work_id")
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("reading_history").delete()
    }
}
