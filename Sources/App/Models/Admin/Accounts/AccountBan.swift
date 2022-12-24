//
// Created by Alyx Mote on 10/1/22.
//

import Vapor
import Fluent
import SwiftSoup

final class AccountBan: Model, Content {
    static let schema = "account_bans"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "account_id")
    var account: Account

    @Parent(key: "banned_by")
    var bannedBy: Account

    @Field(key: "reason")
    var reason: String

    @OptionalField(key: "expires_on")
    var expiresOn: Date?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, bannedBy: Account.IDValue, banForm: BanForm) throws {
        self.id = id
        self.$account.id = banForm.accountId
        self.$bannedBy.id = bannedBy
        reason = try SwiftSoup.clean(banForm.reason, Whitelist.none())!
        expiresOn = banForm.duration
    }
}

extension AccountBan {
    struct BanForm: Codable {
        var accountId: UUID
        var reason: String
        var duration: Date?
    }
}

extension AccountBan.BanForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("accountId", as: String.self, is: !.empty)
        validations.add("reason", as: String.self, is: .count(8...))
    }
}
