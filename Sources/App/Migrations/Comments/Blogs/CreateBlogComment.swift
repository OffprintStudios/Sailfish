//
//  Created by Alyx Mote on 12/24/22.
//

import Fluent

struct CreateBlogComment: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("blog_comments")
            .id()
            .field("blog_id", .string, .required, .references("blogs", "id", onDelete: .cascade))
            .field("comment_id", .string, .required, .references("comments", "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .unique(on: "blog_id", "comment_id")
            .create()
    }
    
    func revert(on database: Database) async throws {
        return try await database.schema("blog_comments").delete()
    }
}
