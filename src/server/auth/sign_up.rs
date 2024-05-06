use leptos::ServerFnError;
use argon2::{Argon2, PasswordHasher};
use surrealdb::Surreal;
use surrealdb::sql::Thing;
use surrealdb::engine::remote::http::Client;
use ammonia::clean;
use argon2::password_hash::rand_core::OsRng;
use argon2::password_hash::SaltString;
use crate::server::db::models::accounts::{Account, AccountForm};

pub async fn sign_up(db: &Surreal<Client>, email: String, password: String) -> Result<(), ServerFnError> {
    let new_email = clean(&email);
    let argon2 = Argon2::default();
    let salt = SaltString::generate(&mut OsRng);
    let hashed_password = argon2.hash_password(clean(&password).as_bytes(), &salt)?.to_string();
    
    let new_account = db.create::<Account>("accounts")
        .content(AccountForm {
            email: new_email,
            password: hashed_password,
            terms_agree: true,
        })
        .await?;
    
    todo!()
}