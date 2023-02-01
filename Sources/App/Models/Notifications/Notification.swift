//
// Created by Alyx Mote on 10/30/22.
//

import Vapor
import Fluent

final class Notification: Model, Content {
    static let schema = "notifications"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "to_id")
    var to: Profile

    @OptionalParent(key: "from_id")
    var from: Profile?

    @Field(key: "event_type")
    var eventType: EventType

    @OptionalField(key: "entity_id")
    var entityId: String?

    @Field(key: "context")
    var context: [String: String]

    @Timestamp(key: "read_on", on: .delete)
    var readOn: Date?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, from sender: String? = nil, to recipient: String, with eventInfo: EventInfo) {
        self.id = id
        if let hasSender = sender {
            self.$from.id = hasSender
        }
        self.$to.id = recipient
        eventType = eventInfo.eventType
        entityId = eventInfo.entityId
        context = eventInfo.context
    }
}

extension Notification {
    enum EventType: String, Codable {
        // User events
        case follow = "follow"
        case newReply = "new-reply"
        
        // Blog events
        case addFavorite = "add-favorite"
        case newBlogComment = "new-blog-comment"
        
        // Work events
        case addToLibrary = "add-to-library"
        case newWorkComment = "new-work-comment"
        case workApproved = "work-approved"
        case workRejected = "work-rejected"
        
        // Admin events
        case userWarned = "user-warned"
        case userMuted = "user-muted"
        case userBanned = "user-banned"
    }
    
    struct EventInfo: Content {
        var eventType: EventType
        var entityId: String?
        var context: [String: String]
    }
}
