pub use sea_orm_migration::prelude::*;

mod m20240429_033724_create_account;

pub struct Migrator;

#[async_trait::async_trait]
impl MigratorTrait for Migrator {
    fn migrations() -> Vec<Box<dyn MigrationTrait>> {
        vec![
            Box::new(m20240429_033724_create_account::Migration),
        ]
    }
}
