//
//  Created by Alyx Mote on 1/23/23.
//

import Fluent

struct CreateWorkIPView: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("work_ip_views")
            .id()
            .field("work_id", .string, .required, .references("works", "id", onDelete: .cascade))
            .field("ip_address", .string, .required)
            .field("created_at", .datetime)
            .unique(on: "work_id", "ip_address")
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("work_ip_views").delete()
    }
}
