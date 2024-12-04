use chrono::{DateTime, Utc};
use sqlx::{Pool, Postgres, FromRow};
use serde::{Serialize, Deserialize};
use crate::errors::AppError;

#[derive(Debug, Clone, FromRow, Serialize, Deserialize)]
pub struct Session {
    pub id: String,
    pub account_id: String,
    pub ip_addr: Option<String>,
    pub browser: Option<String>,
    pub device: Option<String>,
    pub os: Option<String>,
    pub created_at: DateTime<Utc>,
    pub expires_on: DateTime<Utc>,
}

impl Session {
    /// Starts a new session, adding a `Session` to the database and returning its ID.
    pub async fn start(account_id: String, expiration: DateTime<Utc>, db: &Pool<Postgres>) -> Result<String, AppError> {
        let record = sqlx::query!(
            r#"INSERT INTO sessions (account_id, expires_on) VALUES ($1, $2) RETURNING id;"#,
            account_id,
            expiration,
        ).fetch_one(db).await?;

        Ok(record.id)
    }

    /// Verifies an active session via database lookup and returns the corresponding account ID.
    pub async fn verify_session(session_id: String, db: &Pool<Postgres>) -> Result<String, AppError> {
        let session: String = match sqlx::query!(
            r#"SELECT account_id FROM sessions WHERE id = $1 AND expires_on > $2;"#,
            session_id,
            Utc::now(),
        ).fetch_one(db).await {
            Ok(s) => s.account_id,
            Err(_) => return Err(AppError::Unauthorized)
        };

        Ok(session)
    }

    /// Authorizes an account based on a session 
    pub async fn authorize(db: &Pool<Postgres>) -> Option<super::account::Account> {
        use leptos_axum::extract;
        use tower_cookies::Cookies;
        use crate::constants::SECRET_KEY;
        use super::account::Account;

        let key = SECRET_KEY.get()?;
        let cookies = extract::<Cookies>().await.ok()?.private(key);
    
        let token = cookies.get("session-token")?.value().into();

        let account_id = Self::verify_session(token, db).await.ok()?;
        
        Account::fetch_by_id(account_id, db).await
    }
}