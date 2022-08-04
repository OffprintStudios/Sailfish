//
// Created by Alyx Mote on 7/21/22.
//

import Vapor
import Fluent

final class Profile: Model, Content {
    static let schema = "profiles"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "account_id")
    var account: Account

    @Field(key: "username")
    var username: String

    @Field(key: "avatar")
    var avatar: String

    @Field(key: "info")
    var info: ProfileInfo

    @Field(key: "stats")
    var stats: ProfileStats

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() { }

    init(id: UUID? = nil, from formData: ProfileForm) {
        self.id = id
        username = formData.username
        avatar = "https://images.offprint.net/avatars/avatar.png"
        info = .init(pronouns: formData.pronouns)
        stats = .init()
    }
}

extension Profile {
    struct ProfileInfo: Codable {
        var bio: String?
        var tagline: String?
        var coverPic: String?
        var pronouns: [Pronouns]
        var presence: Presence

        init(pronouns: [Pronouns]) {
            bio = nil
            tagline = nil
            coverPic = nil
            self.pronouns = pronouns
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
        var pronouns: [Pronouns]
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

    enum Pronouns: String, Codable {
        case sheHer = "She/Her"
        case heHim = "He/Him"
        case theyThem = "They/Them"
        case zeZir = "Ze/Zir"
        case anyAll = "Any/All"
    }
}

extension Profile.ProfileForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: .count(3...32), required: true)
        validations.add("bio", as: String.self, is: .count(3...240), required: false)
        validations.add("tagline", as: String.self, is: .count(3...32), required: false)
    }
}
