//
//  Created by Alyx Mote on 1/21/23.
//

import Fluent

struct CreateEmailConfirmation: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("email_confirmations")
            .id()
            .field("account_id", .uuid, .required, .references("accounts", "id", onDelete: .cascade))
            .field("confirmation_code", .string, .required)
            .field("used", .bool, .required)
            .field("expires_on", .datetime, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "account_id", "confirmation_code")
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("email_confirmations").delete()
    }
}
