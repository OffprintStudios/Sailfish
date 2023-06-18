//
//  Created by Alyx Mote on 6/10/23.
//

import Vapor
import Fluent
import SwiftSoup

final class SpecialEvent: Model, Content {
    static let schema = "special_events"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.startedBy)
    var startedBy: Profile
    
    @Field(key: FieldKeys.name)
    var name: String
    
    @Field(key: FieldKeys.desc)
    var desc: String
    
    @OptionalField(key: FieldKeys.badgeUrl)
    var badgeUrl: String?
    
    @OptionalField(key: FieldKeys.headerUrl)
    var headerUrl: String?
    
    @OptionalField(key: FieldKeys.wordCountRange)
    var wordCountRange: [Int32]?
    
    @Field(key: FieldKeys.eventType)
    var eventType: EventType
    
    @Field(key: FieldKeys.eventDuration)
    var eventDuration: [Date]
    
    @Field(key: FieldKeys.eventRestriction)
    var eventRestriction: EventRestriction
    
    @OptionalField(key: FieldKeys.promptSubmissionLimit)
    var promptSubmissionLimit: Int32?
    
    @OptionalField(key: FieldKeys.promptSubmissionDuration)
    var promptSubmissionDuration: [Date]?
    
    @OptionalField(key: FieldKeys.promptVotingDuration)
    var promptVotingDuration: [Date]?
    
    @OptionalField(key: FieldKeys.generalWritingStart)
    var generalWritingStart: Date?
    
    @OptionalField(key: FieldKeys.contestSubmissionDeadline)
    var contestSubmissionDeadline: Date?
    
    @Children(for: \.$event)
    var prompts: [SpecialEventPrompt]
    
    @OptionalChild(for: \.$event)
    var tag: Tag?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, startedBy profileId: Profile.IDValue, with formInfo: SpecialEventForm) {
        self.id = id
        self.$startedBy.id = profileId
        self.name = formInfo.name
        self.desc = formInfo.desc
        self.wordCountRange = formInfo.wordCountRange
        self.eventType = formInfo.eventType
        self.eventDuration = formInfo.eventDuration
        self.eventRestriction = formInfo.eventRestriction
        self.promptSubmissionLimit = formInfo.promptSubmissionLimit
        self.promptSubmissionDuration = formInfo.promptSubmissionDuration
        self.promptVotingDuration = formInfo.promptVotingDuration
        self.generalWritingStart = formInfo.generalWritingStart
        self.contestSubmissionDeadline = formInfo.contestSubmissionDeadline
    }
}

extension SpecialEvent {
    struct Migration: AsyncMigration {
        func prepare(on database: Database) async throws {
            return try await database.schema(SpecialEvent.schema)
                .id()
                .field(FieldKeys.startedBy, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.name, .string, .required)
                .field(FieldKeys.desc, .string, .required)
                .field(FieldKeys.badgeUrl, .string)
                .field(FieldKeys.headerUrl, .string)
                .field(FieldKeys.wordCountRange, .array(of: .int32))
                .field(FieldKeys.eventType, .int32, .required)
                .field(FieldKeys.eventDuration, .array(of: .datetime), .required)
                .field(FieldKeys.eventRestriction, .int32, .required)
                .field(FieldKeys.promptSubmissionLimit, .int32)
                .field(FieldKeys.promptSubmissionDuration, .array(of: .datetime))
                .field(FieldKeys.promptVotingDuration, .array(of: .datetime))
                .field(FieldKeys.generalWritingStart, .datetime)
                .field(FieldKeys.contestSubmissionDeadline, .datetime)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            return try await database.schema(SpecialEvent.schema).delete()
        }
    }
    
    struct Middleware: AsyncModelMiddleware {
        func create(model: SpecialEvent, on db: Database, next: AnyAsyncModelResponder) async throws {
            model.name = try SwiftSoup.clean(model.name, .none())!
            model.desc = try SwiftSoup.clean(model.desc, defaultWhitelist())!
            try await next.create(model, on: db)
        }
        
        func update(model: SpecialEvent, on db: Database, next: AnyAsyncModelResponder) async throws {
            model.name = try SwiftSoup.clean(model.name, .none())!
            model.desc = try SwiftSoup.clean(model.desc, defaultWhitelist())!
            try await next.create(model, on: db)
        }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let startedBy: FieldKey = "started_by"
        static let name: FieldKey = "name"
        static let desc: FieldKey = "desc"
        static let badgeUrl: FieldKey = "badge_url"
        static let headerUrl: FieldKey = "header_url"
        static let wordCountRange: FieldKey = "word_count_range"
        static let eventType: FieldKey = "event_type"
        static let eventDuration: FieldKey = "event_duration"
        static let eventRestriction: FieldKey = "event_restriction"
        static let promptSubmissionLimit: FieldKey = "prompt_submission_limit"
        static let promptSubmissionDuration: FieldKey = "prompt_submission_duration"
        static let promptVotingDuration: FieldKey = "prompt_voting_duration"
        static let generalWritingStart: FieldKey = "general_writing_start"
        static let contestSubmissionDeadline: FieldKey = "contest_submission_deadline"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
    
    enum EventType: Int32, Codable {
        case general = 1
        case contest = 2
        case full = 3
    }
    
    enum EventRestriction: Int32, Codable {
        case proseOnly = 1
        case poetryOnly = 2
        case proseAndPoetry = 3
        case all = 4
    }
    
    struct SpecialEventForm {
        var name: String
        var desc: String
        var wordCountRange: [Int32]?
        var eventType: EventType
        var eventDuration: [Date]
        var eventRestriction: EventRestriction
        var promptSubmissionLimit: Int32?
        var promptSubmissionDuration: [Date]?
        var promptVotingDuration: [Date]?
        var generalWritingStart: Date?
        var contestSubmissionDeadline: Date?
    }
}
