cfg_if::cfg_if! {
    if #[cfg(feature = "ssr")] {
        use axum::extract::FromRef;
        
        #[derive(FromRef, Clone)]
        pub struct AppState {
            pub database: Option<String>,
        }
    }
}