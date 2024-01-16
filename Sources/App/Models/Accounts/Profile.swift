//
//  Profile.swift
//
//
//  Created by Alyx Mote on 11/27/23.
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
    
    @OptionalField(key: FieldKeys.bio)
    var bio: String?
    
    @OptionalField(key: FieldKeys.tagline)
    var tagline: String?
    
    @Field(key: FieldKeys.links)
    var links: [String]
    
    @Field(key: FieldKeys.presence)
    var presence: Presence
    
    @Siblings(through: Follower.self, from: \.$profile, to: \.$subscribedTo)
    var following: [Profile]
    
    @Siblings(through: Follower.self, from: \.$subscribedTo, to: \.$profile)
    var followers: [Profile]

    @Children(for: \.$author)
    var blogs: [Blog]

    @Siblings(through: FavoriteBlog.self, from: \.$profile, to: \.$blog)
    var favoriteBlogs: [Blog]
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.deletedAt, on: .delete)
    var deletedAt: Date?
    
    init() { }
    
    init(id: String? = nil, from formData: FormInfo) {
        self.id = generateId(with: id)
        self.username = formData.username
        self.avatar = "https://images.offprint.net/avatars/avatar.png"
        self.bannerArt = nil
        self.bio = formData.bio
        self.tagline = formData.tagline
        self.links = []
        self.presence = .offline
    }
}

extension Profile {
    struct Create: AsyncMigration {
        typealias AccountKeys = Account.FieldKeys
        typealias ProfileKeys = FieldKeys
        
        func prepare(on database: Database) async throws {
            try await database.schema(Profile.schema)
                .field(ProfileKeys.id, .string, .identifier(auto: false))
                .field(ProfileKeys.accountId, .uuid, .required, .references(Account.schema, AccountKeys.id, onDelete: .cascade))
                .field(ProfileKeys.username, .string, .required)
                .field(ProfileKeys.avatar, .string, .required)
                .field(ProfileKeys.bannerArt, .string)
                .field(ProfileKeys.bio, .string)
                .field(ProfileKeys.tagline, .string)
                .field(ProfileKeys.links, .array(of: .string), .required)
                .field(ProfileKeys.presence, .string, .required)
                .field(ProfileKeys.createdAt, .datetime)
                .field(ProfileKeys.updatedAt, .datetime)
                .field(ProfileKeys.deletedAt, .datetime)
                .unique(on: ProfileKeys.username)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(Profile.schema).delete()
        }
    }
    
    struct Middleware: AsyncModelMiddleware {
        func create(model: Profile, on db: Database, next: AnyAsyncModelResponder) async throws {
            model.username = try SwiftSoup.clean(model.username, .none())!
            model.bio = model.bio == nil ? nil : try SwiftSoup.clean(model.bio!, .none())
            model.tagline = model.tagline == nil ? nil : try SwiftSoup.clean(model.tagline!, .none())
            return try await next.create(model, on: db)
        }
        
        func update(model: Profile, on db: Database, next: AnyAsyncModelResponder) async throws {
            model.username = try SwiftSoup.clean(model.username, .none())!
            model.bio = model.bio == nil ? nil : try SwiftSoup.clean(model.bio!, .none())
            model.tagline = model.tagline == nil ? nil : try SwiftSoup.clean(model.tagline!, .none())
            
            var sanitizedLinks: [String] = []
            for i in 0..<model.links.count {
                let sanitizedValue = try SwiftSoup.clean(model.links[i], .none())!
                sanitizedLinks.append(sanitizedValue)
            }
            model.links = sanitizedLinks
            
            return try await next.update(model, on: db)
        }
    }
    
    struct FormInfo: Content, Validatable {
        var username: String
        var bio: String?
        var tagline: String?
        var links: [String]
        
        static func validations(_ validations: inout Validations) {
            validations.add("username", as: String.self, is: .count(3...32), required: true)
            validations.add("bio", as: String.self, is: .count(3...120), required: false)
            validations.add("tagline", as: String.self, is: .count(3...32), required: false)
        }
    }

    enum Presence: String, Codable {
        case online = "Online"
        case offline = "Offline"
        case away = "Away"
        case doNotDisturb = "Do Not Disturb"
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let accountId: FieldKey = "account_id"
        static let username: FieldKey = "username"
        static let avatar: FieldKey = "avatar"
        static let bannerArt: FieldKey = "banner_art"
        static let bio: FieldKey = "bio"
        static let tagline: FieldKey = "tagline"
        static let links: FieldKey = "links"
        static let presence: FieldKey = "presence"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
        static let deletedAt: FieldKey = "deleted_at"
    }
}
