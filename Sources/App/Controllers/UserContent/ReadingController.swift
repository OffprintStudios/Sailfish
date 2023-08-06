//
//  Created by Alyx Mote on 8/1/23.
//

import Vapor
import Fluent

struct ReadingController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let reading = routes.grouped("reading").grouped([
            IdentityGuard(needs: [.user], checkProfile: true, optional: true),
        ])
        let readingWithAuth = routes.grouped("reading").grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            ConfirmationGuard(),
            BannedGuard(),
        ])
        
        reading.get("fetch-work", ":id") { request async throws -> ReadingService.WorkPage in
            let id = request.parameters.get("id")!
            return try await request.readingService.fetchWork(id)
        }
        
        reading.get("fetch-section", ":id") { request async throws -> ReadingService.SectionPage in
            let id = request.parameters.get("id")!
            return try await request.readingService.fetchSection(id)
        }
        
        reading.get("fetch-section-comments", ":id") { request async throws -> ReadingService.FetchCommentsResponse in
            let id = request.parameters.get("id")!
            return try await request.readingService.fetchSectionComments(for: id)
        }
        
        readingWithAuth.post("toggle-cheer", ":id") { request async throws -> ReadingService.ToggleCheerResponse in
            let id = request.parameters.get("id")!
            return try await request.readingService.toggleCheer(for: id)
        }
    }
}
