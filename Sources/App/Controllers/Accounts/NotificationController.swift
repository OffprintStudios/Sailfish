//
// Created by Alyx Mote on 10/30/22.
//

import Vapor
import Fluent

struct NotificationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let notifications = routes.grouped("notifications")
            .grouped([
                IdentityGuard(needs: [.user], checkProfile: true),
                ConfirmationGuard(),
            ])
        
        notifications.get("fetch-count") { request async throws -> ActivityCount in
            return .init(count: try await request.notificationService.fetchNotificationCount())
        }

        notifications.get("fetch-activity") { request async throws -> Page<Notification> in
            try await request.notificationService.fetchActivity()
        }
        
        notifications.get("fetch-system-activity") { request async throws -> Page<Notification> in
            try await request.notificationService.fetchSystemActivity()
        }

        notifications.post("mark-as-read") { request async throws -> Response in
            struct IdsToMark: Content {
                var ids: [UUID]
            }
            
            let idsToMark = try request.content.decode(IdsToMark.self)
            return try await request.notificationService.markAsRead(idsToMark.ids)
        }
    }
}

extension NotificationController {
    struct ActivityCount: Content {
        var count: Int
    }
}
