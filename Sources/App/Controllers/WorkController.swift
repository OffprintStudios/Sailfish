import Vapor
import Fluent

struct WorkController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let works = routes.grouped("works")


    }

    @Sendable
    func getAll(request: Request) async throws {
        
    }
} 