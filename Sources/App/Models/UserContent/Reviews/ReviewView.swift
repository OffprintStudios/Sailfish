//
//  ReviewView.swift
//  
//
//  Created by Alyx Mote on 8/27/23.
//

import Vapor
import Fluent
import SQLKit

final class ReviewView: Model, Content {
    static let schema = "review_view"
    
    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?
    
    @Parent(key: FieldKeys.work)
    var work: Work
    
    @Group(key: FieldKeys.profileGroup)
    var profile: ProfileInfo
    
    @Group(key: FieldKeys.sectionGroup)
    var section: SectionInfo
    
    @Field(key: FieldKeys.body)
    var body: String
    
    @Field(key: FieldKeys.likes)
    var likes: Int64
    
    @Field(key: FieldKeys.dislikes)
    var dislikes: Int64
    
    @Field(key: FieldKeys.recommended)
    var recommended: Bool
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() { }
}

extension ReviewView {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            
            let query = sqlDb.raw("""
                CREATE VIEW "\(raw: ReviewView.schema)" AS
                    SELECT
                        review.id AS id,
                        review.work_id AS work_id,
                        review.profile_id AS profile_id,
                        profile.username AS profile_username,
                        profile.avatar AS profile_avatar,
                        profile.banner_art AS profile_banner,
                        review.section_id AS section_id,
                        section.title AS section_title,
                        review.body AS body,
                        COUNT(likes.id) AS likes,
                        COUNT(dislikes.id) AS dislikes,
                        review.recommended AS recommended,
                        review.created_at AS created_at,
                        review.updated_at AS updated_at
                    FROM reviews review
                    LEFT JOIN profiles profile ON profile.id = review.profile_id
                    LEFT JOIN sections section ON section.id = review.section_id
                    LEFT JOIN review_votes likes ON likes.review_id = review.id AND likes.rating = 'liked'
                    LEFT JOIN review_votes dislikes ON dislikes.review_id = review.id AND dislikes.rating = 'disliked'
                    GROUP BY review.id, profile.id, section.id
            """)
            
            try await query.run()
        }
        
        func revert(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            try await sqlDb.raw("DROP VIEW \(raw: ReviewView.schema)").run()
        }
    }
    
    final class ProfileInfo: Fields {
        @Field(key: FieldKeys.profileId)
        var id: String
        
        @Field(key: FieldKeys.profileUsername)
        var username: String
        
        @Field(key: FieldKeys.profileAvatar)
        var avatar: String
        
        @OptionalField(key: FieldKeys.profileBanner)
        var banner: String?
    }
    
    final class SectionInfo: Fields {
        @Field(key: FieldKeys.sectionId)
        var id: String
        
        @Field(key: FieldKeys.sectionTitle)
        var title: String
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let work: FieldKey = "work_id"
        static let profileGroup: FieldKey = "profile"
        static let profileId: FieldKey = "id"
        static let profileUsername: FieldKey = "username"
        static let profileAvatar: FieldKey = "avatar"
        static let profileBanner: FieldKey = "banner"
        static let sectionGroup: FieldKey = "section"
        static let sectionId: FieldKey = "id"
        static let sectionTitle: FieldKey = "title"
        static let body: FieldKey = "body"
        static let likes: FieldKey = "likes"
        static let dislikes: FieldKey = "dislikes"
        static let recommended: FieldKey = "recommended"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}
