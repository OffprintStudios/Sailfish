//
// Created by Alyx Mote on 11/12/22.
//

import Foundation
import Vapor
import Fluent
import SwiftSoup

final class Work: Model, Content {
    static let schema = "works"

    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?
    
    @Parent(key: FieldKeys.author)
    var author: Profile
    
    @Field(key: FieldKeys.title)
    var title: String
    
    @Field(key: FieldKeys.shortDesc)
    var shortDesc: String
    
    @Field(key: FieldKeys.longDesc)
    var longDesc: String
    
    @Field(key: FieldKeys.category)
    var category: Category
    
    @Field(key: FieldKeys.rating)
    var rating: ContentRating
    
    @Field(key: FieldKeys.status)
    var status: Status
    
    @Siblings(through: WorkTag.self, from: \.$work, to: \.$tag)
    var tags: [Tag]
    
    @Siblings(through: ShelfItem.self, from: \.$work, to: \.$shelf)
    var shelves: [Shelf]
    
    @Siblings(through: LibraryItem.self, from: \.$work, to: \.$profile)
    var addedBy: [Profile]
    
    @OptionalField(key: FieldKeys.coverArt)
    var coverArt: String?
    
    @OptionalField(key: FieldKeys.bannerArt)
    var bannerArt: String?
    
    @Field(key: FieldKeys.words)
    var words: Int64
    
    @Field(key: FieldKeys.views)
    var views: Int64
    
    @Children(for: \.$work)
    var ipViews: [WorkIPView]
    
    @Field(key: FieldKeys.likes)
    var likes: Int64
    
    @Field(key: FieldKeys.dislikes)
    var dislikes: Int64
    
    @Siblings(through: WorkComment.self, from: \.$work, to: \.$comment)
    var comments: [Comment]
    
    @Children(for: \.$work)
    var volumes: [Volume]
    
    @Children(for: \.$work)
    var sections: [Section]
    
    @Children(for: \.$work)
    var votes: [ReadingHistory]
    
    @Children(for: \.$work)
    var reviews: [ReviewView]
    
    @Field(key: FieldKeys.kind)
    var kind: Kind
    
    @Field(key: FieldKeys.approvalStatus)
    var approvalStatus: ApprovalStatus
    
    @OptionalField(key: FieldKeys.license)
    var license: [LicenseMarkers]?
    
    @OptionalField(key: FieldKeys.publishedOn)
    var publishedOn: Date?
    
    @OptionalField(key: FieldKeys.lastSectionUpdate)
    var lastSectionUpdate: Date?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.deletedAt, on: .delete)
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
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let author: FieldKey = "author_id"
        static let title: FieldKey = "title"
        static let shortDesc: FieldKey = "short_desc"
        static let longDesc: FieldKey = "long_desc"
        static let category: FieldKey = "category"
        static let rating: FieldKey = "rating"
        static let status: FieldKey = "status"
        static let coverArt: FieldKey = "cover_art"
        static let bannerArt: FieldKey = "banner_art"
        static let words: FieldKey = "words"
        static let views: FieldKey = "views"
        static let likes: FieldKey = "likes"
        static let dislikes: FieldKey = "dislikes"
        static let kind: FieldKey = "kind"
        static let approvalStatus: FieldKey = "approval_status"
        static let license: FieldKey = "license"
        static let publishedOn: FieldKey = "published_on"
        static let lastSectionUpdate: FieldKey = "last_section_update"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
        static let deletedAt: FieldKey = "deleted_at"
    }
    
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
