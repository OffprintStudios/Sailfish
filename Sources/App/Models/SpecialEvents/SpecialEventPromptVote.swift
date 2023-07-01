//
//  Created by Alyx Mote on 6/17/23.
//

import Vapor
import Fluent

final class SpecialEventPromptVote: Model, Content {
    static let schema = "special_event_prompt_votes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.prompt)
    var prompt: SpecialEventPrompt
    
    @Parent(key: FieldKeys.account)
    var account: Account
    
    @OptionalField(key: FieldKeys.vote)
    var vote: VoteValue?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, by accountId: Account.IDValue, for promptId: SpecialEventPrompt.IDValue, vote: VoteValue? = nil) {
        self.id = id
        self.$prompt.id = promptId
        self.$account.id = accountId
        self.vote = vote
    }
}

extension SpecialEventPromptVote {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            return try await database.schema(SpecialEventPromptVote.schema)
                .id()
                .field(FieldKeys.prompt, .uuid, .required, .references(SpecialEventPrompt.schema, SpecialEventPrompt.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.account, .uuid, .required, .references(Account.schema, Account.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.vote, .int32)
                .field(FieldKeys.createdAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            return try await database.schema(SpecialEventPromptVote.schema).delete()
        }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let prompt: FieldKey = "prompt_id"
        static let account: FieldKey = "account_id"
        static let vote: FieldKey = "vote"
        static let createdAt: FieldKey = "created_at"
    }
    
    enum VoteValue: Int32, Codable {
        case want = 1
        case isOkay = 0
        case dontWant = -1
    }
}
