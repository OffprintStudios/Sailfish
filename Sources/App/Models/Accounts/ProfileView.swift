import Vapor
import Fluent
import SQLKit

final class ProfileView: Model, Content {
    static let schema = "profile_view"

    @ID(custom: FieldKeys.id, generatedBy: .user)
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
    var presence: Profile.Presence
    
    @Field(key: FieldKeys.followers)
    var followers: Int64
    
    @Field(key: FieldKeys.following)
    var following: Int64
    
    @Field(key: FieldKeys.roles)
    var roles: [Account.Roles]
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?

    init() { }
}

extension ProfileView {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            
            let query = sqlDb.raw("""
                CREATE VIEW "\(raw: ProfileView.schema)" AS
                    SELECT profile.id,
                           profile.account_id AS account_id,
                           profile.username AS username,
                           profile.avatar AS avatar,
                           profile.banner_art AS banner_art,
                           profile.bio AS bio,
                           profile.tagline AS tagline,
                           profile.links AS links,
                           profile.presence AS presence,
                           COUNT(follows.id) AS followers,
                           COUNT(following.id) AS following,
                           account.roles AS roles,
                           profile.created_at AS created_at,
                           profile.updated_at AS updated_at
                    FROM profiles profile
                    LEFT JOIN followers follows ON follows.subscribed_to = profile.id
                    LEFT JOIN followers following ON following.profile_id = profile.id
                    LEFT JOIN accounts account ON account.id = profile.account_id
                    GROUP BY profile.id, account.id
            """)
            
            try await query.run()
        }
        
        func revert(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            try await sqlDb.raw("DROP VIEW \(raw: ProfileView.schema)").run()
        }
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
        static let followers: FieldKey = "followers"
        static let following: FieldKey = "following"
        static let roles: FieldKey = "roles"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}
