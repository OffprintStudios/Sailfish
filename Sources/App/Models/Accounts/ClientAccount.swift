//
// Created by Alyx Mote on 7/22/22.
//

import Vapor

struct ClientAccount: Content {
    var id: UUID?
    var profiles: [Profile]
    var roles: [Account.Roles]
    var termsAgree: Bool
    var emailConfirmed: Bool
    var createdAt: Date?
    var updatedAt: Date?
    var token: String?

    init(from account: Account, token: String? = nil) {
        id = account.id
        profiles = account.$profiles.value ?? []
        roles = account.roles
        termsAgree = account.termsAgree
        emailConfirmed = account.emailConfirmed
        createdAt = account.createdAt
        updatedAt = account.updatedAt
        self.token = token
    }
}
