//
// Created by Alyx Mote on 8/5/22.
//

import Vapor
import Fluent
import NanoID

final class Blog: Model, Content {
    static let schema = "blogs"

    @ID(custom: "id", generatedBy: .user)
    var id: String?

    @Parent(key: "author_id")
    var author: Profile

    @Field(key: "title")
    var title: String

    @OptionalField(key: "desc")
    var desc: String?

    @Field(key: "body")
    var body: String

    @Field(key: "rating")
    var rating: ContentRating

    @Field(key: "stats")
    var stats: BlogStats

    @Field(key: "status")
    var status: ApprovalStatus

    @OptionalField(key: "published_on")
    var publishedOn: Date?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() { }

    init(id: String? = nil, from formData: BlogForm) {
        if let hasId = id {
            self.id = hasId
        } else {
            self.id = NanoID.with(size: NANO_ID_SIZE)
        }

        title = formData.title
        desc = formData.desc
        body = formData.body
        rating = formData.rating
        stats = .init()
        status = .draft
        publishedOn = nil
    }
}

extension Blog {
    struct BlogStats: Codable {
        var words: Int
        var views: Int
        var comments: Int

        init() {
            words = 0
            views = 0
            comments = 0
        }
    }

    struct BlogForm: Content {
        var title: String
        var desc: String?
        var body: String
        var rating: ContentRating
    }
}

extension Blog.BlogForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(3...120), required: true)
        validations.add("desc", as: String.self, is: .count(3...240), required: false)
        validations.add("body", as: String.self, is: .count(3...), required: true)
        validations.add("rating", as: String.self, is: .in("Everyone", "Teen", "Mature", "Explicit"), required: true)
    }
}
