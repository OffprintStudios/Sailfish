use leptos::ServerFnError;
use sqlx::{Pool, Postgres};
use crate::server::db::accounts::{Account, Profile};

pub async fn create_profile(
    account: Account, 
    new_username: String, 
    new_bio: Option<String>, 
    db: &Pool<Postgres>
) -> Result<Profile, ServerFnError> {
    Profile::new(account.id, new_username, new_bio, db)
        .await
        .map_err(|e| ServerFnError::new(e.name))
}