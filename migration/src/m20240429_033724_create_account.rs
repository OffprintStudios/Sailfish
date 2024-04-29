use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager.create_table(
            Table::create()
                .table(Accounts::Table)
                .if_not_exists()
                .col(ColumnDef::new(Accounts::Id).uuid().not_null().primary_key())
                .col(ColumnDef::new(Accounts::Email).string().not_null().unique_key())
                .col(ColumnDef::new(Accounts::Password).string().not_null())
                .col(ColumnDef::new(Accounts::Roles).array(ColumnType::String(Some(32))).not_null())
                .col(ColumnDef::new(Accounts::TermsAgree).boolean().not_null().default(true))
                .col(ColumnDef::new(Accounts::EmailConfirmed).boolean().not_null().default(false))
                .col(ColumnDef::new(Accounts::CreatedAt).timestamp_with_time_zone().not_null().default(Expr::current_timestamp()))
                .col(ColumnDef::new(Accounts::UpdatedAt).timestamp_with_time_zone().not_null().default(Expr::current_timestamp()))
                .to_owned()
        ).await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager.drop_table(Table::drop().table(Accounts::Table).to_owned()).await
    }
}

#[derive(DeriveIden)]
enum Accounts {
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
