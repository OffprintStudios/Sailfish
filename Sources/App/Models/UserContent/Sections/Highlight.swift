//
//  Created by Alyx Mote on 7/30/23.
//

import Vapor
import Fluent

final class Highlight: Model, Content {
    static let schema = "section_highlights"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.profile)
    var profile: Profile
    
    @Parent(key: FieldKeys.section)
    var section: Section
    
    @Field(key: FieldKeys.kind)
    var kind: Kind
    
    @Field(key: FieldKeys.startIdx)
    var startIdx: Int64
    
    @Field(key: FieldKeys.endIdx)
    var endIdx: Int64
    
    @OptionalField(key: FieldKeys.note)
    var note: String?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() { }
}

extension Highlight {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            return try await database.schema(Highlight.schema)
                .id()
                .field(FieldKeys.profile, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.section, .string, .required, .references(Section.schema, "id", onDelete: .cascade))
                .field(FieldKeys.kind, .string, .required)
                .field(FieldKeys.startIdx, .int64, .required)
                .field(FieldKeys.endIdx, .int64, .required)
                .field(FieldKeys.note, .string)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            return try await database.schema(Highlight.schema).delete()
        }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let profile: FieldKey = "profile_id"
        static let section: FieldKey = "section_id"
        static let kind: FieldKey = "kind"
        static let startIdx: FieldKey = "start_idx"
        static let endIdx: FieldKey = "end_idx"
        static let note: FieldKey = "note"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
    
    enum Kind: String, Codable {
        case note = "note"
        case highlight = "highlight"
    }
}
