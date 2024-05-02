pub mod entities;
pub mod util;

use std::env;
use sea_orm::{DatabaseConnection, Database, ConnectOptions};

pub async fn connect_to_db() -> DatabaseConnection {
    let database_url = env::var("DATABASE_URL")
        .expect("Could not find DATABASE_URL! Are you sure the environment is configured correctly?");
    
    let mut opt = ConnectOptions::new(database_url);
    opt.max_connections(100)
        .min_connections(5);
    
    match Database::connect(opt).await {
        Ok(conn) => conn,
        Err(_) => panic!("Something went wrong attempting to connect to the database!")
    }
}