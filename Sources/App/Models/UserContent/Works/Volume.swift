//
//  Created by Alyx Mote on 11/13/22.
//

import Vapor
import Fluent
import SwiftSoup

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

    @OptionalField(key: "published_on")
    var publishedOn: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: String? = nil, with formInfo: VolumeForm) throws {
        self.id = generateId(with: id)
        title = try SwiftSoup.clean(formInfo.title, .none())!
        desc = try SwiftSoup.clean(formInfo.desc, .none())!
    }
}

extension Volume {
    struct VolumeForm: Content {
        var title: String
        var desc: String
    }
}

extension Volume.VolumeForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(3...120), required: true)
        validations.add("desc", as: String.self, is: .count(3...240), required: true)
    }
}
