//
//  Created by Alyx Mote on 11/12/22.
//

import Fluent

struct CreateWorkTag: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("work_tags")
            .id()
            .field("work_id", .string, .required, .references("works", "id", onDelete: .cascade))
            .field("tag_id", .string, .required, .references("tags", "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("work_tags").delete()
    }
}
