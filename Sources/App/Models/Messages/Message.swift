//
//  Message.swift
//
//
//  Created by Alyx Mote on 12/26/23.
//

import Vapor
import Fluent

final class Message: Model, Content {
    static let schema = "messages"
    
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.roomId)
    var room: Room
    
    @Parent(key: FieldKeys.profileId)
    var profile: Profile
    
    @Field(key: FieldKeys.content)
    var content: String
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() { }
}

extension Message {
    // TODO: Store messages in the database
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let roomId: FieldKey = "room_id"
        static let profileId: FieldKey = "profile_id"
        static let content: FieldKey = "content"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}
