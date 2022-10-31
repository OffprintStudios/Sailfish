//
// Created by Alyx Mote on 10/30/22.
//

import Vapor
import Fluent

final class Notification: Model, Content {
    static let schema = "notifications"

    @ID()
    var id: UUID?

    @Parent(key: "sender_id")
    var sender: Profile

    @Parent(key: "recipient_id")
    var recipient: Profile

    @Field(key: "event_kind")
    var eventKind: EventKind

    @Field(key: "item_kind")
    var itemKind: ItemKind

    @OptionalParent(key: "blog_id")
    var blog: Blog?

    @OptionalParent(key: "comment_id")
    var comment: Comment?

    @OptionalField(key: "context")
    var context: [String: String]?

    @Field(key: "marked_as_read")
    var markedAsRead: Bool

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, from sender: String, to recipient: String, with eventInfo: EventInfo) {
        self.id = id
        self.$sender.id = sender
        self.$recipient.id = recipient
        eventKind = eventInfo.eventKind
        itemKind = eventInfo.itemKind
        context = eventInfo.context
    }
}

extension Notification {
    enum ItemKind: String, Codable {
        case user = "user"
        case blog = "blog"
        // case work = "work"
        // case approvalQueue = "approval-queue"
        // case admin = "admin"
    }

    enum EventKind: String, Codable {
        // User events
        case follow = "follow"
        case newBlog = "new-blog"
        case newWork = "new-work"

        // Blog events
        case addFavorite = "add-favorite"
        case newBlogComment = "new-blog-comment"

        // Work events
        case newWorkComment = "new-work-comment"
        case addToLibrary = "add-to-library"

        // Approval Queue events
        case receivedInQueue = "received-in-queue"
        case workApproved = "work-approved"
        case workRejected = "work-rejected"

        // Admin events
        case userWarned = "user-warned"
        case userTimeout = "user-timeout"
        case userBanned = "user-banned"
    }

    struct EventInfo {
        var eventKind: EventKind
        var itemKind: ItemKind
        var blogId: String?
        var commentId: String?
        var context: [String: String]?
    }
}
