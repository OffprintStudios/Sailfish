//
//  Created by Alyx Mote on 1/23/23.
//

import Fluent

struct CreateBlogIPView: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("blog_ip_views")
            .id()
            .field("blog_id", .string, .required, .references("blogs", "id", onDelete: .cascade))
            .field("ip_address", .string, .required)
            .field("created_at", .datetime)
            .unique(on: "blog_id", "ip_address")
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("blog_ip_views").delete()
    }
}
