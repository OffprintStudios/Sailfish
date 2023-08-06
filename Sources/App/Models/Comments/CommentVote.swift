//
//  Created by Alyx Mote on 8/5/23.
//

import Vapor
import Fluent

final class CommentVote: Model, Content {
    static let schema = "comment_votes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.profile)
    var profile: Profile
    
    @Parent(key: FieldKeys.comment)
    var comment: Comment
    
    @Enum(key: FieldKeys.rating)
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

extension CommentVote {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            let ratingEnum = try await database.enum(Rating.schema)
                .case(Rating.liked.rawValue)
                .case(Rating.disliked.rawValue)
                .create()
            
            return try await database.schema(CommentVote.schema)
                .id()
                .field(FieldKeys.profile, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.comment, .string, .required, .references(Comment.schema, Comment.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.rating, ratingEnum, .required)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .unique(on: FieldKeys.profile, FieldKeys.comment)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(CommentVote.schema).delete()
            return try await database.enum(schema).delete()
        }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let profile: FieldKey = "profile_id"
        static let comment: FieldKey = "comment_id"
        static let rating: FieldKey = "rating"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
    }
    
    enum Rating: String, Codable {
        static let schema = "comment_rating"
        case liked
        case disliked
    }
}
