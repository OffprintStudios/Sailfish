mod log_in;
mod sign_up;
mod create_profile;

pub use sign_up::sign_up;
pub use log_in::log_in;
pub use create_profile::create_profile;

use uuid::Uuid;
use leptos::ServerFnError;
use sqlx::{Pool, Postgres};
use tower_cookies::PrivateCookies;
use crate::server::db::accounts::{Account, Session, Profile};

pub async fn authorize<'a>(cookies: PrivateCookies<'a>, db: &Pool<Postgres>) -> Result<Account, ServerFnError> {
    leptos::logging::log!("Entering Authorize...");

    let unauthorized_msg = "You're not allowed to do that.";

    let session_token = cookies.get("session_token")
        .ok_or(ServerFnError::new(unauthorized_msg))?;

    let session_id = Uuid::parse_str(session_token.value())
        .map_err(|_| ServerFnError::new(unauthorized_msg))?;
    
    let account_id = Session::verify_session(session_id, db).await?;
    
    if let Some(account) = Account::fetch_by_id(account_id, db).await? {
        Ok(account)
    } else {
        Err(ServerFnError::new(unauthorized_msg))
    }
}

pub async fn authorize_with_profile<'a>(cookies: PrivateCookies<'a>, profile_id: String, db: &Pool<Postgres>) -> Result<(Account, Profile), ServerFnError> {
    leptos::logging::log!("Authorizing profile...");

    let account = authorize(cookies, db).await?;
    let profile = Profile::check_owned(profile_id, account.id, db).await?;
    
    Ok((account, profile))
}