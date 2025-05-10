use serde::{Serialize, Deserialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};
use sqlx::{PgPool, FromRow};
use crate::errors::AppError;

#[derive(Debug, Clone, Serialize, Deserialize, FromRow)]
pub struct Follower {
    pub id: Uuid,
    pub profile_id: String,
    pub subscribed_to: String,
    pub created_at: DateTime<Utc>,
}

impl Follower {
    pub async fn follow(profile_id: String, subscribed_to: String, db: &PgPool) -> Result<Self, AppError> {
        let result: Self = sqlx::query_as!(
            Self,
            r#"
                INSERT INTO followers (profile_id, subscribed_to) VALUES ($1, $2) RETURNING *;
            "#,
            ammonia::clean(&profile_id),
            ammonia::clean(&subscribed_to),
        ).fetch_one(db).await?;

        Ok(result)
    }

    pub async fn unfollow(profile_id: String, subscribed_to: String, db: &PgPool) -> Result<(), AppError> {
        sqlx::query!(
            r#"
                DELETE FROM followers WHERE profile_id = $1 AND subscribed_to = $2;
            "#,
            ammonia::clean(&profile_id),
            ammonia::clean(&subscribed_to),
        ).fetch_one(db).await?;

        Ok(())
    }

    pub async fn count_followers(profile_id: String, db: &PgPool) -> Option<i64> {
        sqlx::query_scalar!(
            r#"
                SELECT count(f.id) FROM followers f WHERE subscribed_to = $1;
            "#,
            ammonia::clean(&profile_id),
        ).fetch_one(db).await.ok()?
    }

    pub async fn count_following(profile_id: String, db: &PgPool) -> Option<i64> {
        sqlx::query_scalar!(
            r#"
                SELECT count(f.id) FROM followers f WHERE profile_id = $1;
            "#,
            ammonia::clean(&profile_id)
        ).fetch_one(db).await.ok()?
    }
}