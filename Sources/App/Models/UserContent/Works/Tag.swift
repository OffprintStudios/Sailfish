//
//  Created by Alyx Mote on 11/12/22.
//

import Vapor
import Fluent
import SwiftSoup

final class Tag: Model, Content {
    static let schema = "tags"
    
    @ID(custom: "id", generatedBy: .user)
    var id: String?
    
    @Field(key: "name")
    var name: String
    
    @OptionalField(key: "desc")
    var desc: String?
    
    @OptionalParent(key: "parent")
    var parent: Tag?
    
    @OptionalParent(key: "event_id")
    var event: SpecialEvent?
    
    @Children(for: \.$parent)
    var children: [Tag]
    
    @Siblings(through: WorkTag.self, from: \.$tag, to: \.$work)
    var works: [Work]
    
    @Field(key: "kind")
    var kind: Kind
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: String? = nil, from formInfo: TagForm) throws {
        self.id = generateId(with: id)
        name = try SwiftSoup.clean(formInfo.name, .none())!
        if let hasDesc = formInfo.desc {
            desc = try SwiftSoup.clean(hasDesc, .none())!
        }
        self.$parent.id = formInfo.parentId
        kind = formInfo.kind
    }
}

extension Tag {
    struct TagForm: Content {
        var name: String
        var desc: String?
        var parentId: String?
        var kind: Kind
    }
    
    enum Kind: String, Codable {
        case fandom = "Fandom"
        case warning = "Warning"
        case genre = "Genre"
        case user = "User"
    }
    
    struct TopTag: Content {
        var id: String?
        var name: String
        var desc: String?
        var parent: String?
        var kind: Kind
        var created_at: Date?
        var updated_at: Date?
        var total: Int64
    }
}

extension Tag.TagForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty, required: true)
        validations.add("desc", as: String.self, is: .count(3...120), required: false)
        validations.add("parentId", as: String.self, required: false)
    }
}
