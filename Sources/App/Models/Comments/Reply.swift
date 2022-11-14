//
//  Created by Alyx Mote on 11/9/22.
//

import Vapor
import Fluent

final class Reply: Model, Content {
    static let schema = "comment_replies"
    
    @ID()
    var id: UUID?
    
    @Parent(key: "comment_id")
    var comment: Comment
    
    @Parent(key: "replies_to")
    var repliesTo: Comment
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, comment: Comment, repliesTo: Comment) throws {
        self.id = id
        self.$comment.id = try comment.requireID()
        self.$repliesTo.id = try repliesTo.requireID()
    }
}
