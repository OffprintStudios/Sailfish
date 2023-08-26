//
// Created by Alyx Mote on 7/30/22.
//

import Vapor

struct UserService {
    var account: Account
    var profile: Profile?
}

struct UserServiceKey: StorageKey {
    typealias Value = UserService
}

extension Request {
    var user: UserService? {
        get {
            storage[UserServiceKey.self]
        }
        set {
            storage[UserServiceKey.self] = newValue
        }
    }
}
