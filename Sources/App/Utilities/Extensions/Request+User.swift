//
//  Request+User.swift
//
//
//  Created by Alyx Mote on 11/27/23.
//

import Vapor

struct User {
    var account: Account
    var profile: Profile?
}

struct UserKey: StorageKey {
    typealias Value = User
}

extension Request {
    var user: User? {
        get {
            storage[UserKey.self]
        }
        set {
            storage[UserKey.self] = newValue
        }
    }
}
