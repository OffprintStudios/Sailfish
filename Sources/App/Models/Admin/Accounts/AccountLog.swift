//
// Created by Alyx Mote on 10/1/22.
//

import Vapor
import Fluent
import SwiftSoup

final class AccountLog: Model, Content {
    static let schema = "account_logs"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "account_id")
    var account: Account

    @Group(key: "event")
    var event: Event

    @Group(key: "action")
    var action: Action

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, for accountId: Account.IDValue, eventInfo: LogForm) throws {
        self.id = id
        self.$account.id = accountId
        event.type = eventInfo.type
        event.detail = eventInfo.detail
        if let taken = eventInfo.actionTaken,
           let byId = eventInfo.actionBy,
           let reason = eventInfo.actionReason,
           let duration = eventInfo.actionDuration {
            action.taken = taken
            action.$by.id = byId
            action.reason = try SwiftSoup.clean(reason, Whitelist.none())!
            action.duration = duration
        }
    }
}

extension AccountLog {
    enum EventType: String, Codable {
        case create = "CREATE"
        case update = "UPDATE"
        case delete = "DELETE"
    }

    enum ActionType: String, Codable {
        case warn = "WARN"
        case mute = "MUTE"
        case tempban = "TEMPBAN"
        case ban = "BAN"
    }

    struct LogForm: Codable {
        var type: EventType
        var detail: String
        var actionTaken: ActionType?
        var actionBy: UUID?
        var actionReason: String?
        var actionDuration: Date?

        init(type: EventType, detail: String, actionTaken: ActionType? = nil, actionBy: UUID? = nil, actionReason: String? = nil, actionDuration: Date? = nil) {
            self.type = type
            self.detail = detail
            self.actionTaken = actionTaken
            self.actionBy = actionBy
            self.actionReason = actionReason
            self.actionDuration = actionDuration
        }
    }

    final class Event: Fields {
        @Field(key: "type")
        var type: EventType

        @Field(key: "detail")
        var detail: String
    }

    final class Action: Fields {
        @OptionalField(key: "taken")
        var taken: ActionType?

        @OptionalParent(key: "by")
        var by: Account?

        @OptionalField(key: "reason")
        var reason: String?

        @OptionalField(key: "duration")
        var duration: Date?
    }
}
