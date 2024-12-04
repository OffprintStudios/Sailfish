use chrono::{DateTime, Utc};
use serde::{Serialize, Deserialize};
use sqlx::{FromRow, Pool, Postgres};
use crate::errors::AppError;
use super::account::Account;

#[derive(Debug, Clone, FromRow, Serialize, Deserialize)]
pub struct ConfirmationCode {
    pub id: String,
    pub account_id: String,
    pub token: String,
    pub used: bool,
    pub expires_on: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
}

impl ConfirmationCode {
    /// Creates a new account confirmation code
    pub async fn new(account_id: String, expiration: DateTime<Utc>, db: &Pool<Postgres>) -> Result<Self, AppError> {
        let code: Self = sqlx::query_as!(
            Self,
            r#"INSERT INTO confirmation_codes (account_id, expires_on) VALUES ($1, $2) RETURNING *;"#,
            account_id,
            expiration,
        ).fetch_one(db).await?;
        
        Ok(code)
    }

    /// Checks to see if an account confirmation code is valid, returning the related account if so
    pub async fn validate(token: String, db: &Pool<Postgres>) -> Result<Account, AppError> {
        let code: Option<Self> = sqlx::query_as!(
            Self,
            r#"SELECT * FROM confirmation_codes WHERE token = $1 AND expires_on > $2 AND used = $3;"#,
            token,
            Utc::now(),
            false,
        ).fetch_optional(db).await?;
        
        if let Some(code) = code {
            _ = sqlx::query!(
                r#"UPDATE confirmation_codes SET used = $1 WHERE id = $2;"#,
                true,
                code.id,
            ).execute(db).await?;
            
            Account::fetch_by_id(code.account_id, db)
                .await
                .ok_or(AppError::Unauthorized)
        } else {
            Err(AppError::Unauthorized)
        }
    }
}