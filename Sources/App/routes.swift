import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Sailfish API ready!"])
    }

    try app.register(collection: AuthController())
    try app.register(collection: AccountController())
    try app.register(collection: ProfileController())
    try app.register(collection: BlogController())
}
