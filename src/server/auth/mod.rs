mod sign_up;
mod log_in;
mod reset_password;
mod verify_email;
mod create_session;

pub use sign_up::sign_up;
pub use log_in::log_in;
pub use reset_password::reset_password;
pub use verify_email::verify_email;

use axum::{
    async_trait,
    RequestPartsExt,
    extract::FromRequestParts,
    http::{
        StatusCode,
        request::Parts,
    },
};
use axum::extract::FromRef;
use axum_extra::extract::cookie::PrivateCookieJar;
use sea_orm::EntityTrait;
use uuid::Uuid;
use crate::server::db::entities::prelude::{Account, Session};
use crate::server::db::entities::account::Model as AccountModel;
use crate::state::SailfishState;

pub struct AuthSession(AccountModel);

#[async_trait]
impl<S> FromRequestParts<S> for AuthSession where SailfishState: FromRef<S>, S: Send + Sync  {
    type Rejection = (StatusCode, &'static str);

    async fn from_request_parts(parts: &mut Parts, state: &S) -> Result<Self, Self::Rejection> {
        let jar = match PrivateCookieJar::<SailfishState>::from_request_parts(parts, state).await {
            Ok(jar) => jar,
            Err(err) => match err {}
        };

        let session_id = match jar.get("session_token") {
            Some(token) => token.value().to_string(),
            None => return Err((StatusCode::UNAUTHORIZED, "You're not allowed to do that!"))
        };

        let state = match parts.extract_with_state::<SailfishState, _>(state).await {
            Ok(s) => s,
            Err(_) => return Err((StatusCode::INTERNAL_SERVER_ERROR, "Something went wrong!"))
        };

        let existing_session = match Session::find_by_id(Uuid::parse_str(&session_id).expect("Something went wrong!"))
            .one(&state.db)
            .await {
            Ok(val) => val,
            Err(_) => return Err((StatusCode::INTERNAL_SERVER_ERROR, "Something went wrong!"))
        };

        if let Some(session) = existing_session {
            let account = match Account::find_by_id(session.account_id.clone()).one(&state.db).await {
                Ok(acc) => acc,
                Err(_) => return Err((StatusCode::INTERNAL_SERVER_ERROR, "Something went wrong!"))
            };

            match account {
                Some(acc) => Ok(AuthSession(acc)),
                None => Err((StatusCode::UNAUTHORIZED, "You're not allowed to do that!"))
            }
        } else {
            Err((StatusCode::UNAUTHORIZED, "You're not allowed to do that!"))
        }
    }
}