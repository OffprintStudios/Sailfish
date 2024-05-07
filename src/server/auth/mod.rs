mod sign_up;
mod log_in;
mod reset_password;
mod verify_email;

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
use uuid::Uuid;
use crate::server::db::models::accounts::{Account, Session};
use crate::state::SailfishState;

pub struct AuthSession(Account);

#[async_trait]
impl<S> FromRequestParts<S> for AuthSession where SailfishState: FromRef<S>, S: Send + Sync  {
    type Rejection = (StatusCode, &'static str);

    async fn from_request_parts(parts: &mut Parts, state: &S) -> Result<Self, Self::Rejection> {
        let jar = match PrivateCookieJar::<SailfishState>::from_request_parts(parts, state).await {
            Ok(jar) => jar,
            Err(err) => match err {}
        };

        let session_token = match jar.get("session_token") {
            Some(token) => token.clone(),
            None => return Err((StatusCode::UNAUTHORIZED, "You're not allowed to do that!"))
        };
        
        let session_id = match Uuid::parse_str(session_token.value()) {
            Ok(id) => id,
            Err(_) => return Err((StatusCode::UNAUTHORIZED, "You're not allowed to do that!"))
        };

        let state = match parts.extract_with_state::<SailfishState, _>(state).await {
            Ok(s) => s,
            Err(_) => return Err((StatusCode::INTERNAL_SERVER_ERROR, "Something went wrong!"))
        };
        
        let account_id = match Session::verify_session(&state.db, session_id).await {
            Ok(a) => a,
            Err(_) => return Err((StatusCode::UNAUTHORIZED, "You're not allowed to do that!"))
        };
        
        match Account::fetch_by_id(account_id, &state.db).await {
            Ok(acc) => Ok(AuthSession(acc)),
            Err(_) => Err((StatusCode::UNAUTHORIZED, "You're not allowed to do that!"))
        }
    }
}