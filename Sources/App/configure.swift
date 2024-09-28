import NIOSSL
import Fluent
import FluentPostgresDriver
import QueuesRedisDriver
import Leaf
import Vapor
import JWT
import SotoS3
import Smtp
import Redis

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.logger.notice("Starting Sailfish API ...")
    app.routes.defaultMaxBodySize = "3mb"
    
    // Setting port
    app.http.server.configuration.port = Int(Environment.get("PORT") ?? "8080")!
    
    // Setting up JWT signing
    app.logger.notice("Assigning secret key ...")
    app.jwt.signers.use(.hs256(key: Environment.get("JWT_SECRET") ?? "aSecret"))
    
    // Setting up database connection
    app.logger.notice("Connecting to database ...")
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "postgres",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "sailfish",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    
    // Running migrations
    app.logger.notice("Running migrations ...")
    app.migrations.add([
        Account.Create(),
        Profile.Create(),
        Session.Create(),
        PasswordReset.Create(),
        ConfirmEmail.Create(),
        ContentRating.CreateEnum(),
        Work.Create(),
    ])
    try await app.autoMigrate()
    
    // Adding model middleware
    app.logger.notice("Initializing model middleware ...")
    app.databases.middleware.use(Account.Middleware(), on: .psql)
    app.databases.middleware.use(Profile.Middleware(), on: .psql)
    app.databases.middleware.use(Work.Middleware(), on: .psql)
    
    // Registering Leaf templates
    app.logger.notice("Registering Leaf templates ...")
    app.views.use(.leaf)

    // Initializing job queues and Redis
    app.logger.notice("Initializing job queues and Redis ...")
    let redisConfig = try RedisConfiguration(
        url: Environment.get("REDIS_URL") ?? "redis://127.0.0.1:6379",
        pool: RedisConfiguration.PoolOptions(connectionRetryTimeout: .minutes(1))
    )
    app.redis.configuration = redisConfig
    app.queues.use(.redis(redisConfig))

    // Registering jobs
    app.logger.notice("Registering jobs ...")
    app.queues.add(EmailJob())
    
    // CORS configuration
    app.logger.notice("Initializing CORS configuration ...")
    let corsConfig = CORSMiddleware.Configuration(
        allowedOrigin: .any([
            "http://localhost:3000",
            "http://127.0.0.1:3000",
            "https://offprint.cafe",
            "https://www.offprint.cafe",
            "https://staging.offprint.cafe",
            "https://dev.offprint.cafe",
        ]),
        allowedMethods: [.GET, .POST, .PUT, .PATCH, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin],
        allowCredentials: true
    )
    let cors = CORSMiddleware(configuration: corsConfig)
    app.middleware.use(cors, at: .beginning)
    
    // Configuring AWS
    app.logger.notice("Configuring storage buckets ...")
    app.aws.client = AWSClient(
        credentialProvider: .static(
            accessKeyId: Environment.get("BUCKET_ACCESS_KEY") ?? "nil",
            secretAccessKey: Environment.get("BUCKET_SECRET") ?? "nil"
        ),
        httpClient: HTTPClient.shared
    )

    // Configure SMTP connection
    app.logger.notice("Configuring SMTP connection ...")
    app.smtp.configuration.hostname = Environment.get("SMTP_HOST") ?? ""
    app.smtp.configuration.port = Int(Environment.get("SMTP_PORT") ?? "465")!
    app.smtp.configuration.signInMethod = .credentials(
        username: Environment.get("SMTP_USERNAME") ?? "",
        password: Environment.get("SMTP_PASSWORD") ?? ""
    )
    app.smtp.configuration.secure = .ssl

    // Register routes
    app.logger.notice("Registering routes ...")
    try routes(app)

    // Print all routes to console
    for route in app.routes.all {
        let path = route.path.map { String($0.description) }
        app.logger.info("Route registered: /\(path.joined(separator: "/")) [\(route.method.rawValue)]")
    }

    // Restarting any available jobs
    app.logger.notice("Restarting any pending jobs ...")
    try app.queues.startInProcessJobs(on: .default)
}
