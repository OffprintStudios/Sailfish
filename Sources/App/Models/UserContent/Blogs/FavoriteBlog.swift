//
// Created by Alyx Mote on 10/5/22.
//

import Vapor
import Fluent

final class FavoriteBlog: Model, Content {
    static let schema = "favorite_blogs"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "blog_id")
    var blog: Blog

    @Parent(key: "profile_id")
    var profile: Profile

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, _ blogId: String, for profileId: String) {
        self.id = id
        self.$blog.id = blogId
        self.$profile.id = profileId
    }
}
