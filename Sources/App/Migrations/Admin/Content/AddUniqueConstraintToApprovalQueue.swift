//
//  Created by Alyx Mote on 1/14/23.
//

import Fluent

struct AddUniqueConstraintToApprovalQueue: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("approval_queue")
            .unique(on: "work_id")
            .update()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("approval_queue")
            .deleteUnique(on: "work_id")
            .update()
    }
}
