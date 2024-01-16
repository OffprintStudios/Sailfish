import Vapor
import Fluent
import SwiftSoup

final class Comment: Model, Content {
    static let schema = "comments"

    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?

    @Parent(key: FieldKeys.profileId)
    var profile: Profile

    @Field(key: FieldKeys.body)
    var body: String

    @Field(key: FieldKeys.spoiler)
    var spoiler: Bool

    @Children(for: \.$comment)
    var history: [CommentHistory]

    @Children(for: \.$comment)
    var votes: [CommentVote]

    @Siblings(through: BlogComment.self, from: \.$comment, to: \.$blog)
    var blogs: [Blog]

    @OptionalField(key: FieldKeys.editedOn)
    var editedOn: Date?

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    init() { }

    init(id: String? = nil, by profileId: Profile.IDValue, with formInfo: FormInfo) {
        self.id = generateId(with: id)
        self.$profile.id = profileId
        self.body = formInfo.body
        self.spoiler = formInfo.spoiler
    }
}

extension Comment {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(Comment.schema)
                .field(FieldKeys.id, .string, .identifier(auto: false))
                .field(FieldKeys.profileId, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.body, .string, .required)
                .field(FieldKeys.editedOn, .datetime)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Comment.schema).delete()
        }
    }

    struct Middleware: AsyncModelMiddleware {
        func create(model: Comment, on db: Database, next: AnyAsyncModelResponder) async throws {
            model.body = try SwiftSoup.clean(model.body, defaultWhitelist())!
            try await model.$history.create(CommentHistory(oldBody: model.body), on: db)
            return try await next.create(model, on: db)
        }

        func update(model: Comment, on db: Database, next: AnyAsyncModelResponder) async throws {
            model.body = try SwiftSoup.clean(model.body, defaultWhitelist())!
            model.editedOn = Date()
            try await model.$history.create(CommentHistory(oldBody: model.body), on: db)
            return try await next.update(model, on: db)
        }
    }

    struct FormInfo: Content, Validatable {
        var itemId: String
        var body: String
        var spoiler: Bool
        var repliesTo: [String]
        var locationUrl: String

        static func validations(_ validations: inout Validations) {
            validations.add("itemId", as: String.self, required: true)
            validations.add("body", as: String.self, is: .count(3...), required: true)
            validations.add("locationUrl", as: String.self, required: false)
        }
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let profileId: FieldKey = "profile_id"
        static let body: FieldKey = "body"
        static let spoiler: FieldKey = "spoiler"
        static let editedOn: FieldKey = "edited_on"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}