pub mod models;
pub mod schema;

use std::env;
use diesel_async::AsyncPgConnection;
use diesel_async::pooled_connection::AsyncDieselConnectionManager;

pub type Pool = bb8::Pool<AsyncDieselConnectionManager<AsyncPgConnection>>;

pub async fn connect_to_db() -> Pool {
    let database_url = env::var("DATABASE_URL")
        .expect("Could not find DATABASE_URL! Are you sure the environment is configured correctly?");
    
    let config = AsyncDieselConnectionManager::<AsyncPgConnection>::new(database_url);
    
    let pool = Pool::builder().build(config).await
        .expect("Failed to initialize database pool!");
    
    return pool;
}

/*pub async fn connect_to_db() -> DatabaseConnection {
    let database_url = env::var("DATABASE_URL")
        .expect("Could not find DATABASE_URL! Are you sure the environment is configured correctly?");
    
    let mut opt = ConnectOptions::new(database_url);
    opt.max_connections(100)
        .min_connections(5);
    
    match Database::connect(opt).await {
        Ok(conn) => conn,
        Err(_) => panic!("Something went wrong attempting to connect to the database!")
    }
}*/