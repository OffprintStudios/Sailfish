import Fluent
import FluentPostgresDriver
import Vapor
import QueuesRedisDriver
import JWT
import SotoS3

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
    app.migrations.add(CreateBlog())
    app.migrations.add(AddFieldEditedOn())
    app.migrations.add(CreateFavoriteBlog())
    app.migrations.add(CreateAccountReport())
    app.migrations.add(CreateAccountNote())
    app.migrations.add(CreateAccountWarning())
    app.migrations.add(CreateAccountBan())
    app.migrations.add(CreateAccountLog())
    app.migrations.add(CreateAccountMute())
    app.migrations.add(CreateThread())
    app.migrations.add(CreateComment())
    app.migrations.add(CreateThreadBlacklist())
    app.migrations.add(AddCommentSpoilerField())
    app.migrations.add(CreateCommentHistory())
    app.migrations.add(CreateNotification())
    app.migrations.add(CreateFollower())
    app.migrations.add(CreateReply())
    app.migrations.add(CreateTag())
    app.migrations.add(CreateWork())
    app.migrations.add(CreateVolume())
    app.migrations.add(CreateSection())
    app.migrations.add(CreateWorkTag())
    app.migrations.add(AddCommentSectionField())

    try app.autoMigrate().wait()

    // Setting up queues
    app.logger.notice("Setting up queues...")
    let redisConfig = try RedisConfiguration(
        url: Environment.get("REDIS_URL") ?? "redis://127.0.0.1:6379",
        pool: RedisConfiguration.PoolOptions(connectionRetryTimeout: .minutes(1))
    )
    app.queues.use(.redis(redisConfig))

    // Adding Jobs
    app.logger.notice("Adding jobs...")
    app.queues.add(AddNotificationJob())

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

    // Configuring AWS
    app.aws.client = AWSClient(
        credentialProvider: .static(
            accessKeyId: Environment.get("DIGITALOCEAN_SPACES_ACCESS_KEY") ?? "nil",
            secretAccessKey: Environment.get("DIGITALOCEAN_SPACES_SECRET") ?? "nil"
        ),
        httpClientProvider: .createNew
    )

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
    app.logger.notice("Restarting any available queues...")
    try app.queues.startInProcessJobs(on: .default)
}
