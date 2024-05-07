use ammonia::clean;
use argon2::{Argon2, PasswordHash, PasswordHasher, PasswordVerifier};
use argon2::password_hash::rand_core::OsRng;
use argon2::password_hash::SaltString;
use serde::{Serialize, Deserialize};
use chrono::{DateTime, Utc};
use sqlx::{FromRow, Pool, Postgres};
use uuid::Uuid;
use crate::server::SailfishError;
use super::role::Role;

#[derive(Serialize, Deserialize, FromRow)]
pub struct Account {
    pub id: Uuid,
    pub email: String,
    pub password: String,
    pub roles: Vec<Role>,
    pub terms_agree: bool,
    pub email_confirmed: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>
}

impl Account {
    /// Create a new account in the database, hashing the password with Argon2 in the process. Returns the number of rows affected if successful.
    pub async fn new(db: &Pool<Postgres>, email: String, password: String) -> Result<u64, SailfishError> {
        let clean_email = clean(&email);
        let clean_password = clean(&password);
        
        let argon2 = Argon2::default();
        let salt = SaltString::generate(&mut OsRng);
        let hashed_password = argon2
            .hash_password(clean_password.as_bytes(), &salt)?
            .to_string();
        
        let rows_affected = sqlx::query!(
            r#"INSERT INTO accounts (email, password, terms_agree) VALUES ($1, $2, $3);"#,
            clean_email,
            hashed_password,
            true
        ).execute(db).await?.rows_affected();
        
        Ok(rows_affected)
    }
    
    /// Verifies that the provided credentials match an associated account, returning that `Account` if successful.
    pub async fn verify_credentials(db: &Pool<Postgres>, email: String, password: String) -> Result<Account, SailfishError> {
        let clean_email = clean(&email);
        let clean_password = clean(&password);
        
        let account: Self = sqlx::query_as!(Self, r#"
                SELECT 
                    id, 
                    email, 
                    password, 
                    roles as "roles: Vec<Role>", 
                    terms_agree, 
                    email_confirmed, 
                    created_at, 
                    updated_at
                FROM accounts WHERE email = $1
            "#, clean_email)
            .fetch_one(db)
            .await?;
        
        let password_hash = PasswordHash::new(account.password.as_str())?;
        match Argon2::default().verify_password(clean_password.as_bytes(), &password_hash) {
            Ok(()) => Ok(account),
            Err(_) => Err(SailfishError::unauthorized(Some("You're not allowed to do that!".to_string()))),
        }
    }
    
    pub async fn fetch_by_id(id: Uuid, db: &Pool<Postgres>) -> Result<Account, SailfishError> {
        let account: Account = sqlx::query_as!(
            Self,
            r#"
                SELECT 
                    id, 
                    email, 
                    password, 
                    roles as "roles: Vec<Role>", 
                    terms_agree, 
                    email_confirmed, 
                    created_at, 
                    updated_at
                FROM accounts WHERE id = $1
            "#,
            id
        ).fetch_one(db).await?;
        
        Ok(account)
    }
}