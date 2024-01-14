import Vapor
import Fluent
import SQLKit

final class PostView: Model, Content {
    static let schema = "post_view"

    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?

    @Group(key: FieldKeys.authorGroup)
    var author: Author

    @Field(key: FieldKeys.title)
    var title: String

    @Field(key: FieldKeys.blurb)
    var blurb: String

    @Field(key: FieldKeys.bannerArt)
    var bannerArt: String

    @Timestamp(key: FieldKeys.publishedOn, on: .create)
    var publishedOn: Date?

    init() { }
}

extension PostView {
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
                CREATE VIEW "\(raw: PostView.schema)" AS
                    SELECT  blog.id,
                            profile.id AS \(raw: "\(FieldKeys.authorGroup)_\(FieldKeys.authorId)"),
                            profile.username AS \(raw: "\(FieldKeys.authorGroup)_\(FieldKeys.authorName)"),
                            profile.avatar AS \(raw: "\(FieldKeys.authorGroup)_\(FieldKeys.authorAvatar)"),
                            blog.title AS \(raw: FieldKeys.title.description),
                            post.blurb AS \(raw: FieldKeys.blurb.description),
                            post.banner_art AS \(raw: FieldKeys.bannerArt.description),
                            info.published_on AS \(raw: FieldKeys.publishedOn.description)
                    FROM blogs blog
                    LEFT JOIN profiles profile ON blog.author_id = profile.id
                    LEFT JOIN news_posts post ON post.blog_id = blog.id
                    LEFT JOIN published_blogs info ON info.blog_id = blog.id
                    GROUP BY blog.id, profile.id, post.id, info.id
            """)

            try await query.run()
        }

        func revert(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            try await sqlDb.raw("DROP VIEW \(raw: PostView.schema)").run()
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let authorGroup: FieldKey = "author"
        static let authorId: FieldKey = "id"
        static let authorName: FieldKey = "name"
        static let authorAvatar: FieldKey = "avatar"
        static let title: FieldKey = "title"
        static let blurb: FieldKey = "blurb"
        static let bannerArt: FieldKey = "banner_art"
        static let publishedOn: FieldKey = "published_on"
    }
}