//
// Created by Alyx Mote on 10/26/22.
//

import Vapor
import Fluent
import NanoID
import SwiftSoup

final class Comment: Model, Content {
    static let schema = "comments"

    @ID(custom: "id", generatedBy: .user)
    var id: String?

    @Parent(key: "profile_id")
    var profile: Profile
    
    @OptionalParent(key: "section_id")
    var section: Section?

    @Field(key: "body")
    var body: String

    @Field(key: "spoiler")
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

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
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
    struct CommentForm: Content {
        var type: CommentType
        var itemId: String
        var body: String
        var spoiler: Bool
        var repliesTo: [String]
        var sectionId: String?
    }
    
    enum CommentType: String, Codable {
        case work = "work"
        case blog = "blog"
    }
}
