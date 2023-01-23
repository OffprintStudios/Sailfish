//
//  Created by Alyx Mote on 1/23/23.
//

import Fluent

struct CreateWorkIPView: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("work_ip_views")
            .id()
            .field("work_id", .string, .required, .references("works", "id", onDelete: .cascade))
            .field("ip_addr", .string, .required)
            .field("created_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("work_ip_views").delete()
    }
}
