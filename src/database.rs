use sqlx::postgres::PgPoolOptions;
use sqlx::{Pool, Postgres};
use std::env;

/// Establishes a connection to the database, returning a connection pool on later use.
pub async fn connect_to_db() -> Pool<Postgres> {
    let database_url = env::var("DATABASE_URL").expect(
        "Could not find DATABASE_URL! Are you sure the environment is configured correctly?"
    );

    PgPoolOptions::new()
        .min_connections(1)
        .max_connections(5)
        .connect(&database_url)
        .await
        .expect("Could not connect to database! Check to see if all relevant parts are in order.")
}