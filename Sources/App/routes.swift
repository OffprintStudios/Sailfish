import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        "Sailfish Ready!"
    }

    try app.register(collection: AuthController())
}
