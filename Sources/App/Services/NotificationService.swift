//
// Created by Alyx Mote on 10/30/22.
//

import Vapor
import Fluent

/// Offprint Notification Service
///
/// Contains functions related to the processing of notifications.
struct NotificationService {
    let request: Request

    /// Fetches all a user's un-viewed notifications.
    func fetchActivity(markedAsRead: Bool = false) async throws -> Page<Notification> {
        let profile = try request.authService.getUser(withProfile: true).profile!

        return try await Notification.query(on: request.db)
            .with(\.$sender)
            .with(\.$blog)
            .filter(\.$recipient.$id == profile.id!)
            .filter(\.$markedAsRead == markedAsRead)
            .sort(\.$createdAt, .descending)
            .paginate(for: request)
    }

    /// Marks a notification as read.
    func markAsRead(_ id: UUID) async throws {
        let profile = try request.authService.getUser(withProfile: true).profile!
        try await request.db.transaction { database in
            guard let notification: Notification = try await Notification.query(on: database)
                .filter(\.$id == id)
                .filter(\.$recipient.$id == profile.id!)
                .first() else {
                    throw Abort(.notFound, reason: "The notification you're trying to modify does not exist.")
                }
            notification.markedAsRead = true
            try await notification.save(on: database)
        }
    }
}

extension Request {
    var notificationService: NotificationService {
        .init(request: self)
    }
}
