import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        "Sailfish Ready!"
    }

    try app.register(collection: AuthController())
    try app.register(collection: AccountController())
    try app.register(collection: SessionController())
    try app.register(collection: ProfileController())
    try app.register(collection: BlogController())
    try app.register(collection: NewsController())
}
