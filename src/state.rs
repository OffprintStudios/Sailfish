use std::convert::Into;
use axum::async_trait;
use axum::extract::{FromRef, FromRequestParts};
use axum_extra::extract::cookie::Key;
use http::request::Parts;
use leptos::LeptosOptions;
use surrealdb::engine::remote::http::Client;
use surrealdb::Surreal;

#[derive(FromRef, Debug, Clone)]
pub struct SailfishState {
    pub db: Surreal<Client>,
    pub key: Key,
    pub leptos_options: LeptosOptions,
}

impl Into<Key> for SailfishState {
    fn into(self) -> Key {
        self.key
    }
}

#[async_trait]
impl<S> FromRequestParts<S> for SailfishState where Self: FromRef<S>, S: Send+ Sync {
    type Rejection = ();

    async fn from_request_parts(_parts: &mut Parts, state: &S) -> Result<Self, Self::Rejection> {
        Ok(Self::from_ref(state))
    }
}