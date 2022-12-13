//
// Created by Alyx Mote on 8/5/22.
//

import Vapor
import Fluent

struct ProfileService {
    let request: Request

    /// Fetches a profile given its ID. If no profile exists, throw a `notFound` error.
    func fetchProfile(_ id: String) async throws -> ClientProfile {
        guard let profile = try await Profile.query(on: request.db)
            .filter(\.$id == id)
            .with(\.$account)
            .first() else {
            throw Abort(.notFound, reason: "Could not find profile. Are you sure it exists?")
        }
        return ClientProfile(from: profile)
    }
}

extension Request {
    var profileService: ProfileService {
        .init(request: self)
    }
}
