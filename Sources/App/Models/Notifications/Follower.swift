//
// Created by Alyx Mote on 10/30/22.
//

import Vapor
import Fluent

final class Follower: Model, Content {
    static let schema = "followers"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "profile_id")
    var profile: Profile

    @Parent(key: "subscribed_to")
    var subscribedTo: Profile

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }
}
