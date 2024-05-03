use argon2::Argon2;
use argon2::password_hash::{rand_core::OsRng, PasswordHasher, SaltString};
use diesel_async::RunQueryDsl;
use crate::server::db::models::accounts::{NewAccount, Roles};
use crate::server::db::Pool;

pub async fn sign_up(db: Pool, email: String, password: String) -> Result<(), Option<String>> {
    use crate::server::db::schema::accounts;
    
    let mut conn = db
        .get()
        .await
        .map_err(|_| Some("An error has occurred attempting to get a connection to the database!".to_string()))?;
    
    let argon2 = Argon2::default();
    let salt = SaltString::generate(&mut OsRng);
    let password_hash = match argon2.hash_password(password.as_bytes(), &salt) {
        Ok(hash) => hash.to_string(),
        Err(_) => return Err(Some(String::from("An error has occurred!")))
    };
    
    let new_account = NewAccount {
        email: &email,
        password: &password_hash,
        roles: vec![Some(Roles::User.to_value())],
        terms_agree: true,
        email_confirmed: false,
    };
    
    let _res = diesel::insert_into(accounts::table)
        .values(new_account)
        .execute(&mut conn)
        .await
        .map_err(|_| Some("An error has occurred fetching results!".to_string()))?;
    
    Ok(())
}