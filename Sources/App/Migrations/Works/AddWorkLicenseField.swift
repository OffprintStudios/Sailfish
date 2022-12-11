//
//  Created by Alyx Mote on 12/10/22.
//

import Fluent

struct AddWorkLicenseField: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("works")
            .field("license", .array(of: .string))
            .update()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("works")
            .deleteField("license")
            .update()
    }
}
