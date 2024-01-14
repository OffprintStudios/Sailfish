import Vapor
import Fluent

final class PublishedBlog: Model, Content {
    static let schema = "published_blogs"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: FieldKeys.blogId)
    var blog: Blog

    @Field(key: FieldKeys.listed)
    var listed: Bool

    @Timestamp(key: FieldKeys.publishedOn, on: .create)
    var publishedOn: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil) {
        self.listed = true
    }
}

extension PublishedBlog {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(PublishedBlog.schema)
                .id()
                .field(FieldKeys.blogId, .string, .required, .references(Blog.schema, Blog.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.listed, .bool, .required, .sql(.default(true)))
                .field(FieldKeys.publishedOn, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .unique(on: FieldKeys.blogId)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(PublishedBlog.schema).delete()
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let blogId: FieldKey = "blog_id"
        static let listed: FieldKey = "listed"
        static let publishedOn: FieldKey = "published_on"
        static let updatedAt: FieldKey = "updated_at"
    }
}