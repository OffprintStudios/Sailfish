//
//  Created by Alyx Mote on 11/13/22.
//

import Fluent

struct CreateVolume: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("volumes")
            .field("id", .string, .identifier(auto: false))
            .field("work_id", .string, .required, .references("works", "id", onDelete: .cascade))
            .field("title", .string, .required)
            .field("desc", .string, .required)
            .field("cover_art", .string)
            .field("published_on", .datetime)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("volumes").delete()
    }
}
