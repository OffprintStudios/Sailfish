//
//  Created by Alyx Mote on 7/30/23.
//

import Vapor
import Fluent

final class Cheer: Model, Content {
    static let schema = "section_cheers"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.profile)
    var profile: Profile
    
    @Parent(key: FieldKeys.section)
    var section: Section
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, by profileId: Profile.IDValue) {
        self.id = id
        self.$profile.id = profileId
    }
}

extension Cheer {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            return try await database.schema(Cheer.schema)
                .id()
                .field(FieldKeys.profile, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.section, .string, .required, .references(Section.schema, "id", onDelete: .cascade))
                .field(FieldKeys.createdAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            return try await database.schema(Cheer.schema).delete()
        }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let profile: FieldKey = "profile_id"
        static let section: FieldKey = "section_id"
        static let createdAt: FieldKey = "created_at"
    }
}
