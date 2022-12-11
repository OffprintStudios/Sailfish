//
//  Created by Alyx Mote on 12/11/22.
//

import Fluent

struct AddVoteChangedField: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("reading_history")
            .field("vote_changed", .datetime)
            .update()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("reading_history")
            .deleteField("vote_changed")
            .update()
    }
}
