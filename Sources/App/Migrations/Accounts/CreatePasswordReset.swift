//
//  Created by Alyx Mote on 1/21/23.
//

import Fluent

struct CreatePasswordReset: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("password_resets")
            .id()
            .field("account_id", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("recovery_code", .string, .required)
            .field("used", .bool, .required)
            .field("expires_on", .datetime, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "account_id", "recovery_code")
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("password_resets").delete()
    }
}
