//
//  Room.swift
//
//
//  Created by Alyx Mote on 12/24/23.
//

import Vapor
import Fluent

final class Room: Model, Content {
    static let schema = "rooms"
    
    @ID(key: .id)
    var id: UUID?
    
    @OptionalField(key: FieldKeys.subject)
    var subject: String?
    
    @Parent(key: FieldKeys.to)
    var to: Profile
    
    @Parent(key: FieldKeys.from)
    var from: Profile
    
    @Children(for: \.$room)
    var messages: [Message]
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: UUID? = nil) {
        self.id = id
    }
}

extension Room {
    // TODO: Store rooms in the database
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let subject: FieldKey = "subject"
        static let to: FieldKey = "to"
        static let from: FieldKey = "from"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}
