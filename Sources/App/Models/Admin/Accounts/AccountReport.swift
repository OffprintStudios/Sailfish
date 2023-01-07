//
// Created by Alyx Mote on 10/1/22.
//

import Vapor
import Fluent
import SwiftSoup

final class AccountReport: Model, Content {
    static let schema = "account_reports"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "reported_by")
    var reportedBy: Account

    @Parent(key: "account_id")
    var account: Account

    @Field(key: "type")
    var type: ReportType

    @Field(key: "metadata")
    var metadata: ReportMetadata
    
    @Timestamp(key: "closed_on", on: .delete)
    var closedOn: Date?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, reportedBy: Account.IDValue, formInfo: ReportForm) throws {
        self.id = id
        self.$reportedBy.id = reportedBy
        self.$account.id = formInfo.accountId
        type = formInfo.type
        metadata = .init(
            itemId: formInfo.itemId,
            reason: formInfo.reason,
            desc: formInfo.desc != nil ? try SwiftSoup.clean(formInfo.desc!, .none())! : nil,
            link: formInfo.link
        )
    }
}

extension AccountReport {
    enum ReportType: String, Codable {
        case work = "work"
        case blog = "blog"
        case user = "user"
        case comment = "comment"
    }

    struct ReportMetadata: Codable {
        var itemId: String? // used when the reported item isn't just a user themselves
        var reason: String
        var desc: String?
        var link: String?
    }

    struct ReportForm: Codable {
        var type: ReportType
        var accountId: UUID
        var itemId: String?
        var reason: String
        var desc: String?
        var link: String?
    }
}

extension AccountReport.ReportForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("accountId", as: String.self, is: !.empty)
        validations.add("itemId", as: String.self, required: false)
        validations.add("reason", as: String.self, is: !.empty)
        validations.add("desc", as: String.self, is: .count(8...), required: false)
    }
}
