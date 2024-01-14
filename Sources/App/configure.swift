import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor
import JWT
import SotoS3
import SendGrid
import Redis

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.logger.notice("Starting Sailfish API...")
    app.routes.defaultMaxBodySize = "3mb"
    
    // Setting port
    let port = Int(Environment.get("PORT") ?? "8080")!
    app.http.server.configuration.port = port
    
    // Setting up JWT signing
    app.logger.notice("Assigning secret key...")
    app.jwt.signers.use(.hs256(key: Environment.get("JWT_SECRET") ?? "aSecret"))
    
    // Setting up database connection
    app.logger.notice("Setting up database connection...")
    if let databaseUrl = Environment.get("DATABASE_URL") {
        var tlsConfig: TLSConfiguration = .makeClientConfiguration()
        tlsConfig.certificateVerification = .none
        let nioSSLContext = try NIOSSLContext(configuration: tlsConfig)
        
        var postgresConfig = try SQLPostgresConfiguration(url: databaseUrl)
        postgresConfig.coreConfiguration.tls = .prefer(nioSSLContext)
        
        app.databases.use(.postgres(configuration: postgresConfig, connectionPoolTimeout: .seconds(30)), as: .psql)
    } else {
        try app.databases.use(.postgres(url: "postgresql://postgres@localhost/sailfish_neo", connectionPoolTimeout: .seconds(30)), as: .psql)
    }
    
    // Adding migrations
    app.logger.notice("Adding migrations...")
    app.migrations.add([
        Account.Create(),
        Profile.Create(),
        Follower.Create(),
        ProfileView.Create(),
        ContentRating.CreateEnum(),
        Blog.Create(),
        FavoriteBlog.Create(),
        BlogVote.Create(),
        NewsPost.Create(),
        PublishedBlog.Create(),
        BlogView.Create(),
        PostView.Create(),
    ])
    
    try await app.autoMigrate()
    
    // Adding model middleware
    app.logger.notice("Adding model middleware...")
    app.databases.middleware.use(Account.Middleware(), on: .psql)
    app.databases.middleware.use(Profile.Middleware(), on: .psql)

    // Registering Leaf templates
    app.logger.notice("Registering Leaf templates...")
    app.views.use(.leaf)

    // Configuring Redis
    app.logger.notice("Configuring Redis...")
    guard let redisUrl = Environment.get("REDIS_URL") else {
        fatalError("REDIS_URL not configured in your environment!")
    }
    app.redis.configuration = try RedisConfiguration(url: redisUrl)

    // Adding Jobs
    app.logger.notice("Adding jobs...")
    // TODO: add queue jobs
    
    // CORS configuration
    app.logger.notice("Assigning CORS configuration...")
    let corsConfig = CORSMiddleware.Configuration(
        allowedOrigin: .any([
            "http://localhost:3000",
            "http://127.0.0.1:3000",
            "http://localhost:4200",
            "http://127.0.0.1:4200",
            "https://offprint.net",
            "https://www.offprint.net",
            "https://staging.offprint.net",
            "https://offprint.cafe"
        ]),
        allowedMethods: [.GET, .POST, .PUT, .PATCH, .DELETE, .OPTIONS],
        allowedHeaders: [
            .accept,
            .authorization,
            .contentType,
            .origin,
            .xRequestedWith,
            .userAgent,
            .accessControlAllowOrigin
        ],
        allowCredentials: true
    )
    let cors = CORSMiddleware(configuration: corsConfig)
    app.middleware.use(cors, at: .beginning)
    
    // Configuring AWS
    app.logger.notice("Configuring AWS...")
    app.aws.client = AWSClient(
        credentialProvider: .static(
            accessKeyId: Environment.get("DIGITALOCEAN_SPACES_ACCESS_KEY") ?? "nil",
            secretAccessKey: Environment.get("DIGITALOCEAN_SPACES_SECRET") ?? "nil"
        ),
        httpClientProvider: .createNew
    )
    
    // Configuring SendGrid
    app.logger.notice("Configuring SendGrid...")
    app.sendgrid.initialize()

    // Acknowledging routes
    app.logger.notice("Acknowledging routes...")
    try routes(app)
    
    // Print all routes to console
    for route in app.routes.all {
        let path = route.path.map { String($0.description) }
        app.logger.info("Route acknowledged: /\(path.joined(separator: "/")) [\(route.method.rawValue)]")
    }
    
    // Restarting any available queues
    app.logger.notice("Restarting any available queues...")
    // TODO: restart queues
}
