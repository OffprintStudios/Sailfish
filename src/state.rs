use axum::async_trait;
use axum::extract::{FromRef, FromRequestParts};
use http::request::Parts;
use leptos::prelude::LeptosOptions;
use sqlx::{Pool, Postgres};

#[derive(Clone, FromRef)]
pub struct AppState {
    pub db: Pool<Postgres>,
    pub leptos_options: LeptosOptions,
}

#[async_trait]
impl<S> FromRequestParts<S> for AppState where Self: FromRef<S>, S: Send + Sync {
    type Rejection = ();

    async fn from_request_parts(_: &mut Parts, state: &S) -> Result<Self, Self::Rejection> {
        Ok(Self::from_ref(state))
    }
}