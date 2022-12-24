//
// Created by Alyx Mote on 10/30/22.
//

import Foundation
import Vapor
import Fluent
import Queues

struct NewNotification: Codable {
    var to: String
    var from: String?
    var eventType: Notification.EventType
    var entityId: String?
    var context: [String: String]
    
    init(to recipient: String, from sender: String? = nil, event: Notification.EventType, entity: String? = nil, context: [String: String]) {
        self.to = recipient
        self.from = sender
        self.eventType = event
        self.entityId = entity
        self.context = context
    }
}

struct AddNotificationJob: AsyncJob {
    typealias Payload = NewNotification

    func dequeue(_ context: QueueContext, _ payload: Payload) async throws {
        let newNotification = Notification(
            from: payload.from,
            to: payload.to,
            with: Notification.EventInfo(
                eventType: payload.eventType,
                entityId: payload.entityId,
                context: payload.context
            )
        )
        try await context.application.db.transaction { database in
            try await newNotification.save(on: context.application.db)
        }
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: Payload) async throws {
        context.logger.warning("A job in the Notifications Queue has failed! Error: \(error.localizedDescription)")
    }
}
