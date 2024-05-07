use leptos::ServerFnError;
use sqlx::{Pool, Postgres};
use crate::server::db::models::accounts::Account;

pub async fn sign_up(db: &Pool<Postgres>, email: String, password: String) -> Result<(), ServerFnError> {
    let result = match Account::new(db, email, password).await {
        Ok(res) => res,
        Err(e) => return Err(ServerFnError::new(&e.name))
    };
    
    if result > 0 {
        Ok(())
    } else {
        Err(ServerFnError::new("Could not create your account!"))
    }
}