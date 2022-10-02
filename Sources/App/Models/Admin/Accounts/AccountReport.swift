//
// Created by Alyx Mote on 10/1/22.
//

import Vapor
import Fluent
import SwiftSoup

final class AccountReport: Model, Content {
    static let schema = "account_reports"

    @ID()
    var id: UUID?

    @Parent(key: "reported_by")
    var reportedBy: Account

    @Parent(key: "account_id")
    var account: Account

    @Field(key: "type")
    var type: ReportType

    @Field(key: "metadata")
    var metadata: ReportMetadata

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, reportedBy: Account.IDValue, formInfo: ReportForm) throws {
        self.id = id
        self.$reportedBy.id = reportedBy
        self.$account.id = formInfo.accountId
        metadata.itemId = formInfo.itemId
        metadata.reason = formInfo.reason
        if let desc = formInfo.desc {
            metadata.desc = try SwiftSoup.clean(desc, Whitelist.none())!
        } else {
            metadata.desc = nil
        }
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
    }

    struct ReportForm: Codable {
        var type: ReportType
        var accountId: String
        var itemId: String?
        var reason: String
        var desc: String?
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
