cfg_if::cfg_if! {
    if #[cfg(feature = "ssr")] {
        use axum::extract::FromRef;
        use sea_orm::DatabaseConnection;
        
        #[derive(FromRef, Debug, Clone)]
        pub struct AppState {
            pub database: DatabaseConnection,
        }
    }
}