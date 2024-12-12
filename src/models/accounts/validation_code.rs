use chrono::{DateTime, Utc};
use serde::{Serialize, Deserialize};
use sqlx::{FromRow, PgPool, Type};
use crate::errors::AppError;
use super::account::Account;

#[derive(Debug, Clone, Serialize, Deserialize, Type)]
pub enum ValidationKind {
    PasswordReset,
    EmailConfirmation,
}

impl From<String> for ValidationKind {
    fn from(value: String) -> Self {
        match value.as_str() {
            "EmailConfirmation" => ValidationKind::EmailConfirmation,
            "PasswordReset" => ValidationKind::PasswordReset,
            _ => ValidationKind::EmailConfirmation,
        }
    }
}

impl std::fmt::Display for ValidationKind {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ValidationKind::EmailConfirmation => write!(f, "EmailConfirmation"),
            ValidationKind::PasswordReset => write!(f, "PasswordReset")
        }
    }
}

#[derive(Debug, Clone, FromRow, Serialize, Deserialize)]
pub struct ValidationCode {
    pub id: String,
    pub account_id: String,
    pub token: String,
    pub kind: ValidationKind,
    pub expires_on: DateTime<Utc>,
    pub created_at: DateTime<Utc>
}

impl ValidationCode {
    /// Creates a new validation token
    pub async fn new(account_id: String, kind: ValidationKind, expiration: DateTime<Utc>, db: &PgPool) -> Result<Self, AppError> {
        let reset: Self = sqlx::query_as!(
            Self,
            r#"INSERT INTO validation_codes (account_id, kind, expires_on) VALUES ($1, $2, $3) RETURNING *;"#,
            account_id,
            kind.to_string(),
            expiration,
        ).fetch_one(db).await?;

        Ok(reset)
    }

    /// Checks to see if a password reset code is valid, returning the related account if so
    pub async fn validate(token: String, kind: ValidationKind, db: &PgPool) -> Result<Account, AppError> {
        let code: Option<Self> = sqlx::query_as!(
            Self,
            r#"SELECT * FROM validation_codes WHERE kind = $1 AND token = $2 AND expires_on > $3;"#,
            kind.to_string(),
            token,
            Utc::now(),
        ).fetch_optional(db).await?;

        if let Some(code) = code {
            _ = sqlx::query!(
                r#"DELETE FROM validation_codes WHERE id = $1;"#,
                code.id
            ).execute(db).await?;
            
            Account::fetch_by_id(code.account_id, db)
                .await
                .ok_or(AppError::Unauthorized)
        } else {
            Err(AppError::Unauthorized)
        }
    }
}