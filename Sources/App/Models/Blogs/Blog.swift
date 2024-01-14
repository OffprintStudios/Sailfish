import Vapor
import Fluent
import SwiftSoup

final class Blog: Model, Content {
    static let schema = "blogs"

    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?

    @Parent(key: FieldKeys.authorId)
    var author: Profile

    @Field(key: FieldKeys.title)
    var title: String

    @Field(key: FieldKeys.body)
    var body: String

    @Enum(key: FieldKeys.rating)
    var rating: ContentRating

    @Field(key: FieldKeys.words)
    var words: Int64

    @OptionalChild(for: \.$blog)
    var newsPostInfo: NewsPost?

    @OptionalChild(for: \.$blog)
    var publishInfo: PublishedBlog?

    @Siblings(through: FavoriteBlog.self, from: \.$blog, to: \.$profile)
    var favoritedBy: [Profile]

    @Children(for: \.$blog)
    var votes: [BlogVote]

    @OptionalField(key: FieldKeys.editedOn)
    var editedOn: Date?

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    @Timestamp(key: FieldKeys.deletedAt, on: .delete)
    var deletedAt: Date?

    init() { }

    init(id: String? = nil, with formInfo: FormInfo) {
        self.id = generateId(with: id)
        self.title = formInfo.title
        self.body = formInfo.body
        self.rating = formInfo.rating
    }
}

extension Blog {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            let ratingType = try await database.enum(ContentRating.schema).read()
            try await database.schema(Blog.schema)
                .field(FieldKeys.id, .string, .identifier(auto: false))
                .field(FieldKeys.authorId, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.title, .string, .required)
                .field(FieldKeys.body, .string, .required)
                .field(FieldKeys.rating, ratingType, .required)
                .field(FieldKeys.words, .int64, .required, .sql(.default(0)))
                .field(FieldKeys.editedOn, .datetime)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .field(FieldKeys.deletedAt, .datetime)
                .unique(on: FieldKeys.authorId, FieldKeys.title)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Blog.schema).delete()
        }
    }

    struct Middleware: AsyncModelMiddleware {
        func create(model: Blog, on db: Database, next: AnyAsyncModelResponder) async throws {
            model.title = try SwiftSoup.clean(model.title, .none())!
            model.body = try SwiftSoup.clean(model.body, defaultWhitelist())!
            model.words = try countWords(of: model.body)
            return try await next.create(model, on: db)
        }

        func update(model: Blog, on db: Database, next: AnyAsyncModelResponder) async throws {
            model.title = try SwiftSoup.clean(model.title, .none())!
            model.body = try SwiftSoup.clean(model.body, defaultWhitelist())!
            model.words = try countWords(of: model.body)
            model.editedOn = Date()
            return try await next.create(model, on: db)
        }
    }

    struct FormInfo: Content, Validatable {
        var title: String
        var body: String
        var rating: ContentRating

        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String.self, is: .count(3...120), required: true)
            validations.add("body", as: String.self, is: .count(3...), required: true)
            validations.add("rating", as: String.self, is: .in("everyone", "teen", "mature", "explicit"), required: true)
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let authorId: FieldKey = "author_id"
        static let title: FieldKey = "title"
        static let body: FieldKey = "body"
        static let rating: FieldKey = "rating"
        static let words: FieldKey = "words"
        static let editedOn: FieldKey = "edited_on"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
        static let deletedAt: FieldKey = "deleted_at"
    }
}