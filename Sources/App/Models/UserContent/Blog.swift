//
// Created by Alyx Mote on 8/5/22.
//

import Vapor
import Fluent
import NanoID
import SwiftSoup

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

    @OptionalField(key: "cover")
    var cover: String?

    @Field(key: "rating")
    var rating: ContentRating

    @Field(key: "stats")
    var stats: BlogStats

    @Field(key: "news_post")
    var newsPost: Bool

    @OptionalField(key: "published_on")
    var publishedOn: Date?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() { }

    init(id: String? = nil, from formData: BlogForm) throws {
        if let hasId = id {
            self.id = hasId
        } else {
            self.id = NanoID.with(size: NANO_ID_SIZE)
        }

        title = try SwiftSoup.clean(formData.title, Whitelist.none())!
        if let hasDesc = formData.desc {
            desc = try SwiftSoup.clean(hasDesc, Whitelist.none())!
        } else {
            desc = nil
        }
        body = try SwiftSoup.clean(formData.body, Whitelist.relaxed())!
        cover = nil
        rating = formData.rating
        stats = .init()
        newsPost = false
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

    struct PublishBlogForm: Content {
        var pubDate: Date?
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
