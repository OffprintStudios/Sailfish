import Vapor
import Fluent

struct BlogController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let blogs = routes
            .grouped("blogs")
            .grouped(
                SessionToken.authenticator(),
                SessionToken.guardMiddleware(),
                IdentityGuard(needs: [.user], checkProfile: true)
            )
        let blogsWithId = blogs.grouped(":id")
        
        blogs.get("all") { request async throws -> Page<BlogView> in 
            let profile = request.user!.profile!

            return try await BlogView.query(on: request.db)
                .filter(\.$author.$id == profile.requireID())
                .sort(\.$createdAt, .descending)
                .paginate(for: request)
        }

        // CREATE
        blogs.post("create") { request async throws -> HTTPResponseStatus in 
            let profile = request.user!.profile!
            let formInfo = try request.content.decode(Blog.FormInfo.self)
            let newBlog = Blog(with: formInfo)
            try await profile.$blogs.create(newBlog, on: request.db)
            return .created
        }

        // READ
        blogsWithId.get() { request async throws -> BlogView in 
            let profile = request.user!.profile!
            let id = request.parameters.get("id")!

            guard let blog = try await BlogView.query(on: request.db)
                .filter(\.$id == id)
                .filter(\.$author.$id == profile.requireID())
                .first() else {
                    throw Abort(.notFound, reason: "The blog you're trying to find does not exist.")
                }

            return blog
        }

        // UPDATE
        blogsWithId.patch("update") { request async throws -> HTTPResponseStatus in 
            let profile = request.user!.profile!
            let id = request.parameters.get("id")!
            let formInfo = try request.content.decode(Blog.FormInfo.self)

            guard let blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The blog you're trying to update does not exist.")
            }

            blog.title = formInfo.title
            blog.body = formInfo.body
            blog.rating = formInfo.rating

            try await blog.save(on: request.db)

            return .accepted
        }

        // DELETE
        blogsWithId.delete("delete") { request async throws -> HTTPResponseStatus in 
            let profile = request.user!.profile!
            let id = request.parameters.get("id")!

            guard let blog = try await profile.$blogs.query(on: request.db).filter(\.$id == id).first() else {
                throw Abort(.notFound, reason: "The blog you're trying to update does not exist.")
            }

            try await blog.delete(on: request.db)

            return .ok
        }
    }
}