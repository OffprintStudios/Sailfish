//
//  Created by Alyx Mote on 12/24/22.
//

import Vapor
import Fluent

final class WorkComment: Model, Content {
    static let schema = "work_comments"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "work_id")
    var work: Work
    
    @Parent(key: "comment_id")
    var comment: Comment
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}
