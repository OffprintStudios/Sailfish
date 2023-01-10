//
//  Created by Alyx Mote on 1/3/23.
//

import Fluent
import SQLKit

struct CreatePG_TRGMExtension: AsyncMigration {
    func prepare(on database: Database) async throws {
        let sqlDatabase = (database as! SQLDatabase)
        try await sqlDatabase.raw("CREATE EXTENSION pg_trgm").run()
    }
    
    func revert(on database: Database) async throws {
        let sqlDatabase = (database as! SQLDatabase)
        try await sqlDatabase.raw("DROP EXTENSION pg_trgm").run()
    }
}
