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
            ])

        notifications.get("fetch-activity") { request async throws -> Page<Notification> in
            try await request.notificationService.fetchActivity()
        }

        notifications.get("mark-as-read", ":id") { request async throws -> Response in
            let id = request.parameters.get("id")!
            guard let uuid = UUID(uuidString: id) else {
                throw Abort(.internalServerError)
            }
            try await request.notificationService.markAsRead(uuid)
            return .init(status: .ok)
        }
    }
}
