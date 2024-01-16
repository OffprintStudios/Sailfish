import Vapor
import Fluent

final class CommentVote: Model, Content {
    static let schema = "comment_votes"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: FieldKeys.profileId)
    var profile: Profile

    @Parent(key: FieldKeys.commentId)
    var comment: Comment

    @Field(key: FieldKeys.vote)
    var vote: VoteOption

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, from profileId: Profile.IDValue, vote: VoteOption) {
        self.id = id
        self.$profile.id = profileId
        self.vote = vote
    }
}

extension CommentVote {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(CommentVote.schema)
                .id()
                .field(FieldKeys.profileId, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.commentId, .string, .required, .references(Comment.schema, Comment.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.vote, .int32, .required)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .unique(on: FieldKeys.profileId, FieldKeys.commentId)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(CommentVote.schema).delete()
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let profileId: FieldKey = "profile_id"
        static let commentId: FieldKey = "comment_id"
        static let vote: FieldKey = "vote"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}