//
//  Created by Alyx Mote on 12/24/22.
//

import Vapor
import Fluent

final class BlogComment: Model, Content {
    static let schema = "blog_comments"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "blog_id")
    var blog: Blog
    
    @Parent(key: "comment_id")
    var comment: Comment
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}
