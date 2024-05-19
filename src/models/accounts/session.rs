use chrono::{DateTime, Utc};
use sqlx::{FromRow, Pool, Postgres};
use uuid::Uuid;
use serde::{Serialize, Deserialize};
use crate::error_template::SailfishError;

#[derive(Serialize, Deserialize, FromRow, Debug, Clone)]
pub struct Session {
    pub id: Uuid,
    pub account_id: Uuid,
    pub ip_addr: Option<String>,
    pub browser: Option<String>,
    pub device: Option<String>,
    pub os: Option<String>,
    pub created_at: DateTime<Utc>,
    pub expires_on: DateTime<Utc>,
}

impl Session {
    /// Starts a new session, adding a `Session` to the database and returning its ID.
    pub async fn start(account_id: Uuid, expiration: DateTime<Utc>, db: &Pool<Postgres>) -> Result<Uuid, SailfishError> {
        let record = sqlx::query!(
            r#"INSERT INTO sessions (account_id, expires_on) VALUES ($1, $2) RETURNING id;"#,
            account_id,
            expiration,
        ).fetch_one(db).await?;

        Ok(record.id)
    }

    /// Verifies an active session via database lookup and returns the corresponding account ID.
    pub async fn verify_session(session_id: Uuid, db: &Pool<Postgres>) -> Result<Uuid, SailfishError> {
        let session: Uuid = match sqlx::query!(
            r#"SELECT account_id FROM sessions WHERE id = $1 AND expires_on > $2;"#,
            session_id,
            Utc::now(),
        ).fetch_one(db).await {
            Ok(s) => s.account_id,
            Err(_) => return Err(SailfishError::Unauthorized)
        };

        Ok(session)
    }
}