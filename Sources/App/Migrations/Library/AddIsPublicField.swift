//
//  Created by Alyx Mote on 12/12/22.
//

import Fluent

struct AddIsPublicField: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("reading_history")
            .field("is_public", .bool, .required, .sql(.default(false)))
            .update()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("reading_history")
            .deleteField("is_public")
            .update()
    }
}
