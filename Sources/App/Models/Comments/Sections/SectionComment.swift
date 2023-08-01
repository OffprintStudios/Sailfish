//
//  Created by Alyx Mote on 8/1/23.
//

import Vapor
import Fluent

final class SectionComment: Model, Content {
    static let schema = "section_comments"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.section)
    var section: Section
    
    @Parent(key: FieldKeys.comment)
    var comment: Comment
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    init() { }
}

extension SectionComment {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            return try await database.schema(SectionComment.schema)
                .id()
                .field(FieldKeys.section, .string, .required, .references(Section.schema, Section.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.comment, .string, .required, .references(Comment.schema, Comment.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.createdAt, .datetime)
                .unique(on: FieldKeys.section, FieldKeys.comment)
                .create()
        }
        
        func revert(on database: Database) async throws {
            return try await database.schema(SectionComment.schema).delete()
        }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let section: FieldKey = "section_id"
        static let comment: FieldKey = "comment_id"
        static let createdAt: FieldKey = "created_at"
    }
}
