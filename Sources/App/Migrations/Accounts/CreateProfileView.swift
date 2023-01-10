//
//  Created by Alyx Mote on 12/26/22.
//

import Fluent
import SQLKit

struct CreateProfileView: AsyncMigration {
    private typealias AccountKeys = Account.FieldKeys
    private typealias ProfileKeys = Profile.FieldKeys
    private typealias ProfileViewKeys = ProfileView.FieldKeys
    
    func prepare(on database: Database) async throws {
        let sqlDb = database as! SQLDatabase
        
        let select = sqlDb
            .select()
            .column(SQLColumn(FieldKey.id.description, table: Profile.schema))
            .column(SQLColumn(ProfileKeys.username.description, table: Profile.schema))
            .column(SQLColumn(ProfileKeys.avatar.description, table: Profile.schema))
            .column(SQLColumn(ProfileKeys.bannerArt.description, table: Profile.schema))
            .column(SQLColumn(ProfileKeys.info.description, table: Profile.schema))
            .column(SQLColumn(ProfileKeys.links.description, table: Profile.schema))
            .column(SQLColumn(ProfileKeys.stats.description, table: Profile.schema))
            .column(SQLColumn(AccountKeys.roles.description, table: Account.schema), as: ProfileViewKeys.roles.description)
            .column(SQLColumn(ProfileKeys.createdAt.description, table: Profile.schema))
            .column(SQLColumn(ProfileKeys.updatedAt.description, table: Profile.schema))
            .from(Profile.schema)
            .join(
                SQLIdentifier(Account.schema),
                method: SQLJoinMethod.inner,
                on: SQLBinaryExpression(
                    left: SQLColumn(ProfileKeys.accountId.description, table: Profile.schema),
                    op: SQLBinaryOperator.equal,
                    right: SQLColumn(FieldKey.id.description, table: Account.schema)
                )
            )
        
        try await sqlDb.raw("""
            CREATE VIEW "\(raw: ProfileView.schema)" AS \(select.query)
        """).run()
    }
    
    func revert(on database: Database) async throws {
        let sqlDb = database as! SQLDatabase
        try await sqlDb.raw("DROP VIEW \(raw: ProfileView.schema)").run()
    }
}
