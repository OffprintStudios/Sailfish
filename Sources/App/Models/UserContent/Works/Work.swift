//
// Created by Alyx Mote on 11/12/22.
//

import Foundation
import Vapor
import Fluent
import SwiftSoup

final class Work: Model, Content {
    static let schema = "works"

    @ID(custom: "id", generatedBy: .user)
    var id: String?
    
    @Parent(key: "author_id")
    var author: Profile
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "short_desc")
    var shortDesc: String
    
    @Field(key: "long_desc")
    var longDesc: String
    
    @Field(key: "category")
    var category: Category
    
    @Field(key: "rating")
    var rating: ContentRating
    
    @Field(key: "status")
    var status: Status
    
    @Siblings(through: WorkTag.self, from: \.$work, to: \.$tag)
    var tags: [Tag]
    
    @OptionalField(key: "cover_art")
    var coverArt: String?
    
    @OptionalField(key: "banner_art")
    var bannerArt: String?
    
    @Field(key: "works")
    var words: UInt64
    
    @Field(key: "views")
    var views: UInt64
    
    @Field(key: "likes")
    var likes: UInt64
    
    @Field(key: "dislikes")
    var dislikes: UInt64
    
    @Field(key: "comments")
    var comments: UInt64
    
    @Children(for: \.$work)
    var sections: [Section]
    
    @Field(key: "kind")
    var kind: Kind
    
    @Field(key: "approval_status")
    var approvalStatus: ApprovalStatus
    
    @OptionalField(key: "published_on")
    var publishedOn: Date?
    
    @OptionalField(key: "last_section_update")
    var lastSectionUpdate: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    init() { }
    
    init(id: String? = nil, with formData: WorkForm) throws {
        self.id = generateId(with: id)
        title = try SwiftSoup.clean(formData.title, .none())!
        shortDesc = try SwiftSoup.clean(formData.shortDesc, .none())!
        longDesc = try SwiftSoup.clean(formData.longDesc, defaultWhitelist())!
        category = formData.category
        rating = formData.rating
        status = formData.status
        kind = formData.kind
        approvalStatus = .notSubmitted
    }
}

extension Work {
    struct WorkForm: Content {
        var title: String
        var shortDesc: String
        var longDesc: String
        var category: Category
        var tags: [String]
        var rating: ContentRating
        var status: Status
        var kind: Kind
    }
    
    enum Category: String, Codable {
        case original = "Original"
        case fanwork = "Fanwork"
    }
    
    enum Status: String, Codable {
        case incomplete = "Incomplete"
        case complete = "Complete"
        case paused = "Paused"
        case cancelled = "Cancelled"
    }
    
    enum Kind: String, Codable {
        case prose = "Prose"
        case poetry = "Poetry"
    }
    
    enum ApprovalStatus: String, Codable {
        case notSubmitted = "NotSubmitted"
        case approved = "Approved"
        case pending = "Pending"
        case rejected = "Rejected"
    }
}

extension Work.WorkForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(3...120), required: true)
        validations.add("shortDesc", as: String.self, is: .count(3...240), required: true)
        validations.add("longDesc", as: String.self, is: .count(3...), required: true)
    }
}
