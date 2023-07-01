//
//  Created by Alyx Mote on 7/1/23.
//

import Fluent

struct AddTagEventId: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("tags")
            .field("event_id", .uuid, .references(SpecialEvent.schema, SpecialEvent.FieldKeys.id, onDelete: .cascade))
            .update()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("tags")
            .deleteField("event_id")
            .update()
    }
}
