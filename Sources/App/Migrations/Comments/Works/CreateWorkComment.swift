//
//  Created by Alyx Mote on 12/24/22.
//

import Fluent

struct CreateWorkComment: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("work_comments")
            .id()
            .field("work_id", .string, .required, .references("works", "id", onDelete: .cascade))
            .field("comment_id", .string, .required, .references("comments", "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .unique(on: "work_id", "comment_id")
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("work_comments").delete()
    }
}
