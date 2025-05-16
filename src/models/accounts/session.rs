use chrono::{DateTime, Utc};
use sqlx::{FromRow, PgPool};
use serde::{Serialize, Deserialize};
use uuid::Uuid;
use crate::errors::AppError;
use crate::constants::SESSION_TOKEN_NAME;
use super::account::Account;
use super::role::Role;

#[derive(Debug, Clone, FromRow, Serialize, Deserialize)]
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
    pub async fn start(account_id: Uuid, expiration: DateTime<Utc>, db: &PgPool) -> Result<String, AppError> {
        let record = sqlx::query!(
            r#"INSERT INTO sessions (account_id, expires_on) VALUES ($1, $2) RETURNING id;"#,
            account_id,
            expiration,
        ).fetch_one(db).await?;

        Ok(record.id.to_string())
    }

    /// Verifies an active session via database lookup and returns the corresponding account ID.
    pub async fn verify_session(session_id: Uuid, db: &PgPool) -> Result<Account, AppError> {
        let account_id: String = match sqlx::query!(
            r#"SELECT account_id FROM sessions WHERE id = $1 AND expires_on > $2;"#,
            session_id,
            Utc::now(),
        ).fetch_one(db).await {
            Ok(s) => s.account_id.to_string(),
            Err(_) => return Err(AppError::Unauthorized)
        };

        let account = Account::fetch_by_id(account_id, db).await;
        match account {
            Some(a) => Ok(a),
            None => Err(AppError::ServerError)
        }
    }

    /// Authorizes an account based on a session 
    pub async fn authorize(required_roles: Vec<Role>, db: &PgPool) -> Option<super::account::Account> {
        use leptos_axum::extract;
        use tower_cookies::Cookies;
        use crate::constants::SECRET_KEY;
        use crate::util::functions::intersection;

        let key = SECRET_KEY.get()?;
        let cookies = extract::<Cookies>().await.ok()?.private(key);
    
        let token = Uuid::parse_str(cookies.get(SESSION_TOKEN_NAME)?.value()).ok()?;

        let account = Self::verify_session(token, db).await.ok()?;
        
        match intersection(&required_roles, &account.roles).is_empty() {
            true => Some(account),
            false => None,
        }
    }
}