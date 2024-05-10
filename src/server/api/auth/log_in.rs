use chrono::{Duration, Utc};
use leptos::ServerFnError;
use sqlx::{Pool, Postgres};
use uuid::Uuid;
use crate::server::db::accounts::{Account, Session};
use crate::server::util::constants::{MAX_SESSION_DURATION, MIN_SESSION_DURATION};

/// Logs a user in and creates a session for them, returning the session's ID if successful.
pub async fn log_in(email: String, password: String, persist_session: bool, db: &Pool<Postgres>) -> Result<Uuid, ServerFnError> {
    let account = Account::verify_credentials(email, password, db).await?;

    // if !account.email_confirmed {
    //     return Err(ServerFnError::new("You cannot log in until your email is confirmed."));
    // }
    
    let token_exp = match persist_session {
        true => Utc::now() + Duration::seconds(MAX_SESSION_DURATION),
        false => Utc::now() + Duration::seconds(MIN_SESSION_DURATION)
    };

    let session_id = Session::start(account.id.clone(), token_exp, db).await?;

    Ok(session_id)
}