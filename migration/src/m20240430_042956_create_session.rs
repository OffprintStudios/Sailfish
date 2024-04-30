use sea_orm_migration::prelude::*;
use super::m20240429_033724_create_account::Account;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager.create_table(
            Table::create()
                .table(Session::Table)
                .if_not_exists()
                .col(ColumnDef::new(Session::Id).uuid().not_null().primary_key())
                .col(ColumnDef::new(Session::AccountId).uuid().not_null())
                .col(ColumnDef::new(Session::CreatedAt).timestamp_with_time_zone().not_null().default(Expr::current_timestamp()))
                .col(ColumnDef::new(Session::Expiration).timestamp_with_time_zone().not_null())
                .foreign_key(
                    ForeignKey::create()
                        .name("fk-session-account_id")
                        .from(Session::Table, Session::AccountId)
                        .to(Account::Table, Account::Id)
                )
                .to_owned()
        ).await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager.drop_table(Table::drop().table(Session::Table).to_owned()).await
    }
}

#[derive(DeriveIden)]
pub enum Session {
    #[sea_orm(iden = "sessions")]
    Table,
    Id,
    AccountId,
    CreatedAt,
    Expiration,
}
