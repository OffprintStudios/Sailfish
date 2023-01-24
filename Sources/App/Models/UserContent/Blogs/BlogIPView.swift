//
//  Created by Alyx Mote on 1/23/23.
//

import Vapor
import Fluent

final class BlogIPView: Model, Content {
    static let schema = "blog_ip_views"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "blog_id")
    var blog: Blog
    
    @Field(key: "ip_address")
    var ipAddress: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, ipAddress: String) {
        self.id = id
        self.ipAddress = ipAddress
    }
}
