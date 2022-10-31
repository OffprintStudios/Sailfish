//
// Created by Alyx Mote on 10/30/22.
//

import Vapor
import Fluent

final class Follower: Model, Content {
    static let schema = "followers"

    @ID()
    var id: UUID?

    @Parent(key: "profile_id")
    var profile: Profile

    @Parent(key: "subscribed_to")
    var subscribedTo: Profile

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, follow toFollow: String, for profileId: String) {
        self.id = id
        self.$profile.id = profileId
        self.$subscribedTo.id = toFollow
    }
}
