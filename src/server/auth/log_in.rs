use chrono::{Duration, Utc};
use leptos::ServerFnError;
use sqlx::{Pool, Postgres};
use uuid::Uuid;
use crate::server::db::models::accounts::{Account, Session};

pub async fn log_in(db: &Pool<Postgres>, email: String, password: String) -> Result<Uuid, ServerFnError> {
    let account = match Account::verify_credentials(db, email, password).await {
        Ok(res) => res,
        Err(e) => return Err(ServerFnError::new(&e.name))
    };

    if !account.email_confirmed {
        return Err(ServerFnError::new("Your email must be confirmed before logging in."));
    }
    
    match Session::start(db, account.id.clone(), (Utc::now() + Duration::days(30))).await {
        Ok(id) => Ok(id),
        Err(e) => Err(ServerFnError::new(&e.name))
    }
}