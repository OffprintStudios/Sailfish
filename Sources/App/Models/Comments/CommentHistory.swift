//
// Created by Alyx Mote on 10/28/22.
//

import Vapor
import Fluent

final class CommentHistory: Model, Content {
    static let schema = "comment_history"

    @ID()
    var id: UUID?

    @Parent(key: "comment_id")
    var comment: Comment

    @Field(key: "old_body")
    var oldBody: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, oldBody: String) {
        self.id = id
        self.oldBody = oldBody
    }
}
