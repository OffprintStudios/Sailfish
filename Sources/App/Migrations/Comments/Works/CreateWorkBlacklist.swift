//
//  Created by Alyx Mote on 12/24/22.
//

import Fluent

struct CreateWorkBlacklist: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("work_blacklist")
            .id()
            .field("work_id", .string, .required, .references("works", "id", onDelete: .cascade))
            .field("account_id", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("added_by", .string, .required)
            .field("reason", .string, .required)
            .field("created_at", .datetime)
            .unique(on: "work_id", "account_id")
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("work_blacklist").delete()
    }
}
