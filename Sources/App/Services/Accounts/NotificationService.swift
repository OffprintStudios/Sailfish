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
    
    func fetchNotificationCount() async throws -> Int {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await profile.$notifications.query(on: request.db)
            .count()
    }
    
    /// Fetches all a user's un-viewed notifications.
    func fetchActivity() async throws -> Page<Notification> {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await profile.$notifications.query(on: request.db)
            .with(\.$from)
            .filter(.sql(raw: "from_id IS NOT NULL"))
            .sort(\.$createdAt, .descending)
            .paginate(for: request)
    }
    
    /// Fetches a user's un-viewed system notifications
    func fetchSystemActivity() async throws -> Page<Notification> {
        let profile = try request.authService.getUser(withProfile: true).profile!
        return try await profile.$notifications.query(on: request.db)
            .filter(.sql(raw: "from_id IS NULL"))
            .sort(\.$createdAt, .descending)
            .paginate(for: request)
    }
    
    /// Marks a bunch of notifications as read by setting their `read_on` field through deletion. 
    func markAsRead(_ ids: [UUID]) async throws -> Response {
        let profile = try request.authService.getUser(withProfile: true).profile!
        try await request.db.transaction { database in
            for id in ids {
                try await profile.$activity.query(on: database).filter(\.$id == id).delete()
            }
        }
        return Response(status: .ok)
    }
}

extension Request {
    var notificationService: NotificationService {
        .init(request: self)
    }
}
