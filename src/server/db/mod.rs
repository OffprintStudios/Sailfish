pub mod models;

use std::env;
use sqlx::{Pool, Postgres};
use sqlx::postgres::PgPoolOptions;

pub async fn connect_to_db() -> Pool<Postgres> {
    let database_url = env::var("DATABASE_URL")
        .expect("Could not find DATABASE_URL? Are you sure the environment is configured correctly?");
    
    PgPoolOptions::new()
        .max_connections(8)
        .connect(&database_url)
        .await
        .expect("Could not establish connection to database!")
}

