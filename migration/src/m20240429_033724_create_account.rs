use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager.create_table(
            Table::create()
                .table(Account::Table)
                .if_not_exists()
                .col(ColumnDef::new(Account::Id).uuid().not_null().primary_key())
                .col(ColumnDef::new(Account::Email).string().not_null().unique_key())
                .col(ColumnDef::new(Account::Password).string().not_null())
                .col(ColumnDef::new(Account::Roles).array(ColumnType::String(Some(32))).not_null())
                .col(ColumnDef::new(Account::TermsAgree).boolean().not_null().default(true))
                .col(ColumnDef::new(Account::EmailConfirmed).boolean().not_null().default(false))
                .col(ColumnDef::new(Account::CreatedAt).timestamp_with_time_zone().not_null().default(Expr::current_timestamp()))
                .col(ColumnDef::new(Account::UpdatedAt).timestamp_with_time_zone().not_null().default(Expr::current_timestamp()))
                .to_owned()
        ).await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager.drop_table(Table::drop().table(Account::Table).to_owned()).await
    }
}

#[derive(DeriveIden)]
pub enum Account {
    #[sea_orm(iden = "accounts")]
    Table,
    Id,
    Email,
    Password,
    Roles,
    TermsAgree,
    EmailConfirmed,
    CreatedAt,
    UpdatedAt
}
