use axum::extract::FromRef;
use sea_orm::DatabaseConnection;
use leptos::LeptosOptions;

#[derive(FromRef, Debug, Clone)]
pub struct SailfishState {
    pub db: DatabaseConnection,
    pub leptos_options: LeptosOptions,
}