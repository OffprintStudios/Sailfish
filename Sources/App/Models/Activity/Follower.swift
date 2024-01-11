//
//  Follower.swift
//
//
//  Created by Alyx Mote on 11/28/23.
//

import Vapor
import Fluent

final class Follower: Model, Content {
    static let schema = "followers"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.profileId)
    var profile: Profile
    
    @Parent(key: FieldKeys.subscribedTo)
    var subscribedTo: Profile
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    init() { }
}

extension Follower {
    struct Create: AsyncMigration {
        typealias FollowerKeys = FieldKeys
        typealias ProfileKeys = Profile.FieldKeys
        
        func prepare(on database: Database) async throws {
            try await database.schema(Follower.schema)
                .id()
                .field(FollowerKeys.profileId, .string, .required, .references(Profile.schema, ProfileKeys.id, onDelete: .cascade))
                .field(FollowerKeys.subscribedTo, .string, .required, .references(Profile.schema, ProfileKeys.id, onDelete: .cascade))
                .field(FollowerKeys.createdAt, .datetime)
                .unique(on: FollowerKeys.profileId, FollowerKeys.subscribedTo)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(Follower.schema).delete()
        }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let profileId: FieldKey = "profile_id"
        static let subscribedTo: FieldKey = "subscribed_to"
        static let createdAt: FieldKey = "created_at"
    }
}
