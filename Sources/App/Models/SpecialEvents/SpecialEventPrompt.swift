//
//  Created by Alyx Mote on 6/17/23.
//

import Vapor
import Fluent
import SwiftSoup

final class SpecialEventPrompt: Model, Content {
    static let schema = "special_event_prompts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.event)
    var event: SpecialEvent
    
    @Field(key: FieldKeys.prompt)
    var prompt: String
    
    @Field(key: FieldKeys.winner)
    var winner: Bool
    
    @Parent(key: FieldKeys.submittedBy)
    var submittedBy: Account
    
    @Children(for: \.$prompt)
    var votes: [SpecialEventPromptVote]
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, for eventId: SpecialEvent.IDValue, submittedBy: Account.IDValue, prompt: String) {
        self.id = id
        self.$event.id = eventId
        self.$submittedBy.id = submittedBy
        self.prompt = prompt
        self.winner = false
    }
}

extension SpecialEventPrompt {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            return try await database.schema(SpecialEventPrompt.schema)
                .id()
                .field(FieldKeys.event, .uuid, .required, .references(SpecialEvent.schema, SpecialEvent.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.prompt, .string, .required)
                .field(FieldKeys.winner, .bool, .required, .sql(.default(false)))
                .field(FieldKeys.submittedBy, .uuid, .required, .references(Account.schema, Account.FieldKeys.id, onDelete: .setNull))
                .field(FieldKeys.createdAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            return try await database.schema(SpecialEventPrompt.schema).delete()
        }
    }
    
    struct Middleware: AsyncModelMiddleware {
        func create(model: SpecialEventPrompt, on db: Database, next: AnyAsyncModelResponder) async throws {
            model.prompt = try SwiftSoup.clean(model.prompt, .none())!
            try await next.create(model, on: db)
        }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let event: FieldKey = "event_id"
        static let prompt: FieldKey = "prompt"
        static let winner: FieldKey = "winner"
        static let submittedBy: FieldKey = "submitted_by"
        static let createdAt: FieldKey = "created_at"
    }
}
