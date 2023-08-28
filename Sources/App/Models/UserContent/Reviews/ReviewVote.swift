//
//  ReviewVote.swift
//  
//
//  Created by Alyx Mote on 8/26/23.
//

import Vapor
import Fluent

final class ReviewVote: Content, Model {
    static let schema = "review_votes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.review)
    var review: Review
    
    @Parent(key: FieldKeys.profile)
    var profile: Profile
    
    @Field(key: FieldKeys.rating)
    var rating: Rating
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, from profileId: Profile.IDValue, rating: Rating) {
        self.id = id
        self.$profile.id = profileId
        self.rating = rating
    }
}

extension ReviewVote {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            let ratingEnum = try await database.enum(Rating.schema)
                .case(Rating.liked.rawValue)
                .case(Rating.disliked.rawValue)
                .create()
            
            return try await database.schema(ReviewVote.schema)
                .id()
                .field(FieldKeys.review, .string, .required, .references(Review.schema, Review.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.profile, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.rating, ratingEnum, .required)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            return try await database.schema(ReviewVote.schema).delete()
        }
    }
    
    enum Rating: String, Codable {
        static let schema = "review_rating"
        case liked
        case disliked
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let review: FieldKey = "review_id"
        static let profile: FieldKey = "profile_id"
        static let rating: FieldKey = "rating"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
}
