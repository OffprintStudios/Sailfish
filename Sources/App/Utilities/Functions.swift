//
// Created by Alyx Mote on 7/30/22.
//

import Foundation

/// Detects whether or not a user can access something give a set of roles.
func canAccess(needs requiredRoles: [Account.Roles], has rolesPresent: [Account.Roles]) -> Bool {
    let requiredSet = Set(requiredRoles)
    let presentSet = Set(rolesPresent)

    return requiredSet.intersection(presentSet).count != 0
}

/// Determines the ratings appropriate for the specified `filter`.
func determineRatings(from filter: ContentFilter) -> [ContentRating] {
    switch filter {
    case .mature:
        return [.everyone, .teen, .mature]
    case .explicit:
        return [.everyone, .teen, .explicit]
    case .everything:
        return [.everyone, .teen, .mature, .explicit]
    default:
        return [.everyone, .teen]
    }
}