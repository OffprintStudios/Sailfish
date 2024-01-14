import Vapor
import Fluent
import SQLKit

final class BlogView: Model, Content {
    static let schema = "blog_view"
    
    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?

    @Group(key: FieldKeys.authorGroup)
    var author: Author

    @Field(key: FieldKeys.title)
    var title: String

    @Field(key: FieldKeys.body)
    var body: String

    @Enum(key: FieldKeys.rating)
    var rating: ContentRating

    @Field(key: FieldKeys.words)
    var words: Int64

    @OptionalField(key: FieldKeys.editedOn)
    var editedOn: Date?

    @OptionalField(key: FieldKeys.listed)
    var listed: Bool?

    @OptionalField(key: FieldKeys.publishedOn)
    var publishedOn: Date?

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    init() { }
}

extension BlogView {
    final class Author: Fields {
        @Field(key: FieldKeys.authorId)
        var id: String

        @Field(key: FieldKeys.authorName)
        var name: String

        @Field(key: FieldKeys.authorAvatar)
        var avatar: String

        init() { }
    }

    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase

            let query = sqlDb.raw("""
                CREATE VIEW "\(raw: BlogView.schema)" AS
                    SELECT blog.id,
                           profile.id AS \(raw: "\(FieldKeys.authorGroup)_\(FieldKeys.authorId)"),
                           profile.username AS \(raw: "\(FieldKeys.authorGroup)_\(FieldKeys.authorName)"),
                           profile.avatar AS \(raw: "\(FieldKeys.authorGroup)_\(FieldKeys.authorAvatar)"),
                           blog.title AS \(raw: FieldKeys.title.description),
                           blog.body AS \(raw: FieldKeys.body.description),
                           blog.rating AS \(raw: FieldKeys.rating.description),
                           blog.words AS \(raw: FieldKeys.words.description),
                           blog.edited_on AS \(raw: FieldKeys.editedOn.description),
                           info.listed AS \(raw: FieldKeys.listed.description),
                           info.published_on AS \(raw: FieldKeys.publishedOn.description),
                           blog.created_at AS \(raw: FieldKeys.createdAt.description),
                           blog.updated_at AS \(raw: FieldKeys.updatedAt.description)
                    FROM blogs blog
                    LEFT JOIN profiles profile ON blog.author_id = profile.id
                    LEFT JOIN published_blogs info ON info.blog_id = blog.id
                    GROUP BY blog.id, profile.id, info.id
            """)

            try await query.run()
        }

        func revert(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            try await sqlDb.raw("DROP VIEW \(raw: BlogView.schema)").run()
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let authorGroup: FieldKey = "author"
        static let authorId: FieldKey = "id"
        static let authorName: FieldKey = "name"
        static let authorAvatar: FieldKey = "avatar"
        static let title: FieldKey = "title"
        static let body: FieldKey = "body"
        static let rating: FieldKey = "rating"
        static let words: FieldKey = "words"
        static let editedOn: FieldKey = "edited_on"
        static let listed: FieldKey = "listed"
        static let publishedOn: FieldKey = "published_on"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}