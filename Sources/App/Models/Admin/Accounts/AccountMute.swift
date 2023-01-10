//
// Created by Alyx Mote on 10/1/22.
//

import Vapor
import Fluent
import SwiftSoup
import Foundation

final class AccountMute: Model, Content {
    static let schema = "accounts_muted"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "account_id")
    var account: Account

    @Parent(key: "muted_by")
    var mutedBy: Profile

    @Field(key: "reason")
    var reason: String

    @Field(key: "expires_on")
    var expiresOn: Date

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, mutedBy: Profile.IDValue, muteForm: MuteForm) throws {
        self.id = id
        self.$account.id = muteForm.accountId
        self.$mutedBy.id = mutedBy
        reason = try SwiftSoup.clean(muteForm.reason, Whitelist.none())!
        switch muteForm.duration {
        case .eightHours:
            expiresOn = Calendar.current.date(byAdding: .hour, value: 8, to: Date())!
            break
        case .twelveHours:
            expiresOn = Calendar.current.date(byAdding: .hour, value: 12, to: Date())!
            break
        case .oneDay:
            expiresOn = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            break
        case .threeDays:
            expiresOn = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
            break
        case .oneWeek:
            expiresOn = Calendar.current.date(byAdding: .month, value: 7, to: Date())!
            break
        default:
            expiresOn = Calendar.current.date(byAdding: .hour, value: 8, to: Date())!
            break
        }
    }
}

extension AccountMute {
    struct MuteForm: Codable {
        var accountId: UUID
        var reason: String
        var duration: Durations
    }
}

extension AccountMute.MuteForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("accountId", as: String.self, is: !.empty)
        validations.add("reason", as: String.self, is: .count(3...))
        validations.add("durations", as: String.self, is: .in(Durations.allCases.compactMap { $0.rawValue }))
    }
}
