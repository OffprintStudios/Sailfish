use uuid::Uuid;
use chrono::{DateTime, Utc};
use serde::{Serialize, Deserialize};
use sqlx::{PgPool, FromRow};
use crate::errors::AppError;

use super::Account;
use super::ProfileObject;
use super::Follower;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq, FromRow)]
pub struct Profile {
    pub id: String,
    pub account_id: Uuid,
    pub username: String,
    pub avatar: String,
    pub banner_art: Option<String>,
    pub bio: String,
    pub tagline: Option<String>,
    pub links: Vec<String>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub deleted_at: Option<DateTime<Utc>>
}

impl Profile {
    pub async fn new(account_id: Uuid, username: String, db: &PgPool) -> Result<Self, AppError> {
        let clean_username = ammonia::clean(&username);

        let result: Self = sqlx::query_as!(
            Self,
            r#"
                INSERT INTO profiles (account_id, username) VALUES ($1, $2) RETURNING *;
            "#,
            account_id,
            clean_username,
        ).fetch_one(db).await?;

        Ok(result)
    }

    pub async fn fetch_one(id: String, db: &PgPool) -> Result<Self, AppError> {
        let result: Self = sqlx::query_as!(
            Self,
            r#"
                SELECT * FROM profiles WHERE id = $1 AND deleted_at IS NULL LIMIT 1;
            "#,
            ammonia::clean(&id),
        ).fetch_one(db).await?;

        Ok(result)
    }

    pub async fn fetch_by_username(username: String, db: &PgPool) -> Option<Self> {
        let result: Self = sqlx::query_as!(
            Self,
            r#"
                SELECT * FROM profiles WHERE username = $1 AND deleted_at IS NULL LIMIT 1;
            "#,
            ammonia::clean(&username)
        ).fetch_one(db).await.ok()?;

        Some(result)
    }

    pub async fn fetch_owned(account_id: Uuid, db: &PgPool) -> Result<Vec<Self>, AppError> {
        let result: Vec<Self> = sqlx::query_as!(
            Self,
            r#"
                SELECT * FROM profiles WHERE account_id = $1 AND deleted_at IS NULL;
            "#,
            account_id,
        ).fetch_all(db).await?;

        Ok(result)
    }

    pub async fn check_owned(id: String, account_id: Uuid, db: &PgPool) -> bool {
        sqlx::query!(
            r#"
                SELECT id FROM profiles WHERE id = $1 AND account_id = $2 AND deleted_at IS NULL LIMIT 1;
            "#,
            ammonia::clean(&id),
            account_id,
        ).fetch_one(db).await.ok().is_some()
    }

    pub async fn to_object(&self, db: &PgPool) -> ProfileObject {
        let account = Account::fetch_by_id(self.account_id.to_string(), db).await.unwrap();
        let count_followers = Follower::count_followers(self.id.clone(), db).await;
        let count_following = Follower::count_following(self.id.clone(), db).await;

        ProfileObject {
            id: self.id.clone(),
            username: self.username.clone(),
            avatar: self.avatar.clone(),
            banner_art: self.banner_art.clone(),
            bio: self.bio.clone(),
            tagline: self.tagline.clone(),
            links: self.links.clone(),
            followers: count_followers.unwrap_or(0),
            following: count_following.unwrap_or(0),
            works: 0,
            blogs: 0,
            roles: account.roles,
            created_at: self.created_at,
        }
    }
}
