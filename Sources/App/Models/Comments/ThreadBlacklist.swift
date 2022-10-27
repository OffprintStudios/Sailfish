//
// Created by Alyx Mote on 10/26/22.
//

import Vapor
import Fluent
import NanoID
import SwiftSoup

final class ThreadBlacklist: Model, Content {
    static let schema = "thread_blacklist"

    @ID()
    var id: UUID?

    @Parent(key: "thread_id")
    var thread: Thread

    @Parent(key: "profile_id")
    var profile: Profile

    @Field(key: "reason")
    var reason: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, with formInfo: BlacklistForm) throws {
        self.id = id
        self.$profile.id = formInfo.profileId
        reason = try SwiftSoup.clean(formInfo.reason, Whitelist.none())!
    }
}

extension ThreadBlacklist {
    struct BlacklistForm: Content {
        var threadId: String
        var profileId: String
        var reason: String
    }
}
