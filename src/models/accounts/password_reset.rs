use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, Pool, Postgres};
use uuid::Uuid;
use crate::error_template::SailfishError;
use super::account::Account;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct PasswordReset {
    pub id: Uuid,
    pub account_id: Uuid,
    pub token: String,
    pub used: bool,
    pub expires_on: DateTime<Utc>,
    pub created_at: DateTime<Utc>,
}

impl PasswordReset {
    /// Creates a new password reset token
    pub async fn new(account_id: Uuid, expiration: DateTime<Utc>, db: &Pool<Postgres>) -> Result<Self, SailfishError> {
        let reset: Self = sqlx::query_as!(
            Self,
            r#"INSERT INTO password_resets (account_id, expires_on) VALUES ($1, $2) RETURNING *;"#,
            account_id,
            expiration,
        ).fetch_one(db).await?;

        Ok(reset)
    }

    /// Checks to see if a password reset code is valid, returning the related account if so
    pub async fn validate(token: String, db: &Pool<Postgres>) -> Result<Account, SailfishError> {
        let reset: Option<Self> = sqlx::query_as!(
            Self,
            r#"SELECT * FROM password_resets WHERE token = $1 AND expires_on > $2 AND used = $3;"#,
            token,
            Utc::now(),
            false,
        ).fetch_optional(db).await?;

        if let Some(reset) = reset {
            _ = sqlx::query!(
                r#"UPDATE password_resets SET used = $1 WHERE id = $2;"#,
                true,
                reset.id,
            ).execute(db).await?;
            
            Account::fetch_by_id(reset.account_id, db)
                .await
                .ok_or(SailfishError::Unauthorized)
        } else {
            Err(SailfishError::Unauthorized)
        }
    }
}