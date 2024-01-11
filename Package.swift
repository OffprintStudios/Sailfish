// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Sailfish",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.83.6"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "4.2.4"),
        // Vapor JWT package
        .package(url: "https://github.com/vapor/jwt.git", from: "4.2.2"),
        // Argon2 password hasher
        .package(url: "https://github.com/tmthecoder/Argon2Swift.git", branch: "main"),
        // User-Agent Parser
        .package(url: "https://github.com/malcommac/UAParserSwift.git", from: "1.2.1"),
        // NanoID generation
        .package(url: "https://github.com/OffprintStudios/NanoID.git", from: "1.0.0"),
        // SwiftSoup HTML sanitization
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.1"),
        // Soto AWS library
        .package(url: "https://github.com/soto-project/soto.git", from: "6.8.0"),
        // Vapor SendGrid package
        .package(url: "https://github.com/vapor-community/sendgrid.git", from: "4.0.0"),
        // Vapor OAuth
        .package(url: "https://github.com/brokenhandsio/vapor-oauth", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "Argon2Swift", package: "Argon2Swift"),
                .product(name: "UAParserSwift", package: "UAParserSwift"),
                .product(name: "NanoID", package: "NanoID"),
                .product(name: "SwiftSoup", package: "SwiftSoup"),
                .product(name: "SotoS3", package: "soto"),
                .product(name: "SendGrid", package: "sendgrid"),
                .product(name: "OAuth", package: "vapor-oauth")
            ]
        ),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),

            // Workaround for https://github.com/apple/swift-package-manager/issues/6940
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "Fluent"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            .product(name: "Leaf", package: "leaf"),
        ])
    ]
)
