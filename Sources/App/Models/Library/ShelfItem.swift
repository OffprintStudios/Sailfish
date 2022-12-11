//
//  Created by Alyx Mote on 12/10/22.
//

import Vapor
import Fluent

final class ShelfItem: Model, Content {
    static let schema = "shelf_items"
    
    @ID()
    var id: UUID?
    
    @Parent(key: "shelf_id")
    var shelf: Shelf
    
    @Parent(key: "work_id")
    var work: Work
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
}
