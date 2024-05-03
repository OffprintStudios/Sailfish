use argon2::Argon2;
use argon2::password_hash::{PasswordHash, PasswordVerifier};
use leptos::ServerFnError;
use sea_orm::{EntityTrait, DatabaseConnection, QueryFilter, ColumnTrait};
use crate::server::db::entities::*;
use crate::server::db::entities::prelude::Account;

pub async fn log_in(conn: &DatabaseConnection, email: String, password: String) -> Result<account::Model, ServerFnError> {
    let err_msg = "The email/password combo you provided isn't quite right.";
    
    // first we check for any account matching the provided email, returning an error if none is found
    let existing_account = Account::find()
        .filter(account::Column::Email.contains(email.clone()))
        .one(conn)
        .await?;
    
    if existing_account.is_none() {
        return Err(ServerFnError::new(err_msg));
    }
    
    // if an account is found, proceed with validation
    let account = existing_account.unwrap();
    let argon2 = Argon2::default();
    let parsed_hash = PasswordHash::new(&account.password)
        .map_err(|_| ServerFnError::new(err_msg))?;
    
    if argon2.verify_password(password.as_bytes(), &parsed_hash).is_ok() {
        Ok(account)
    } else {
        Err(ServerFnError::new(err_msg))
    }
}