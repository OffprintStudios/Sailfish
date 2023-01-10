//
//  Created by Alyx Mote on 12/24/22.
//

import Vapor
import Fluent
import SwiftSoup

final class WorkBlacklist: Model, Content {
    static let schema = "work_blacklist"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "work_id")
    var work: Work
    
    @Parent(key: "account_id")
    var account: Account
    
    @Field(key: "added_by")
    var addedBy: ActionFault
    
    @Field(key: "reason")
    var reason: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, workId: String, accountId: UUID, addedBy: ActionFault, reason: String) throws {
        self.id = id
        self.$work.id = workId
        self.$account.id = accountId
        self.addedBy = addedBy
        self.reason = try SwiftSoup.clean(reason, .none())!
    }
}
