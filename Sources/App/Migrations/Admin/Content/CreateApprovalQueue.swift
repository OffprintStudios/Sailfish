//
//  Created by Alyx Mote on 12/10/22.
//

import Fluent

struct CreateApprovalQueue: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("approval_queue")
            .id()
            .field("work_id", .string, .required, .references("works", "id", onDelete: .cascade))
            .field("claimed_by", .string, .references("profiles", "id", onDelete: .cascade))
            .field("status", .string, .required)
            .field("reason", .string)
            .field("attempts", .int32, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("approval_queue").delete()
    }
}
