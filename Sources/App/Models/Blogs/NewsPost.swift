import Vapor
import Fluent
import SwiftSoup

final class NewsPost: Model, Content {
    static let schema = "news_posts"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: FieldKeys.blogId)
    var blog: Blog

    @Field(key: FieldKeys.blurb)
    var blurb: String

    @Field(key: FieldKeys.bannerArt)
    var bannerArt: String

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    init() { }
}

extension NewsPost {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(NewsPost.schema)
                .id()
                .field(FieldKeys.blogId, .string, .required, .references(Blog.schema, Blog.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.bannerArt, .string, .required)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .unique(on: FieldKeys.blogId)
                .create()
        }

        func revert(on database: Database) async throws {
        
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let blogId: FieldKey = "blog_id"
        static let blurb: FieldKey = "blurb"
        static let bannerArt: FieldKey = "banner_art"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}