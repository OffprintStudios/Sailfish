//
//  Created by Alyx Mote on 11/13/22.
//

import Vapor
import Fluent
import SwiftSoup

final class Volume: Model, Content {
    static let schema = "volumes"
    
    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?
    
    @Parent(key: FieldKeys.work)
    var work: Work
    
    @Field(key: FieldKeys.title)
    var title: String
    
    @Field(key: FieldKeys.desc)
    var desc: String
    
    @Children(for: \.$volume)
    var sections: [Section]
    
    @OptionalField(key: FieldKeys.coverArt)
    var coverArt: String?

    @OptionalField(key: FieldKeys.publishedOn)
    var publishedOn: Date?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: String? = nil, with formInfo: VolumeForm) throws {
        self.id = generateId(with: id)
        title = try SwiftSoup.clean(formInfo.title, .none())!
        desc = try SwiftSoup.clean(formInfo.desc, .none())!
    }
}

extension Volume {
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let work: FieldKey = "work_id"
        static let title: FieldKey = "title"
        static let desc: FieldKey = "desc"
        static let coverArt: FieldKey = "cover_art"
        static let publishedOn: FieldKey = "published_on"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
    
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
