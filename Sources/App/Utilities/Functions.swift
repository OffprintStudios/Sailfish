//
// Created by Alyx Mote on 7/30/22.
//

import Foundation
import NanoID
import SwiftSoup

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

/// Returns the default whitelist for body HTML. Use in place of `Whitelist.relaxed()`.
func defaultWhitelist() throws -> Whitelist {
    try Whitelist.relaxed()
        .addTags("iframe", "hr", "s")
        .addAttributes("iframe", "width", "height", "allowfullscreen", "src", "start")
        .addAttributes("div", "data-youtube-video", "contenteditable", "draggable", "class")
        .addAttributes("p", "style")
        .addAttributes("span", "style")
        .addAttributes("hr", "contenteditable")
}

/// Generates an ID based on whether or not an ID was already provided.
func generateId(with id: String? = nil) -> String {
    if let hasId = id {
        return hasId
    } else {
        return NanoID.with(size: NANO_ID_SIZE)
    }
}
