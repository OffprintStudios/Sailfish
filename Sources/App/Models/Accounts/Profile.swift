//
// Created by Alyx Mote on 7/21/22.
//

import Vapor
import Fluent
import NanoID
import SwiftSoup

final class Profile: Model, Content {
    static let schema = "profiles"

    @ID(custom: FieldKey.id, generatedBy: .user)
    var id: String?

    @Parent(key: FieldKeys.accountId)
    var account: Account

    @Field(key: FieldKeys.username)
    var username: String

    @Field(key: FieldKeys.avatar)
    var avatar: String
    
    @OptionalField(key: FieldKeys.bannerArt)
    var bannerArt: String?

    @Field(key: FieldKeys.info)
    var info: Info
    
    @Field(key: FieldKeys.links)
    var links: [String: String]

    @Field(key: FieldKeys.stats)
    var stats: Stats

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
    
    @Siblings(through: FavoriteBlog.self, from: \.$profile, to: \.$blog)
    var favoriteBlogs: [Blog]
    
    @Children(for: \.$profile)
    var history: [ReadingHistory]

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    @Timestamp(key: FieldKeys.deletedAt, on: .delete)
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
        bannerArt = nil
        if let hasBio = formData.bio {
            info = .init(bio: try SwiftSoup.clean(hasBio, .none())!)
        } else {
            info = .init(bio: "A brand new face")
        }
        links = [:]
        stats = .init()
    }
}

extension Profile {
    enum FieldKeys {
        static let accountId: FieldKey = "account_id"
        static let username: FieldKey = "username"
        static let avatar: FieldKey = "avatar"
        static let bannerArt: FieldKey = "banner_art"
        static let info: FieldKey = "info"
        static let links: FieldKey = "links"
        static let stats: FieldKey = "stats"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
        static let deletedAt: FieldKey = "deleted_at"
    }
    
    struct Info: Content {
        var bio: String?
        var tagline: String?
        var presence: Presence

        init(bio: String? = nil, tagline: String? = nil, presence: Presence = .offline) {
            self.bio = bio
            self.tagline = tagline
            self.presence = presence
        }
    }

    struct Stats: Content {
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
