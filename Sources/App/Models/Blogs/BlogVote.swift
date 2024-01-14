import Vapor
import Fluent

final class BlogVote: Model, Content {
    static let schema = "blog_votes"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: FieldKeys.profileId)
    var profile: Profile

    @Parent(key: FieldKeys.blogId)
    var blog: Blog

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

extension BlogVote {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(BlogVote.schema)
                .id()
                .field(FieldKeys.profileId, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.blogId, .string, .required, .references(Blog.schema, Blog.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.vote, .int32, .required)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(BlogVote.schema).delete()
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let profileId: FieldKey = "profile_id"
        static let blogId: FieldKey = "blog_id"
        static let vote: FieldKey = "vote"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}