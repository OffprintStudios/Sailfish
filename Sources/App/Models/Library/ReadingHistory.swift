//
//  Created by Alyx Mote on 12/10/22.
//

import Vapor
import Fluent

final class ReadingHistory: Model, Content {
    static let schema = "reading_history"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "profile_id")
    var profile: Profile
    
    @Parent(key: "work_id")
    var work: Work
    
    @Field(key: "viewed_on")
    var viewedOn: Date
    
    @Field(key: "vote")
    var vote: Vote
    
    @Field(key: "sections_read")
    var sectionsRead: [String]
    
    @OptionalParent(key: "bookmarked")
    var bookmarked: Section?
    
    @OptionalField(key: "vote_changed")
    var voteChanged: Date?
    
    @Field(key: "is_public")
    var isPublic: Bool
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, workId: String) {
        self.id = id
        self.$work.id = workId
        viewedOn = Date()
        vote = .noVote
        sectionsRead = []
        isPublic = true
    }
}

extension ReadingHistory {
    enum Vote: Int32, Codable {
        case liked = 1
        case disliked = -1
        case noVote = 0
    }
    
    struct ChangeVote: Content {
        var vote: Vote
    }
}

extension ReadingHistory.ChangeVote: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("vote", as: Int32.self, is: .in(1, -1, 0), required: true)
    }
}
