use ammonia::clean;
use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, Pool, Postgres};
use uuid::Uuid;
use nanoid::nanoid;
use crate::server::api::ApiError;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct Profile {
    pub id: String,
    pub account_id: Uuid,
    pub username: String,
    pub avatar: String,
    pub banner_art: Option<String>,
    pub bio: String,
    pub tagline: Option<String>,
    pub links: Vec<String>,
    pub presence: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

impl Profile {
    /// Creates a new profile belonging to the specified `account_id`, returning said profile on successful creation.
    pub async fn new(account_id: Uuid, new_username: String, new_bio: Option<String>, db: &Pool<Postgres>) -> Result<Self, ApiError> {
        let clean_username = clean(&new_username);
        let clean_bio = match new_bio {
            Some(bio) => clean(&bio),
            None => clean("Just another friendly face in the crowd")
        };

        let result: Self = sqlx::query_as!(
            Self,
            r#"INSERT INTO profiles (id, account_id, username, bio) VALUES ($1, $2, $3, $4) RETURNING *;"#,
            nanoid!(12),
            account_id,
            clean_username,
            clean_bio,
        ).fetch_one(db).await?;

        Ok(result)
    }

    /// Fetches all profiles owned by a specific `account_id`.
    pub async fn fetch_owned(account_id: Uuid, db: &Pool<Postgres>) -> Result<Vec<Self>, ApiError> {
        let results: Vec<Self> = sqlx::query_as!(
            Self,
            r#"SELECT * FROM profiles WHERE account_id = $1;"#,
            account_id,
        ).fetch_all(db).await?;

        Ok(results)
    }
    
    /// Verifies a single profile ID to see if it's owned by the specified account.
    pub async fn check_owned(profile_id: String, account_id: Uuid, db: &Pool<Postgres>) -> Result<Self, ApiError> {
        let result: Self = sqlx::query_as!(
            Self,
            r#"SELECT * FROM profiles WHERE id = $1 AND account_id = $2;"#,
            profile_id,
            account_id,
        ).fetch_one(db).await?;
        
        Ok(result)
    }
    
    /// Checks to see if any usernames exist which match `potential_username`.
    pub async fn is_username_taken(potential_username: String, db: &Pool<Postgres>) -> Result<bool, ApiError> {
        let result: Vec<Self> = sqlx::query_as!(
            Self,
            r#"SELECT * FROM profiles WHERE username = $1"#,
            potential_username,
        ).fetch_all(db).await?;
        
        Ok(result.len() > 0)
    }
    
    /// Fetches a single profile based on its ID.
    pub async fn fetch_one(profile_id: String, db: &Pool<Postgres>) -> Result<Self, ApiError> {
        let result: Self = sqlx::query_as!(
            Self,
            r#"SELECT * FROM profiles WHERE id = $1;"#,
            profile_id,
        ).fetch_one(db).await?;
        
        Ok(result)
    }
}