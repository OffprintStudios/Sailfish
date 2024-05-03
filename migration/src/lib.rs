pub use sea_orm_migration::prelude::*;

mod m20240502_020254_create_account;
mod m20240502_021711_create_session;

pub struct Migrator;

#[async_trait::async_trait]
impl MigratorTrait for Migrator {
    fn migrations() -> Vec<Box<dyn MigrationTrait>> {
        vec![
            Box::new(m20240502_020254_create_account::Migration),
            Box::new(m20240502_021711_create_session::Migration),
        ]
    }
}
