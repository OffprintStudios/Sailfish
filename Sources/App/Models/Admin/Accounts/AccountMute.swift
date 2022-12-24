//
// Created by Alyx Mote on 10/1/22.
//

import Vapor
import Fluent
import SwiftSoup

final class AccountMute: Model, Content {
    static let schema = "accounts_muted"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "account_id")
    var account: Account

    @Parent(key: "muted_by")
    var mutedBy: Account

    @Field(key: "reason")
    var reason: String

    @Field(key: "expires_on")
    var expiresOn: Date

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, mutedBy: Account.IDValue, muteForm: MuteForm) throws {
        self.id = id
        self.$account.id = muteForm.accountId
        self.$mutedBy.id = mutedBy
        reason = try SwiftSoup.clean(muteForm.reason, Whitelist.none())!
        expiresOn = muteForm.duration
    }
}

extension AccountMute {
    struct MuteForm: Codable {
        var accountId: UUID
        var reason: String
        var duration: Date
    }
}

extension AccountMute.MuteForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("accountId", as: String.self, is: !.empty)
        validations.add("reason", as: String.self, is: .count(8...))
    }
}
