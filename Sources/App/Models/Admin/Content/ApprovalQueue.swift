//
//  Created by Alyx Mote on 12/10/22.
//

import Vapor
import Fluent

final class ApprovalQueue: Model, Content {
    static let schema = "approval_queue"
    
    @ID()
    var id: UUID?
    
    @Parent(key: "work_id")
    var work: Work
    
    @OptionalParent(key: "claimed_by")
    var claimedBy: Profile?
    
    @Field(key: "status")
    var status: Status
    
    @OptionalField(key: "reason")
    var reason: String?
    
    @Field(key: "attempts")
    var attempts: Int32
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, workId: String) {
        self.id = id
        self.$work.id = workId
        status = .waiting
        attempts = 1
    }
}

extension ApprovalQueue {
    enum Status: String, Codable {
        case waiting = "Waiting"
        case claimed = "Claimed"
        case approved = "Approved"
        case rejected = "Rejected"
    }
}
