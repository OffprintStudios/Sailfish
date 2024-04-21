import Fluent

enum ListingStatus: String, Codable {
    static let schema = "listing_status"
    case `public` = "public"
    case unlisted = "unlisted"
    case `private` = "private"
    case subscription = "subscription"
}

extension ListingStatus {
    struct CreateEnum: AsyncMigration {
        func prepare(on database: any Database) async throws {
            _ = try await database.enum(ListingStatus.schema)
                .case(ListingStatus.public.rawValue)
                .case(ListingStatus.unlisted.rawValue)
                .case(ListingStatus.private.rawValue)
                .case(ListingStatus.subscription.rawValue)
                .create()
        }

        func revert(on database: any Database) async throws {
            try await database.enum(ListingStatus.schema)
                .delete()
        }
    }
}
