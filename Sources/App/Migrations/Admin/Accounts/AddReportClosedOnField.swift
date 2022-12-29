//
//  Created by Alyx Mote on 12/28/22.
//

import Fluent

struct AddReportClosedOnField: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("account_reports")
            .field("closed_on", .datetime)
            .update()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("account_reports")
            .deleteField("closed_on")
            .update()
    }
}
