use axum::async_trait;
use axum::extract::{FromRef, FromRequestParts};
use http::request::Parts;
use leptos::LeptosOptions;
use sqlx::{Pool, Postgres};

#[derive(FromRef, Debug, Clone)]
pub struct SailfishState {
    pub db: Pool<Postgres>,
    pub leptos_options: LeptosOptions,
}

#[async_trait]
impl<S> FromRequestParts<S> for SailfishState
where
    Self: FromRef<S>,
    S: Send + Sync
{
    type Rejection = ();

    async fn from_request_parts(_parts: &mut Parts, state: &S) -> Result<Self, Self::Rejection> {
        Ok(Self::from_ref(state))
    }
}