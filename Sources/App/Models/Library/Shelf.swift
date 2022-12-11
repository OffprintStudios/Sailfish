//
//  Created by Alyx Mote on 12/10/22.
//

import Vapor
import Fluent
import SwiftSoup

final class Shelf: Model, Content {
    static let schema = "shelves"
    
    @ID(custom: "id", generatedBy: .user)
    var id: String?
    
    @Parent(key: "profile_id")
    var profile: Profile
    
    @Siblings(through: ShelfItem.self, from: \.$shelf, to: \.$work)
    var items: [Work]
    
    @Field(key: "name")
    var name: String
    
    @OptionalField(key: "desc")
    var desc: String?
    
    @OptionalField(key: "cover_art")
    var coverArt: String?
    
    @Field(key: "works")
    var works: Int64
    
    @Field(key: "is_public")
    var isPublic: Bool
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    init() { }
    
    init(id: String? = nil, with formInfo: ShelfForm) throws {
        self.id = generateId(with: id)
        name = try SwiftSoup.clean(formInfo.name, .none())!
        if let desc = formInfo.desc {
            self.desc = try SwiftSoup.clean(desc, .none())!
        }
        works = 0
        isPublic = formInfo.isPublic
    }
}

extension Shelf {
    struct ShelfForm: Content {
        var name: String
        var desc: String?
        var isPublic: Bool
    }
}

extension Shelf.ShelfForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .count(3...120), required: true)
        validations.add("desc", as: String.self, is: .count(3...240), required: true)
    }
}
