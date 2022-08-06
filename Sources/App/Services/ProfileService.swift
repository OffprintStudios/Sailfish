//
// Created by Alyx Mote on 8/5/22.
//

import Vapor
import Fluent

struct ProfileService {
    let request: Request

    func fetchProfile(_ id: String) async throws -> Profile {
        let profile = try await Profile.query(on: request.db)
            .filter(\.$id == id)
            .join(Account.self, on: \Profile.$account.$id == \Account.$id)
            .field(Account.self, \.$id)
            .field(Account.self, \.$roles)
            .first()

        if let isSome = profile {
            return isSome
        } else {
            throw Abort(.notFound)
        }
    }
}

extension Request {
    var profileService: ProfileService {
        .init(request: self)
    }
}
