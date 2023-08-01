//
//  Created by Alyx Mote on 8/1/23.
//

import Vapor
import Fluent

import Vapor
import Fluent
import SwiftSoup

final class SectionBlacklist: Model, Content {
    static let schema = "section_blacklist"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.section)
    var section: Section
    
    @Parent(key: FieldKeys.account)
    var account: Account
    
    @Field(key: FieldKeys.addedBy)
    var addedBy: ActionFault
    
    @Field(key: FieldKeys.reason)
    var reason: String
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, sectionId: String, accountId: UUID, addedBy: ActionFault, reason: String) throws {
        self.id = id
        self.$section.id = sectionId
        self.$account.id = accountId
        self.addedBy = addedBy
        self.reason = try SwiftSoup.clean(reason, .none())!
    }
}

extension SectionBlacklist {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            return try await database.schema(SectionBlacklist.schema)
                .id()
                .field(FieldKeys.section, .string, .required, .references(Section.schema, Section.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.account, .uuid, .required, .references(Account.schema, Account.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.addedBy, .string, .required)
                .field(FieldKeys.reason, .string, .required)
                .field(FieldKeys.createdAt, .datetime)
                .unique(on: FieldKeys.section, FieldKeys.account)
                .create()
        }
        
        func revert(on database: Database) async throws {
            return try await database.schema(SectionBlacklist.schema).delete()
        }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let section: FieldKey = "section_id"
        static let account: FieldKey = "account_id"
        static let addedBy: FieldKey = "added_by"
        static let reason: FieldKey = "reason"
        static let createdAt: FieldKey = "created_at"
    }
}
