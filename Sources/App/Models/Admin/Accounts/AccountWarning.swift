//
// Created by Alyx Mote on 10/1/22.
//

import Vapor
import Fluent
import SwiftSoup

final class AccountWarning: Model, Content {
    static let schema = "account_warnings"

    @ID()
    var id: UUID?

    @Parent(key: "account_id")
    var account: Account

    @Parent(key: "warned_by")
    var warnedBy: Account

    @Field(key: "reason")
    var reason: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, warnedBy: Account.IDValue, warningForm: WarningForm) throws {
        self.id = id
        self.$account.id = warningForm.accountId
        self.$warnedBy.id = warnedBy
        reason = try SwiftSoup.clean(warningForm.reason, Whitelist.none())!
    }
}

extension AccountWarning {
    struct WarningForm: Codable {
        var accountId: String
        var reason: String
    }
}

extension AccountWarning.WarningForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("accountId", as: String.self, is: !.empty)
        validations.add("reason", as: String.self, is: .count(8...))
    }
}
