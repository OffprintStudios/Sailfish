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
    }
}

extension Tag {
    struct TagForm: Content {
        var name: String
        var desc: String?
        var parentId: String?
    }
    
    enum Kind: String, Codable {
        case fandom = "Fandom"
        case warning = "Warning"
        case genre = "Genre"
        case user = "User"
    }
}
