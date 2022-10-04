//
// Created by Alyx Mote on 7/22/22.
//

import Vapor

struct ClientAccount: Content {
    var id: String?
    var roles: [Account.Roles]
    var termsAgree: Bool
    var emailConfirmed: Bool
    var createdAt: Date?
    var updatedAt: Date?

    init(from account: Account) {
        id = account.id
        roles = account.roles
        termsAgree = account.termsAgree
        emailConfirmed = account.emailConfirmed
        createdAt = account.createdAt
        updatedAt = account.updatedAt
    }
}
