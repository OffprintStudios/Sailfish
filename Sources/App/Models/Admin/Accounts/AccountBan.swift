//
// Created by Alyx Mote on 10/1/22.
//

import Vapor
import Fluent
import SwiftSoup
import Foundation

final class AccountBan: Model, Content {
    static let schema = "account_bans"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "account_id")
    var account: Account

    @Parent(key: "banned_by")
    var bannedBy: Profile

    @Field(key: "reason")
    var reason: String

    @OptionalField(key: "expires_on")
    var expiresOn: Date?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, bannedBy: Profile.IDValue, banForm: BanForm) throws {
        self.id = id
        self.$account.id = banForm.accountId
        self.$bannedBy.id = bannedBy
        reason = try SwiftSoup.clean(banForm.reason, Whitelist.none())!
        switch banForm.duration {
        case .oneDay:
            expiresOn = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            break
        case .threeDays:
            expiresOn = Calendar.current.date(byAdding: .day, value: 3, to: Date())
            break
        case .oneWeek:
            expiresOn = Calendar.current.date(byAdding: .day, value: 7, to: Date())
            break
        case .twoWeeks:
            expiresOn = Calendar.current.date(byAdding: .day, value: 14, to: Date())
            break
        case .oneMonth:
            expiresOn = Calendar.current.date(byAdding: .month, value: 1, to: Date())
            break
        case .threeMonths:
            expiresOn = Calendar.current.date(byAdding: .month, value: 3, to: Date())
            break
        case .permanent:
            expiresOn = nil
            break
        default:
            expiresOn = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            break
        }
    }
}

extension AccountBan {
    struct BanForm: Codable {
        var accountId: UUID
        var reason: String
        var duration: Durations
    }
}

extension AccountBan.BanForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("accountId", as: String.self, is: !.empty)
        validations.add("reason", as: String.self, is: .count(3...))
        validations.add("durations", as: String.self, is: .in(Durations.allCases.compactMap { $0.rawValue }))
    }
}
