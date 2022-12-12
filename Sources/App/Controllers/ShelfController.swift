//
//  Created by Alyx Mote on 12/12/22.
//

import Vapor
import Fluent

struct ShelfController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let shelves = routes.grouped("shelves")
        let shelvesWithAuth = shelves.grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            MutedGuard(),
            BannedGuard(),
        ])
        
        shelves.get("fetch-all") { request async throws -> Page<Shelf> in
            let profileId: String? = request.query["profileId"]
            let onlyPublic: Bool? = request.query["onlyPublic"]
            if let id = profileId {
                return try await request.libraryService.fetchShelves(for: id, onlyPublic: onlyPublic ?? false)
            }
            throw Abort(.badRequest, reason: "You must include the profile ID in your request.")
        }
        
        shelvesWithAuth.get("check-all") { request async throws -> [LibraryService.CheckShelf] in
            let workId: String? = request.query["workId"]
            if let id = workId {
                return try await request.libraryService.fetchShelves(check: id)
            }
            throw Abort(.badRequest, reason: "You must include the work ID in your request.")
        }
        
        shelves.get("fetch-one") { request async throws -> Shelf in
            let profileId: String? = request.query["profileId"]
            let shelfId: String? = request.query["shelfId"]
            if let profile = profileId, let shelf = shelfId {
                return try await request.libraryService.fetchShelf(shelf, for: profile)
            }
            throw Abort(.badRequest, reason: "You must include the profile ID and shelf ID in your request.")
        }
        
        shelves.get("fetch-items") { request async throws -> Page<Work> in
            let shelfId: String? = request.query["shelfId"]
            if let id = shelfId {
                return try await request.libraryService.fetchShelfItems(for: id)
            }
            throw Abort(.badRequest, reason: "You must include the shelf ID in your request.")
        }
        
        shelvesWithAuth.post("create") { request async throws -> Shelf in
            try Shelf.ShelfForm.validate(content: request)
            let formInfo = try request.content.decode(Shelf.ShelfForm.self)
            return try await request.libraryService.createShelf(with: formInfo)
        }
        
        shelvesWithAuth.patch("update") { request async throws -> Shelf in
            let shelfId: String? = request.query["shelfId"]
            if let id = shelfId {
                try Shelf.ShelfForm.validate(content: request)
                let formInfo = try request.content.decode(Shelf.ShelfForm.self)
                return try await request.libraryService.updateShelf(id, with: formInfo)
            }
            throw Abort(.badRequest, reason: "You must include the shelf ID in your request.")
        }
        
        shelvesWithAuth.post("add") { request async throws -> LibraryService.CheckShelf in
            let shelfId: String? = request.query["shelfId"]
            let workId: String? = request.query["workId"]
            if let shelf = shelfId, let work = workId {
                return try await request.libraryService.addToShelf(work, to: shelf)
            }
            throw Abort(.badRequest, reason: "You must include the shelf ID and work ID in your request.")
        }
        
        shelvesWithAuth.post("remove") { request async throws -> LibraryService.CheckShelf in
            let shelfId: String? = request.query["shelfId"]
            let workId: String? = request.query["workId"]
            if let shelf = shelfId, let work = workId {
                return try await request.libraryService.removeFromShelf(work, from: shelf)
            }
            throw Abort(.badRequest, reason: "You must include the shelf ID and work ID in your request.")
        }
        
        shelvesWithAuth.delete("delete") { request async throws -> Response in
            let shelfId: String? = request.query["shelfId"]
            if let id = shelfId {
                return try await request.libraryService.deleteShelf(id)
            }
            throw Abort(.badRequest, reason: "You must include the shelf ID in your request.")
        }
    }
}
