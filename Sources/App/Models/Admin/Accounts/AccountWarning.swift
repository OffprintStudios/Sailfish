//
// Created by Alyx Mote on 10/1/22.
//

import Vapor
import Fluent
import SwiftSoup

final class AccountWarning: Model, Content {
    static let schema = "account_warnings"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "account_id")
    var account: Account

    @Parent(key: "warned_by")
    var warnedBy: Profile

    @Field(key: "reason")
    var reason: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, warnedBy: Profile.IDValue, warningForm: WarningForm) throws {
        self.id = id
        self.$account.id = warningForm.accountId
        self.$warnedBy.id = warnedBy
        reason = try SwiftSoup.clean(warningForm.reason, Whitelist.none())!
    }
}

extension AccountWarning {
    struct WarningForm: Codable {
        var accountId: UUID
        var reason: String
        var duration: Durations?
    }
}

extension AccountWarning.WarningForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("accountId", as: String.self, is: !.empty)
        validations.add("reason", as: String.self, is: .count(3...))
        validations.add("durations", as: String.self, is: .in(Durations.allCases.compactMap { $0.rawValue }), required: false)
    }
}
