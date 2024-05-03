use sea_orm_migration::prelude::*;
use crate::m20240502_020254_create_account::Account;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager.create_table(
            Table::create()
                .table(Session::Table)
                .if_not_exists()
                .col(ColumnDef::new(Session::Id).uuid().not_null().primary_key().default(Expr::cust("gen_random_uuid()")))
                .col(ColumnDef::new(Session::AccountId).uuid().not_null())
                .col(ColumnDef::new(Session::IpAddr).string())
                .col(ColumnDef::new(Session::Browser).string())
                .col(ColumnDef::new(Session::Device).string())
                .col(ColumnDef::new(Session::Os).string())
                .col(ColumnDef::new(Session::CreatedAt).timestamp_with_time_zone().not_null().default(Expr::current_timestamp()))
                .col(ColumnDef::new(Session::Expiration).timestamp_with_time_zone().not_null())
                .foreign_key(
                    ForeignKey::create()
                        .name("fk-session-account_id")
                        .from(Session::Table, Session::AccountId)
                        .to(Account::Table, Account::Id)
                        .on_delete(ForeignKeyAction::Cascade)
                )
                .to_owned()
        ).await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager.drop_table(
            Table::drop()
                .table(Session::Table)
                .to_owned()
        ).await
    }
}

#[derive(DeriveIden)]
#[sea_orm(iden = "sessions")]
pub enum Session {
    Table,
    Id,
    AccountId,
    IpAddr,
    Browser,
    Device,
    Os,
    CreatedAt,
    Expiration,
}
