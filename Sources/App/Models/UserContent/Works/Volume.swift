//
//  Created by Alyx Mote on 11/13/22.
//

import Vapor
import Fluent

final class Volume: Model, Content {
    static let schema = "volumes"
    
    @ID(custom: "id", generatedBy: .user)
    var id: String?
    
    @Parent(key: "work_id")
    var work: Work
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "desc")
    var desc: String
    
    @Children(for: \.$volume)
    var sections: [Section]
    
    @OptionalField(key: "cover_art")
    var coverArt: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
}

extension Volume {
    struct VolumeForm: Content {
        var title: String
        var desc: String
    }
}
