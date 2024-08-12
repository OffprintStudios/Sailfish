import Fluent

enum ContentRating: String, Codable {
    static let schema = "content_rating"
    case everyone
    case teen
    case mature
    case explicit
}

extension ContentRating {
    struct CreateEnum: AsyncMigration {
        func prepare(on database: any Database) async throws {
            _ = try await database.enum(ContentRating.schema)
                .case(ContentRating.everyone.rawValue)
                .case(ContentRating.teen.rawValue)
                .case(ContentRating.mature.rawValue)
                .case(ContentRating.explicit.rawValue)
                .create()
        }

        func revert(on database: any Database) async throws {
            try await database.enum(ContentRating.schema).delete()
        }
    }
}