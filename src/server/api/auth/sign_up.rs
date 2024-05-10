use leptos::ServerFnError;
use sqlx::{Pool, Postgres};
use crate::server::db::accounts::Account;

/// Creates a new account if an account with the provided email does not already exist. Returns nothing.
pub async fn sign_up(email: String, password: String, db: &Pool<Postgres>) -> Result<(), ServerFnError> {
    if Account::fetch_by_email(email.clone(), db).await?.is_some() {
        Err(ServerFnError::new("An account with this email already exists!"))
    } else if Account::new(email, password, db).await? > 0 {
        Ok(())
    } else {
        Err(ServerFnError::new("Something went wrong trying to create your account!"))
    }
}