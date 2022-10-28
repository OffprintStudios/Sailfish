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
    }
}

extension Comment {
    struct CommentForm: Content {
        var threadId: String
        var body: String
    }
}
