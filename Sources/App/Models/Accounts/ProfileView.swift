//
//  Created by Alyx Mote on 12/25/22.
//

import Vapor
import Fluent

final class ProfileView: Model, Content {
    static let schema = "profile_view"
    
    @ID(custom: "id", generatedBy: .user)
    var id: String?
    
    @Field(key: FieldKeys.username)
    var username: String
    
    @Field(key: FieldKeys.avatar)
    var avatar: String
    
    @OptionalField(key: FieldKeys.bannerArt)
    var bannerArt: String?
    
    @Field(key: FieldKeys.info)
    var info: Profile.Info
    
    @Field(key: FieldKeys.links)
    var links: [String: String]
    
    @Field(key: FieldKeys.stats)
    var stats: Profile.Stats
    
    @Field(key: FieldKeys.roles)
    var roles: [Account.Roles]
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() { }
}

extension ProfileView {
    enum FieldKeys {
        static let username: FieldKey = "username"
        static let avatar: FieldKey = "avatar"
        static let bannerArt: FieldKey = "banner_art"
        static let info: FieldKey = "info"
        static let links: FieldKey = "links"
        static let stats: FieldKey = "stats"
        static let roles: FieldKey = "roles"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}
