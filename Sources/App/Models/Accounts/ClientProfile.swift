//
// Created by Alyx Mote on 8/6/22.
//

import Vapor

struct ClientProfile: Content {
    var id: String?
    var account: AccountInfo
    var username: String
    var avatar: String
    var info: Profile.ProfileInfo
    var stats: Profile.ProfileStats
    var createdAt: Date?
    var updatedAt: Date?

    init(from profile: Profile) {
        id = profile.id
        account = .init(id: profile.account.id, roles: profile.account.roles)
        username = profile.username
        avatar = profile.avatar
        info = profile.info
        stats = profile.stats
        createdAt = profile.createdAt
        updatedAt = profile.updatedAt
    }
}

extension ClientProfile {
    struct AccountInfo: Codable {
        var id: String?
        var roles: [Account.Roles]
    }
}
