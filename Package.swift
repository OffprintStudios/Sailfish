// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "Sailfish",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
        .package(url: "https://github.com/tmthecoder/Argon2Swift.git", branch: "main"),
        .package(url: "https://github.com/malcommac/UAParserSwift.git", from: "1.0.1"),
        .package(url: "https://github.com/vapor/queues-redis-driver.git", from: "1.0.0"),
        .package(url: "https://github.com/OffprintStudios/NanoID.git", from: "1.0.0"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.4.3"),
        .package(url: "https://github.com/soto-project/soto.git", from: "6.0.0"),
        .package(url: "https://github.com/PinStudios/lexorank-swift", branch: "main"),
        .package(url: "https://github.com/vapor-community/sendgrid.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "Argon2Swift", package: "Argon2Swift"),
                .product(name: "UAParserSwift", package: "UAParserSwift"),
                .product(name: "QueuesRedisDriver", package: "queues-redis-driver"),
                .product(name: "NanoID", package: "NanoID"),
                .product(name: "SwiftSoup", package: "SwiftSoup"),
                .product(name: "SotoS3", package: "soto"),
                .product(name: "LexoRank", package: "lexorank-swift"),
                .product(name: "SendGrid", package: "sendgrid")
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
