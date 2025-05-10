use serde::{Serialize, Deserialize};
use chrono::{DateTime, Utc};
use super::role::Role;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[cfg_attr(feature = "ssr", derive(sqlx::FromRow))]
pub struct ProfileObject {
    pub id: String,
    pub username: String,
    pub avatar: String,
    pub banner_art: Option<String>,
    pub bio: String,
    pub tagline: Option<String>,
    pub links: Vec<String>,
    pub followers: i64,
    pub following: i64,
    pub works: i64,
    pub blogs: i64,
    pub roles: Vec<Role>,
    pub created_at: DateTime<Utc>,
}