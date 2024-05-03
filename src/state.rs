use std::sync::Arc;
use leptos::LeptosOptions;
use axum::extract::FromRef;
use crate::server::db::Pool;

#[derive(FromRef, Clone)]
pub struct SailfishState {
    pub db: Arc<Pool>,
    pub leptos_options: LeptosOptions,
}