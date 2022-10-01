import Fluent
import FluentPostgresDriver
import Vapor
import QueuesRedisDriver
import JWT

// configures your application
public func configure(_ app: Application) throws {
    app.logger.notice("Starting Sailfish API...")

    // Setting port
    let port = Int(Environment.get("PORT") ?? "8080")!
    app.http.server.configuration.port = port

    // Setting up JWT signing
    app.logger.notice("Assigning secret key...")
    app.jwt.signers.use(.hs256(key: Environment.get("JWT_SECRET") ?? "aSecret"))

    // Setting up database connection
    app.logger.notice("Setting up database connection...")
    let databaseUrl = Environment.get("DATABASE_URL") ?? "postgresql://postgres@localhost/sailfish"
    try app.databases.use(.postgres(url: databaseUrl), as: .psql)

    // Adding migrations
    app.logger.notice("Adding migrations...")
    app.migrations.add(CreateAccount())
    app.migrations.add(CreateProfile())
    app.migrations.add(CreateSession())
    app.migrations.add(CreateInviteCode())
    app.migrations.add(CreateBlog())
    app.migrations.add(AddFieldEditedOn())

    Task {
        try await app.autoMigrate()
    }

    // Setting up queues
    // app.logger.notice("Setting up queues...")
    // try app.queues.use(.redis(url: Environment.get("REDIS_URL") ?? "redis://localhost:6379"))

    // CORS configuration
    app.logger.notice("Assigning CORS configuration...")
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: CORSMiddleware.AllowOriginSetting.any([
            "http://localhost:3000",
            "http://127.0.0.1:3000",
            "https://offprint.net",
            "https://www.offprint.net",
        ]),
        allowedMethods: [.GET, .POST, .PUT, .PATCH, .OPTIONS],
        allowedHeaders: [
            .accept,
            .authorization,
            .contentType,
            .origin,
            .xRequestedWith,
            .userAgent,
            .accessControlAllowOrigin
        ]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    app.middleware.use(cors, at: .beginning)

    // Register routes
    app.logger.notice("Acknowledging routes...")
    try routes(app)

    // Show all routes
    for route in app.routes.all {
        let pathArr = route.path.map { item in
            String(item.description)
        }
        app.logger.info("Route acknowledged: /\(pathArr.joined(separator: "/")) (\(route.method.rawValue))")
    }

    // Starting the queue
//    app.logger.notice("Restarting any available queues...")
//    try app.queues.startInProcessJobs(on: .default)
}
