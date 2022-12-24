//
//  Created by Alyx Mote on 12/10/22.
//

import Vapor
import Fluent

final class LibraryItem: Model, Content {
    static let schema = "library_items"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "profile_id")
    var profile: Profile
    
    @Parent(key: "work_id")
    var work: Work
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}
