use argon2::Argon2;
use argon2::password_hash::{rand_core::OsRng, PasswordHasher, SaltString};
use leptos::ServerFnError;
use sea_orm::ActiveValue::Set;
use sea_orm::{ActiveModelTrait, ActiveEnum, EntityTrait, DatabaseConnection, QueryFilter, ColumnTrait};
use crate::server::db::entities::*;
use crate::server::db::entities::prelude::Account;

pub async fn sign_up(conn: &DatabaseConnection, email: String, password: String) -> Result<(), ServerFnError> {
    // first we check to see if an account with this email already exists
    let existing_account = Account::find()
        .filter(account::Column::Email.contains(email.clone()))
        .all(conn)
        .await?;
    
    if existing_account.len() > 0 {
        return Err(ServerFnError::new("An account with this email already exists!"))
    }
    
    // if nothing is found, we start hashing the provided password
    let argon2 = Argon2::default();
    let salt = SaltString::generate(&mut OsRng);
    let password_hash = match argon2.hash_password(password.as_bytes(), &salt) {
        Ok(hash) => hash.to_string(),
        Err(_) => return Err(ServerFnError::new("Unable to hash password!"))
    };
    
    // then we create a new account with all the necessary fields
    let new_account = account::ActiveModel {
        email: Set(email.to_owned()),
        password: Set(password_hash.to_owned()),
        roles: Set(vec![roles::Roles::User.to_value()]),
        terms_agree: Set(true),
        email_confirmed: Set(false),
        ..Default::default()
    };
    
    // and return `Ok(())` if everything's good, otherwise we spit out an error
    match new_account.insert(conn).await {
        Ok(_) => Ok(()),
        Err(_) => Err(ServerFnError::new("Something went wrong when attempting to create your account!"))
    }
}