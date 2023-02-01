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
    
    @Siblings(through: ShelfItem.self, from: \.$work, to: \.$shelf)
    var shelves: [Shelf]
    
    @Siblings(through: LibraryItem.self, from: \.$work, to: \.$profile)
    var addedBy: [Profile]
    
    @OptionalField(key: "cover_art")
    var coverArt: String?
    
    @OptionalField(key: "banner_art")
    var bannerArt: String?
    
    @Field(key: "words")
    var words: Int64
    
    @Field(key: "views")
    var views: Int64
    
    @Children(for: \.$work)
    var ipViews: [WorkIPView]
    
    @Field(key: "likes")
    var likes: Int64
    
    @Field(key: "dislikes")
    var dislikes: Int64
    
    @Siblings(through: WorkComment.self, from: \.$work, to: \.$comment)
    var comments: [Comment]
    
    @Children(for: \.$work)
    var volumes: [Volume]
    
    @Children(for: \.$work)
    var sections: [Section]
    
    @Children(for: \.$work)
    var votes: [ReadingHistory]
    
    @Field(key: "kind")
    var kind: Kind
    
    @Field(key: "approval_status")
    var approvalStatus: ApprovalStatus
    
    @OptionalField(key: "license")
    var license: [LicenseMarkers]?
    
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
        words = 0
        likes = 0
        dislikes = 0
        views = 0
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
        case nonfiction = "Nonfiction"
        case script = "Script"
        case anthology = "Anthology"
    }
    
    enum ApprovalStatus: String, Codable {
        case notSubmitted = "NotSubmitted"
        case approved = "Approved"
        case pending = "Pending"
        case rejected = "Rejected"
    }
    
    enum LicenseMarkers: String, Codable {
        case attribution = "BY"
        case noDerivatives = "ND"
        case shareAlike = "SA"
        case nonCommercial = "NC"
        case publicDomain = "Z"
    }
}

extension Work.WorkForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(3...120), required: true)
        validations.add("shortDesc", as: String.self, is: .count(3...240), required: true)
        validations.add("longDesc", as: String.self, is: .count(3...), required: true)
    }
}
