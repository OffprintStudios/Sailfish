use chrono::{DateTime, Utc};
use serde::{Serialize, Deserialize};
use uuid::Uuid;
use super::role::Role;

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
#[cfg_attr(feature = "ssr", derive(sqlx::FromRow))]
pub struct Profile {
    pub id: String,
    pub account_id: Uuid,
    pub username: String,
    pub avatar: String,
    pub banner_art: Option<String>,
    pub bio: String,
    pub tagline: Option<String>,
    pub links: Vec<String>,
    pub works: i32,
    pub blogs: i32,
    pub followers: i64,
    pub following: i64,
    pub default: bool,
    pub roles: Vec<Role>,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
    pub deleted_at: Option<DateTime<Utc>>
}

impl Profile {
    /// Creates a new profile belonging to the specified `account_id`, returning said profile on successful creation.
    #[cfg(feature = "ssr")]
    pub async fn new(account_id: Uuid, new_username: String, new_bio: Option<String>, roles: Vec<Role>, db: &sqlx::Pool<sqlx::Postgres>) -> Result<Self, crate::errors::AppError> {
        let clean_username = ammonia::clean(&new_username);
        let clean_bio = match new_bio {
            Some(bio) => ammonia::clean(&bio),
            None => ammonia::clean("Just another friendly face in the crowd")
        };

        let roles_str_arr = roles.iter().map(|role| role.to_string()).collect::<Vec<String>>();
        let roles_str = roles_str_arr.as_slice();

        let result: Self = sqlx::query_as!(
            Self,
            r#"
                INSERT INTO profiles (account_id, username, bio, roles) VALUES ($1, $2, $3, $4) 
                    RETURNING
                        id,
                        account_id,
                        username,
                        avatar,
                        banner_art,
                        bio,
                        tagline,
                        links,
                        works,
                        blogs,
                        followers,
                        following,
                        "default",
                        roles as "roles: Vec<Role>",
                        created_at,
                        updated_at,
                        deleted_at;
            "#,
            account_id,
            clean_username,
            clean_bio,
            roles_str
        ).fetch_one(db).await?;

        Ok(result)
    }

    #[cfg(feature = "ssr")]
    pub async fn fetch_one(profile_id: String, db: &sqlx::Pool<sqlx::Postgres>) -> Result<Self, crate::errors::AppError> {
        let result: Self = sqlx::query_as!(
            Self,
            r#"
                SELECT 
                    id,
                    account_id,
                    username,
                    avatar,
                    banner_art,
                    bio,
                    tagline,
                    links,
                    works,
                    blogs,
                    followers,
                    following,
                    "default",
                    roles as "roles: Vec<Role>",
                    created_at,
                    updated_at,
                    deleted_at
                FROM profiles WHERE id = $1 AND deleted_at IS NULL;
            "#,
            profile_id,
        ).fetch_one(db).await?;

        Ok(result)
    }

    /// Fetches all profiles owned by a specific `account_id`.
    #[cfg(feature = "ssr")]
    pub async fn fetch_owned(account_id: Uuid, db: &sqlx::Pool<sqlx::Postgres>) -> Result<Vec<Self>, crate::errors::AppError> {
        let results: Vec<Self> = sqlx::query_as!(
            Self,
            r#"
                SELECT 
                    id,
                    account_id,
                    username,
                    avatar,
                    banner_art,
                    bio,
                    tagline,
                    links,
                    works,
                    blogs,
                    followers,
                    following,
                    "default",
                    roles as "roles: Vec<Role>",
                    created_at,
                    updated_at,
                    deleted_at
                FROM profiles WHERE account_id = $1 AND deleted_at IS NULL;
            "#,
            account_id,
        ).fetch_all(db).await?;

        Ok(results)
    }

    /// Verifies a single profile ID to see if it's owned by the specified account.
    #[cfg(feature = "ssr")]
    pub async fn check_owned(profile_id: String, account_id: Uuid, db: &sqlx::Pool<sqlx::Postgres>) -> Result<Self, crate::errors::AppError> {
        let result: Self = sqlx::query_as!(
            Self,
            r#"
                SELECT 
                    id,
                    account_id,
                    username,
                    avatar,
                    banner_art,
                    bio,
                    tagline,
                    links,
                    works,
                    blogs,
                    followers,
                    following,
                    "default",
                    roles as "roles: Vec<Role>",
                    created_at,
                    updated_at,
                    deleted_at
                FROM profiles WHERE id = $1 AND account_id = $2 AND deleted_at IS NULL;
            "#,
            profile_id,
            account_id,
        ).fetch_one(db).await?;

        Ok(result)
    }

    /// Fetches a profile by its username
    #[cfg(feature = "ssr")]
    pub async fn fetch_by_username(username: String, db: &sqlx::Pool<sqlx::Postgres>) -> Option<Profile> {
        use ammonia::clean;
        
        let result: Self = sqlx::query_as!(
            Self,
            r#"
                SELECT 
                    id,
                    account_id,
                    username,
                    avatar,
                    banner_art,
                    bio,
                    tagline,
                    links,
                    works,
                    blogs,
                    followers,
                    following,
                    "default",
                    roles as "roles: Vec<Role>",
                    created_at,
                    updated_at,
                    deleted_at
                FROM profiles WHERE username = $1 AND deleted_at IS NULL;
            "#,
            clean(&username),
        ).fetch_one(db).await.ok()?;

        Some(result)
    }
}