//
// Created by Alyx Mote on 12/2/22.
//

import Fluent

struct AddVolumePublishedOn: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("volumes")
            .field("published_on", .datetime)
            .update()
    }

    func revert(on database: Database) async throws {
        return try await database.schema("volumes")
            .deleteField("published_on")
            .update()
    }
}
