use ammonia::clean;
use argon2::{Argon2, PasswordHash, PasswordHasher, PasswordVerifier, password_hash::SaltString};
use chrono::{DateTime, Utc};
use sqlx::{PgPool, FromRow};
use serde::{Serialize, Deserialize};
use rand::rngs::OsRng;
use uuid::Uuid;
use crate::errors::AppError;
use super::role::Role;

#[derive(Debug, Clone, FromRow, Serialize, Deserialize)]
pub struct Account {
    pub id: Uuid,
    pub email: String,
    pub password: String,
    pub roles: Vec<Role>,
    pub terms_agree: bool,
    pub email_confirmed: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

impl Account {
    /// Create a new account in the database, hashing the password with Argon2 in the process. Returns the account if successful.
    pub async fn new(email: String, password: String, db: &PgPool) -> Result<Self, AppError> {
        let clean_email = clean(&email);
        let clean_password = clean(&password);

        let hash_result = tokio::task::spawn_blocking(move || {
            let argon2 = Argon2::default();
            let salt = SaltString::generate(&mut OsRng);
            match argon2.hash_password(clean_password.as_bytes(), &salt) {
                Ok(hash) => Ok(hash.to_string()),
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
    pub async fn verify(email: String, password: String, db: &PgPool) -> Result<Self, AppError> {
        let clean_email = clean(&email);
        let clean_password = clean(&password);

        let account = Self::fetch_by_email(clean_email, db).await;

        if let Some(account) = account {
            let current_password = account.password.clone();
            let result = tokio::task::spawn_blocking(move || {
                let password_hash = PasswordHash::new(current_password.as_str())?;
                match Argon2::default().verify_password(clean_password.as_bytes(), &password_hash) {
                    Ok(()) => Ok(()),
                    Err(_) => Err(AppError::ServerError)
                }
            }).await?;

            match result {
                Ok(()) => Ok(account),
                Err(e) => Err(e)
            }
        } else {
            Err(AppError::Unauthorized)
        }
    }

    /// Fetches an account by its email address. If an account is found, returns `Some(Account)`, else `None`.
    pub async fn fetch_by_email(email: String, db: &PgPool) -> Option<Account> {
        let clean_email = clean(&email);

        sqlx::query_as!(
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
        ).fetch_optional(db).await.ok()?
    }

    /// Fetches an account by its ID. If an account is found, returns `Some(Account)`, else `None`.
    pub async fn fetch_by_id(id: String, db: &PgPool) -> Option<Account> {
        sqlx::query_as!(
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
            Uuid::parse_str(&id).ok()?
        ).fetch_optional(db).await.ok()?
    }

    /// Marks an account as confirmed
    pub async fn confirm(&self, db: &PgPool) -> Result<(), AppError> {
        _ = sqlx::query!(
            r#"
                UPDATE accounts SET email_confirmed = $1 WHERE id = $2;
            "#,
            true,
            self.id,
        ).execute(db).await?;

        Ok(())
    }

    /// Resets a user's password
    pub async fn reset_password(&self, new_password: String, db: &PgPool) -> Result<(), AppError> {
        let clean_password = clean(&new_password);

        let hash_result = tokio::task::spawn_blocking(move || {
            let argon2 = Argon2::default();
            let salt = SaltString::generate(&mut OsRng);
            match argon2.hash_password(clean_password.as_bytes(), &salt) {
                Ok(hash) => Ok(hash.to_string()),
                Err(e) => Err(e)
            }
        }).await??;

        _ = sqlx::query!(
            r#"
                UPDATE accounts SET password = $1 WHERE id = $2;
            "#,
            hash_result,
            self.id
        ).execute(db).await?;

        Ok(())
    }
}
