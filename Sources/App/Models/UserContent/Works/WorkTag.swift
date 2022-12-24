//
//  Created by Alyx Mote on 11/12/22.
//

import Vapor
import Fluent

final class WorkTag: Model, Content {
    static let schema = "work_tags"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "work_id")
    var work: Work
    
    @Parent(key: "tag_id")
    var tag: Tag
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, work: Work, tag: Tag) throws {
        self.id = id
        self.$work.id = try work.requireID()
        self.$tag.id = try tag.requireID()
    }
}
