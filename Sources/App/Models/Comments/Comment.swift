//
// Created by Alyx Mote on 10/26/22.
//

import Vapor
import Fluent
import NanoID
import SwiftSoup

final class Comment: Model, Content {
    static let schema = "comments"

    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?

    @Parent(key: FieldKeys.profile)
    var profile: Profile
    
    @OptionalParent(key: FieldKeys.section)
    var section: Section?

    @Field(key: FieldKeys.body)
    var body: String

    @Field(key: FieldKeys.spoiler)
    var spoiler: Bool

    @Children(for: \.$comment)
    var history: [CommentHistory]
    
    @Siblings(through: Reply.self, from: \.$repliesTo, to: \.$comment)
    var replies: [Comment]
    
    @Siblings(through: Reply.self, from: \.$comment, to: \.$repliesTo)
    var repliesTo: [Comment]
    
    @Siblings(through: BlogComment.self, from: \.$comment, to: \.$blog)
    var blogs: [Blog]
    
    @Siblings(through: WorkComment.self, from: \.$comment, to: \.$work)
    var works: [Work]
    
    @Siblings(through: SectionComment.self, from: \.$comment, to: \.$section)
    var sections: [Section]
    
    @Children(for: \.$comment)
    var votes: [CommentVote]

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    init() { }

    init(id: String? = nil, by profileId: String, with formInfo: CommentForm) throws {
        if let hasId = id {
            self.id = hasId
        } else {
            self.id = NanoID.with(size: NANO_ID_SIZE)
        }

        self.$profile.id = profileId
        if let hasSection = formInfo.sectionId {
            self.$section.id = hasSection
        }
        body = try SwiftSoup.clean(formInfo.body, defaultWhitelist())!
        spoiler = formInfo.spoiler
    }
}

extension Comment {
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let profile: FieldKey = "profile_id"
        static let section: FieldKey = "section_id"
        static let body: FieldKey = "body"
        static let spoiler: FieldKey = "spoiler"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
    
    struct CommentForm: Content {
        var itemId: String
        var body: String
        var spoiler: Bool
        var repliesTo: [String]
        var sectionId: String?
        var locationUrl: String
    }
    
    struct ClientComment: Content {
        let comment: Comment
        let profile: ProfileView
    }
}

extension Comment.CommentForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("itemId", as: String.self, required: true)
        validations.add("body", as: String.self, is: .count(3...), required: true)
        validations.add("locationUrl", as: String.self, required: false)
    }
}
