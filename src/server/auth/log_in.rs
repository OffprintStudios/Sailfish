use leptos::ServerFnError;
use surrealdb::Surreal;
use surrealdb::engine::remote::http::Client;
use ammonia::clean;
use crate::server::db::models::accounts::AccountForm;

pub async fn log_in(db: &Surreal<Client>, email: String, password: String) -> Result<(), ServerFnError> {
    let existing_email = clean(&email);
    let existing_password = clean(&password);
    
    

    todo!()    
}