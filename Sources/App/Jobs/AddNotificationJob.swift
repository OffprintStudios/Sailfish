//
// Created by Alyx Mote on 10/30/22.
//

import Foundation
import Vapor
import Fluent
import Queues

struct NewNotification: Codable {
    var sender: String
    var recipient: String
    var eventKind: Notification.EventKind
    var itemKind: Notification.ItemKind
    var blogId: String?
    var commentId: String?
    var context: [String: String]?

    init(sender: String, recipient: String, itemKind: Notification.ItemKind, eventKind: Notification.EventKind, blogId: String? = nil, commentId: String? = nil, context: [String: String]? = nil) {
        self.sender = sender
        self.recipient = recipient
        self.itemKind = itemKind
        self.eventKind = eventKind
        self.blogId = blogId
        self.commentId = commentId
        self.context = context
    }
}

struct AddNotificationJob: AsyncJob {
    typealias Payload = NewNotification

    func dequeue(_ context: QueueContext, _ payload: NewNotification) async throws {
        let newNotification = Notification(
            from: payload.sender,
            to: payload.recipient,
            with: Notification.EventInfo(
                eventKind: payload.eventKind,
                itemKind: payload.itemKind,
                blogId: payload.blogId,
                commentId: payload.commentId,
                context: payload.context
            )
        )
        try await context.application.db.transaction { database in
            try await newNotification.save(on: context.application.db)
        }
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: NewNotification) async throws {
        context.logger.warning("A job in the Notifications Queue has failed! Error: \(error.localizedDescription)")
    }
}
