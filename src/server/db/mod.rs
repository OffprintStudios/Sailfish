pub mod entities;

use std::env;
use sea_orm::{DatabaseConnection, Database, ConnectOptions};

use surrealdb::Surreal;
use surrealdb::opt::auth::Root;
use surrealdb::engine::remote::http::{Http, Https, Client};

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

pub async fn connect_to_surreal() -> Surreal<Client> {
    let project_env = env::var("PROJECT_ENV").unwrap_or_else(|_| "development".to_string());
    let surreal_url = env::var("SURREAL_URL").unwrap_or_else(|_| "localhost:8000".to_string());
    let surreal_root_user = env::var("SURREAL_ROOT_USER").unwrap_or_else(|_| "root".to_string());
    let surreal_root_pass = env::var("SURREAL_ROOT_PASS").unwrap_or_else(|_| "root".to_string());
    let surreal_ns = env::var("SURREAL_NS").unwrap_or_else(|_| "sailfish".to_string());
    let surreal_db = env::var("SURREAL_DB").unwrap_or_else(|_| "main".to_string());
    
    if project_env == "development" {
        let db = Surreal::new::<Http>(surreal_url)
            .await
            .expect("Could not establish connection to database!");
        
        db.signin(Root { username: &surreal_root_user, password: &surreal_root_pass })
            .await
            .expect("Could not sign in to root user!");
        
        db.use_ns(surreal_ns).use_db(surreal_db).await.expect("Could not select namespace and/or database!");
        
        return db;
    } else {
        let db = Surreal::new::<Https>(surreal_url)
            .await
            .expect("Could not establish connection to database!");

        db.signin(Root { username: &surreal_root_user, password: &surreal_root_pass })
            .await
            .expect("Could not sign in to root user!");

        db.use_ns(surreal_ns).use_db(surreal_db).await.expect("Could not select namespace and/or database!");

        return db;
    }
}