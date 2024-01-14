import Vapor
import Fluent

final class FavoriteBlog: Model, Content {
    static let schema = "favorite_blogs"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: FieldKeys.profileId)
    var profile: Profile

    @Parent(key: FieldKeys.blogId)
    var blog: Blog

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    init() { }
}

extension FavoriteBlog {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(FavoriteBlog.schema)
                .id()
                .field(FieldKeys.profileId, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.blogId, .string, .required, .references(Blog.schema, Blog.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.createdAt, .datetime)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(FavoriteBlog.schema).delete()
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let profileId: FieldKey = "profile_id"
        static let blogId: FieldKey = "blog_id"
        static let createdAt: FieldKey = "created_at"
    }
}