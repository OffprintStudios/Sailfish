// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "Sailfish",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.99.3"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.11.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "4.3.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        // Vapor JWT package
        .package(url: "https://github.com/vapor/jwt.git", from: "4.2.2"),
        // Argon2 password hasher
        .package(url: "https://github.com/tmthecoder/Argon2Swift.git", branch: "main"),
        // User-Agent Parser
        .package(url: "https://github.com/malcommac/UAParserSwift.git", from: "1.2.1"),
        // NanoID generation
        .package(url: "https://github.com/OffprintStudios/NanoID.git", from: "1.0.0"),
        // SwiftSoup HTML sanitization
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.7.2"),
        // Soto AWS library
        .package(url: "https://github.com/soto-project/soto.git", from: "7.0.0"),
        // SMTP support
        .package(url: "https://github.com/mikroservices/smtp.git", from: "3.0.5"),
        // Job queues
        .package(url: "https://github.com/vapor/queues-redis-driver.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "Argon2Swift", package: "Argon2Swift"),
                .product(name: "UAParserSwift", package: "UAParserSwift"),
                .product(name: "NanoID", package: "NanoID"),
                .product(name: "SwiftSoup", package: "SwiftSoup"),
                .product(name: "SotoS3", package: "soto"),
                .product(name: "Smtp", package: "smtp"),
                .product(name: "QueuesRedisDriver", package: "queues-redis-driver")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "XCTVapor", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency"),
] }
