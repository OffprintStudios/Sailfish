import Vapor
import Fluent

final class BlogComment: Model, Content {
    static let schema = "blog_comments"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: FieldKeys.blogId)
    var blog: Blog

    @Parent(key: FieldKeys.commentId)
    var comment: Comment

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    init() { }
}

extension BlogComment {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(BlogComment.schema)
                .id()
                .field(FieldKeys.blogId, .string, .required, .references(Blog.schema, Blog.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.commentId, .string, .required, .references(Comment.schema, Comment.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.createdAt, .datetime)
                .unique(on: FieldKeys.blogId, FieldKeys.commentId)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(BlogComment.schema).delete()
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let blogId: FieldKey = "blog_id"
        static let commentId: FieldKey = "comment_id"
        static let createdAt: FieldKey = "created_at"
    }
}