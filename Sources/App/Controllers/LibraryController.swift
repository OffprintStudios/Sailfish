//
//  Created by Alyx Mote on 12/12/22.
//

import Vapor
import Fluent

struct LibraryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let library = routes.grouped("library")
            .grouped([
                IdentityGuard(needs: [.user], checkProfile: true),
                MutedGuard(),
                BannedGuard(),
            ])
        
        library.get("fetch-all") { request async throws -> Page<Work> in
            try await request.libraryService.fetchLibrary()
        }
        
        library.get("fetch-one") { request async throws -> LibraryService.CheckLibrary in
            let workId: String? = request.query["workId"]
            if let id = workId {
                return try await request.libraryService.fetchLibraryItem(for: id)
            }
            throw Abort(.badRequest, reason: "This request must provide the work ID in query parameters.")
        }
        
        library.put("add-one") { request async throws -> LibraryService.CheckLibrary in
            let workId: String? = request.query["workId"]
            if let id = workId {
                return try await request.libraryService.addToLibrary(id)
            }
            throw Abort(.badRequest, reason: "This request must provide the work ID in query parameters.")
        }
        
        library.delete("remove-one") { request async throws -> LibraryService.CheckLibrary in
            let workId: String? = request.query["workId"]
            if let id = workId {
                return try await request.libraryService.removeFromLibrary(id)
            }
            throw Abort(.badRequest, reason: "This request must provide the work ID in query parameters.")
        }
    }
}
