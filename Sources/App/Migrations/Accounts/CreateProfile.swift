//
// Created by Alyx Mote on 7/20/22.
//

import Fluent

struct CreateProfile: AsyncMigration {
    private typealias ProfileKeys = Profile.FieldKeys
    
    func prepare(on database: Database) async throws {
        return try await database.schema(Profile.schema)
            .field(FieldKey.id, .string, .identifier(auto: false))
            .field(ProfileKeys.accountId, .uuid, .required, .references(Account.schema, FieldKey.id, onDelete: .cascade))
            .field(ProfileKeys.username, .string, .required)
            .field(ProfileKeys.avatar, .string, .required)
            .field(ProfileKeys.bannerArt, .string)
            .field(ProfileKeys.info, .dictionary(of: .string), .required)
            .field(ProfileKeys.links, .dictionary(of: .string), .required)
            .field(ProfileKeys.stats, .dictionary(of: .int), .required)
            .field(ProfileKeys.createdAt, .datetime)
            .field(ProfileKeys.updatedAt, .datetime)
            .field(ProfileKeys.deletedAt, .datetime)
            .unique(on: ProfileKeys.username)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema(Profile.schema).delete()
    }
}
