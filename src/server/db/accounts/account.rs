use chrono::{DateTime, Utc};
use serde::{Serialize, Deserialize};
use sqlx::{Pool, Postgres, FromRow};
use argon2::{Argon2, PasswordHash, PasswordHasher, PasswordVerifier};
use uuid::Uuid;
use ammonia::clean;
use argon2::password_hash::SaltString;
use rand::rngs::OsRng;
use crate::server::api::ApiError;
use super::role::Role;

#[derive(Serialize, Deserialize, FromRow, Debug, Clone)]
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
    pub async fn new(email: String, password: String, db: &Pool<Postgres>) -> Result<Self, ApiError> {
        let clean_email = clean(&email);
        let clean_password = clean(&password);

        let hash_result = tokio::task::spawn_blocking(move || {
            let argon2 = Argon2::default();
            let salt = SaltString::generate(&mut OsRng);
            match argon2.hash_password(clean_password.as_bytes(), &salt) {
                Ok(h) => Ok(h.to_string()),
                Err(e) => Err(e)
            }
        }).await??;

        let new_account: Self = sqlx::query_as!(
            Self,
            r#"
                INSERT INTO accounts (email, password, terms_agree) VALUES ($1, $2, $3)
                    RETURNING
                        id,
                        email,
                        password,
                        roles as "roles: Vec<Role>",
                        terms_agree,
                        email_confirmed,
                        created_at,
                        updated_at;
            "#,
            clean_email,
            hash_result,
            true
        ).fetch_one(db).await?;

        Ok(new_account)
    }

    /// Verifies that the provided credentials match an associated account, returning that `Account` if successful.
    pub async fn verify_credentials(email: String, password: String, db: &Pool<Postgres>) -> Result<Account, ApiError>{
        let clean_email = clean(&email);
        let clean_password = clean(&password);

        let account = Self::fetch_by_email(clean_email, db).await?;

        if let Some(acc) = account {
            let current_password = acc.password.clone();

            let result = tokio::task::spawn_blocking(move || {
                let password_hash = PasswordHash::new(current_password.as_str())?;
                match Argon2::default().verify_password(clean_password.as_bytes(), &password_hash) {
                    Ok(()) => Ok(()),
                    Err(_) => Err(ApiError::unauthorized(None))
                }
            }).await?;

            match result {
                Ok(()) => Ok(acc),
                Err(e) => Err(e),
            }
        } else {
            Err(ApiError::unauthorized(Some("The email/password combo you entered does not exist.".to_string())))
        }
    }

    /// Fetches an account by its email address. If an account is found, returns `Some(Account)`, else `None`.
    pub async fn fetch_by_email(email: String, db: &Pool<Postgres>) -> Result<Option<Account>, ApiError> {
        let clean_email = clean(&email);

        let account: Option<Account> = sqlx::query_as!(
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
                FROM accounts WHERE email = $1
            "#,
            clean_email
        ).fetch_optional(db).await?;

        Ok(account)
    }

    /// Fetches an account by its ID. If an account is found, returns `Some(Account)`, else `None`.
    pub async fn fetch_by_id(id: Uuid, db: &Pool<Postgres>) -> Result<Option<Account>, ApiError> {
        let account: Option<Account> = sqlx::query_as!(
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
        ).fetch_optional(db).await?;

        Ok(account)
    }
}