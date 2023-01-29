//
//  Created by Alyx Mote on 1/23/23.
//

import Vapor
import Fluent

final class WorkIPView: Model, Content {
    static let schema = "work_ip_views"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "work_id")
    var work: Work
    
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
