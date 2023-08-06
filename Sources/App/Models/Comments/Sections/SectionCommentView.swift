//
//  Created by Alyx Mote on 8/5/23.
//

import Vapor
import Fluent
import SQLKit

final class SectionCommentView: Model, Content {
    static let schema = "section_comments_view"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.section)
    var section: Section
    
    @Parent(key: FieldKeys.comment)
    var comment: Comment
    
    @Group(key: FieldKeys.profileGroup)
    var profile: ProfileFields
    
    @Field(key: FieldKeys.body)
    var body: String
    
    @Field(key: FieldKeys.spoiler)
    var spoiler: Bool
    
    @Field(key: FieldKeys.likes)
    var likes: Int64
    
    @Field(key: FieldKeys.dislikes)
    var dislikes: Int64
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() { }
}

extension SectionCommentView {
    final class ProfileFields: Fields {
        @Field(key: FieldKeys.profileId)
        var id: String
        
        @Field(key: FieldKeys.profileName)
        var name: String
        
        @Field(key: FieldKeys.profileAvatar)
        var avatar: String
        
        @OptionalField(key: FieldKeys.profileBanner)
        var banner: String?
        
        @Field(key: FieldKeys.profileRoles)
        var roles: [Account.Roles]
        
        @Field(key: FieldKeys.profileStats)
        var stats: Profile.Stats
        
        init() { }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let section: FieldKey = "section_id"
        static let comment: FieldKey = "comment_id"
        static let profileGroup: FieldKey = "profile"
        static let profileId: FieldKey = "id"
        static let profileName: FieldKey = "name"
        static let profileAvatar: FieldKey = "avatar"
        static let profileBanner: FieldKey = "banner"
        static let profileRoles: FieldKey = "roles"
        static let profileStats: FieldKey = "stats"
        static let body: FieldKey = "body"
        static let spoiler: FieldKey = "spoiler"
        static let likes: FieldKey = "likes"
        static let dislikes: FieldKey = "dislikes"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
    
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            
            let query = sqlDb.raw("""
                CREATE VIEW "\(raw: SectionCommentView.schema)" AS
                    SELECT section_comment.id,
                           section.id AS section_id,
                           comment.id AS comment_id,
                           profile.id AS profile_id,
                           profile.username AS profile_name,
                           profile.avatar AS profile_avatar,
                           profile.banner_art AS profile_banner,
                           account.roles AS profile_roles,
                           profile.stats AS profile_stats,
                           comment.body AS body,
                           comment.spoiler AS spoiler,
                           COUNT(likes.id) AS likes,
                           COUNT(dislikes.id) AS dislikes,
                           comment.created_at AS created_at,
                           comment.updated_at AS updated_at
                    FROM section_comments section_comment
                    LEFT JOIN sections section ON section.id = section_comment.section_id
                    LEFT JOIN comments comment ON comment.id = section_comment.comment_id
                    LEFT JOIN profiles profile ON profile.id = comment.profile_id
                    LEFT JOIN accounts account ON account.id = profile.account_id
                    LEFT JOIN comment_votes likes ON likes.comment_id = comment.id AND likes.rating = 'liked'
                    LEFT JOIN comment_votes dislikes ON dislikes.comment_id = comment.id AND dislikes.rating = 'disliked'
                    GROUP BY section_comment.id, section.id, comment.id, profile.id, account.roles
            """)
            
            try await query.run()
        }
        
        func revert(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            try await sqlDb.raw("DROP VIEW \(raw: SectionCommentView.schema)").run()
        }
    }
}
