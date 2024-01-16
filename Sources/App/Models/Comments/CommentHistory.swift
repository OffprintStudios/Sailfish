import Vapor
import Fluent

final class CommentHistory: Model, Content {
    static let schema = "comment_history"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: FieldKeys.commentId)
    var comment: Comment

    @Field(key: FieldKeys.oldBody)
    var oldBody: String

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, oldBody: String) {
        self.id = id
        self.oldBody = oldBody
    }
}

extension CommentHistory {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(CommentHistory.schema)
                .id()
                .field(FieldKeys.commentId, .string, .required, .references(Comment.schema, Comment.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.oldBody, .string, .required)
                .field(FieldKeys.createdAt, .datetime)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(CommentHistory.schema).delete()
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let commentId: FieldKey = "comment_id"
        static let oldBody: FieldKey = "old_body"
        static let createdAt: FieldKey = "created_at"
    }
}