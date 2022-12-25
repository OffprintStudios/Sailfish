//
// Created by Alyx Mote on 8/5/22.
//

import Foundation
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

    @OptionalField(key: "banner_art")
    var bannerArt: String?

    @Field(key: "rating")
    var rating: ContentRating

    @Field(key: "stats")
    var stats: BlogStats

    @Field(key: "news_post")
    var newsPost: Bool
    
    @Siblings(through: BlogComment.self, from: \.$blog, to: \.$comment)
    var comments: [Comment]
    
    @Siblings(through: FavoriteBlog.self, from: \.$blog, to: \.$profile)
    var favoritedBy: [Profile]

    @OptionalField(key: "edited_on")
    var editedOn: Date?

    @OptionalField(key: "published_on")
    var publishedOn: Date?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() { }

    init(id: String? = nil, from formData: BlogForm, canMakeNewsPost: Bool = false) throws {
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
        body = try SwiftSoup.clean(formData.body, defaultWhitelist())!
        bannerArt = nil
        rating = formData.rating
        stats = .init(words: try SwiftSoup.clean(formData.body, Whitelist.none())!.split { !$0.isLetter }.count)
        if canMakeNewsPost {
            newsPost = formData.newsPost
        } else {
            newsPost = false
        }
        publishedOn = nil
        editedOn = nil
    }
}

extension Blog {
    struct BlogStats: Codable {
        var words: Int
        var views: Int
        var favorites: Int
        var comments: Int

        init(words: Int = 0, views: Int = 0, favorites: Int = 0, comments: Int = 0) {
            self.words = words
            self.views = views
            self.favorites = favorites
            self.comments = comments
        }
    }

    struct BlogForm: Content {
        var title: String
        var desc: String?
        var body: String
        var rating: ContentRating
        var newsPost: Bool
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

extension Blog.PublishBlogForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("pubDate", as: Date.self, is: .valid, required: false)
    }
}
