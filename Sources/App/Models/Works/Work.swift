import Vapor
import Fluent
import SwiftSoup
import struct Foundation.Date

final class Work: Model, @unchecked Sendable {
    static let schema = "works"

    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?

    @Parent(key: FieldKeys.authorID)
    var author: Profile

    @Field(key: FieldKeys.title)
    var title: String

    @Field(key: FieldKeys.blurb)
    var blurb: String

    @Field(key: FieldKeys.desc)
    var desc: String

    @Enum(key: FieldKeys.category)
    var category: Category

    @Enum(key: FieldKeys.rating)
    var rating: ContentRating

    @Enum(key: FieldKeys.status)
    var status: Status

    @OptionalField(key: FieldKeys.coverArt)
    var coverArt: String?

    @OptionalField(key: FieldKeys.bannerArt)
    var bannerArt: String?

    @Enum(key: FieldKeys.kind)
    var kind: Kind

    @Field(key: FieldKeys.license)
    var license: License

    @Field(key: FieldKeys.attributions)
    var attributions: [Attribution: [String]]

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
        self.blurb = formInfo.blurb
        self.desc = formInfo.desc
        self.category = formInfo.category
        self.rating = formInfo.rating
        self.status = formInfo.status
        self.kind = formInfo.kind
        self.attributions = formInfo.attributions
        self.license = formInfo.license
    }

    func toObject() -> WorkObject {
        .init(
            id: self.id,
            authorID: self.$author.id, 
            authorName: self.$author.name, 
            title: self.$title.value!, 
            blurb: self.$blurb.value!, 
            desc: self.$desc.value!, 
            category: self.$category.value!, 
            rating: self.$rating.value!, 
            status: self.$status.value!, 
            kind: self.$kind.value!, 
            license: self.$license.value!, 
            attributions: self.$attributions.value!,
            words: 0,
            views: 0,
            likes: 0,
            dislikes: 0,
            createdAt: self.$createdAt.value!,
            updatedAt: self.$updatedAt.value!
        )
    }
}

extension Work {
    struct Create: AsyncMigration {
        func prepare(on database: any Database) async throws {
            let categoryType = try await database.enum(Category.schema)
                .case(Work.Category.original.rawValue)
                .case(Work.Category.fanwork.rawValue)
                .create()

            let ratingType = try await database.enum(ContentRating.schema).read()

            let statusType = try await database.enum(Status.schema)
                .case(Status.incomplete.rawValue)
                .case(Status.complete.rawValue)
                .case(Status.paused.rawValue)
                .case(Status.cancelled.rawValue)
                .create()

            let kindType = try await database.enum(Kind.schema)
                .case(Kind.prose.rawValue)
                .case(Kind.poetry.rawValue)
                .case(Kind.script.rawValue)
                .case(Kind.anthology.rawValue)
                .create()

            try await database.schema(Work.schema)
                .field(FieldKeys.id, .string, .identifier(auto: false))
                .field(FieldKeys.authorID, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.title, .string, .required)
                .field(FieldKeys.blurb, .string, .required)
                .field(FieldKeys.desc, .string, .required)
                .field(FieldKeys.category, categoryType, .required)
                .field(FieldKeys.rating, ratingType, .required)
                .field(FieldKeys.status, statusType, .required)
                .field(FieldKeys.coverArt, .string)
                .field(FieldKeys.bannerArt, .string)
                .field(FieldKeys.kind, kindType, .required)
                .field(FieldKeys.license, .string, .required)
                .field(FieldKeys.attributions, .json, .required)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .field(FieldKeys.deletedAt, .datetime)
                .create()
        }

        func revert(on database: any Database) async throws {
            try await database.schema(Work.schema).delete()
            try await database.enum(Category.schema).delete()
            try await database.enum(Status.schema).delete()
            try await database.enum(Kind.schema).delete()
        }
    }

    struct Middleware: AsyncModelMiddleware {
        func create(model: Work, on db: any Database, next: any AnyAsyncModelResponder) async throws {
            model.title = try SwiftSoup.clean(model.title, .none())!
            model.blurb = try SwiftSoup.clean(model.blurb, .none())!
            model.desc = try SwiftSoup.clean(model.desc, defaultWhitelist())!

            var cleanedAttributions: [Attribution: [String]] = [:]
            for attribution in model.attributions {
                var values: [String] = []
                for value in attribution.value {
                    values.append(try SwiftSoup.clean(value, .none())!)
                }
                cleanedAttributions[attribution.key] = values
            }
            model.attributions = cleanedAttributions

            return try await next.create(model, on: db)
        }

        func update(model: Work, on db: any Database, next: any AnyAsyncModelResponder) async throws {
            model.title = try SwiftSoup.clean(model.title, .none())!
            model.blurb = try SwiftSoup.clean(model.blurb, .none())!
            model.desc = try SwiftSoup.clean(model.desc, defaultWhitelist())!

            var cleanedAttributions: [Attribution: [String]] = [:]
            for attribution in model.attributions {
                var values: [String] = []
                for value in attribution.value {
                    values.append(try SwiftSoup.clean(value, .none())!)
                }
                cleanedAttributions[attribution.key] = values
            }
            model.attributions = cleanedAttributions

            return try await next.update(model, on: db)
        }
    }

    struct FormInfo: Content, Validatable {
        var title: String
        var blurb: String
        var desc: String
        var category: Category
        var tags: [String]
        var rating: ContentRating
        var status: Status
        var kind: Kind
        var attributions: [Attribution: [String]]
        var license: License

        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String.self, is: .count(3...120), required: true)
            validations.add("blurb", as: String.self, is: .count(3...240), required: true)
            validations.add("desc", as: String.self, is: .count(3...), required: true)
        }
    }

    enum Category: String, Codable {
        static let schema = "work_category"
        case original
        case fanwork
    }

    enum Status: String, Codable {
        static let schema = "work_status"
        case incomplete
        case complete
        case paused
        case cancelled
    }

    enum Kind: String, Codable {
        static let schema = "work_kind"
        case prose
        case poetry
        case script
        case anthology
    }

    enum License: String, Codable {
        case publicDomain = "CC0"
        case creditGiven = "CC BY"
        case sameTerms = "CC BY-SA"
        case noncommercial = "CC BY-NC"
        case noncommercialSameTerms = "CC BY-NC-SA"
        case noDerivatives = "CC BY-ND"
        case noncommercialNoDerivatives = "CC BY-NC-ND"
    }

    enum Attribution: String, Codable {
        case coAuthors = "Co-Authors"
        case editors = "Editors"
        case proofreaders = "Proofreaders"
        case betaReaders = "Beta Readers"
        case artists = "Artists"
        case translators = "Translators"
        case specialThanks = "Special Thanks"
    }

    enum FieldKeys {
        static let id: FieldKey = "id"
        static let authorID: FieldKey="author_id"
        static let title: FieldKey = "title"
        static let blurb: FieldKey = "blurb"
        static let desc: FieldKey = "desc"
        static let category: FieldKey = "category"
        static let rating: FieldKey = "rating"
        static let status: FieldKey = "status"
        static let coverArt: FieldKey = "cover_art"
        static let bannerArt: FieldKey = "banner_art"
        static let kind: FieldKey = "kind"
        static let license: FieldKey = "license"
        static let attributions: FieldKey = "attributions"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
        static let deletedAt: FieldKey = "deleted_at"
    }
}
