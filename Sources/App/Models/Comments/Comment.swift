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

    @Parent(key: "thread_id")
    var thread: Thread

    @Parent(key: "profile_id")
    var profile: Profile

    @Field(key: "body")
    var body: String

    @Field(key: "spoiler")
    var spoiler: Bool

    @OptionalParent(key: "section_id")
    var section: Section?

    @Children(for: \.$comment)
    var history: [CommentHistory]
    
    @Siblings(through: Reply.self, from: \.$repliesTo, to: \.$comment)
    var replies: [Comment]
    
    @Siblings(through: Reply.self, from: \.$comment, to: \.$repliesTo)
    var repliesTo: [Comment]

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
        body = try SwiftSoup.clean(formInfo.body, defaultWhitelist())!
        spoiler = formInfo.spoiler
        self.$section.id = formInfo.sectionId
    }
}

extension Comment {
    struct CommentForm: Content {
        var threadId: String
        var body: String
        var spoiler: Bool
        var repliesTo: [String]
        var sectionId: String?
    }
}
