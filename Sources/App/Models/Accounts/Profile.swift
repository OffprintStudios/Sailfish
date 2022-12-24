//
// Created by Alyx Mote on 7/21/22.
//

import Vapor
import Fluent
import NanoID
import SwiftSoup

final class Profile: Model, Content {
    static let schema = "profiles"

    @ID(custom: "id", generatedBy: .user)
    var id: String?

    @Parent(key: "account_id")
    var account: Account

    @Field(key: "username")
    var username: String

    @Field(key: "avatar")
    var avatar: String

    @Field(key: "info")
    var info: ProfileInfo
    
    @Field(key: "links")
    var links: [String: String]

    @Field(key: "stats")
    var stats: ProfileStats

    @Children(for: \.$author)
    var blogs: [Blog]
    
    @Children(for: \.$author)
    var works: [Work]
    
    @Children(for: \.$to)
    var activity: [Notification]
    
    @Children(for: \.$profile)
    var shelves: [Shelf]
    
    @Siblings(through: Follower.self, from: \.$profile, to: \.$subscribedTo)
    var following: [Profile]
    
    @Siblings(through: Follower.self, from: \.$subscribedTo, to: \.$profile)
    var followers: [Profile]
    
    @Siblings(through: LibraryItem.self, from: \.$profile, to: \.$work)
    var library: [Work]
    
    @Children(for: \.$profile)
    var history: [ReadingHistory]

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() { }

    init(id: String? = nil, from formData: ProfileForm) throws {
        if let hasId = id {
            self.id = hasId
        } else {
            self.id = NanoID.with(size: NANO_ID_SIZE)
        }

        username = try SwiftSoup.clean(formData.username, Whitelist.none())!
        avatar = "https://images.offprint.net/avatars/avatar.png"
        info = .init()
        links = [:]
        stats = .init()
    }
}

extension Profile {
    struct ProfileInfo: Codable {
        var bio: String?
        var tagline: String?
        var coverPic: String?
        var presence: Presence

        init() {
            bio = nil
            tagline = nil
            coverPic = nil
            presence = .offline
        }
    }

    struct ProfileStats: Codable {
        var works: Int
        var blogs: Int
        var followers: Int
        var following: Int

        init() {
            works = 0
            blogs = 0
            followers = 0
            following = 0
        }
    }

    struct ProfileForm: Content {
        var username: String
        var presence: Presence
        var bio: String?
        var tagline: String?
    }

    enum Presence: String, Codable {
        case online = "Online"
        case offline = "Offline"
        case away = "Away"
        case doNotDisturb = "Do Not Disturb"
    }
}

extension Profile.ProfileForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: .count(3...32), required: true)
        validations.add("bio", as: String.self, is: .count(3...240), required: false)
        validations.add("tagline", as: String.self, is: .count(3...32), required: false)
    }
}
