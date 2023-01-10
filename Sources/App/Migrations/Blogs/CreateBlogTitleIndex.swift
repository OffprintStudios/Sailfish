//
//  Created by Alyx Mote on 1/3/23.
//

import Fluent
import SQLKit

struct CreateBlogTitleIndex: AsyncMigration {
    func prepare(on database: Database) async throws {
        let sqlDatabase = (database as! SQLDatabase)
        try await sqlDatabase.raw("""
            CREATE INDEX blog_title_idx
            ON blogs
            USING GIN
            (\(raw: "title") gin_trgm_ops)
        """).run()
    }
    
    func revert(on database: Database) async throws {
        let sqlDatabase = (database as! SQLDatabase)
        try await sqlDatabase
            .raw("DROP INDEX blog_title_idx")
            .run()
    }
}
