use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[cfg(feature = "ssr")]
use crate::server::db::accounts::Profile;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct ProfileModel {
    pub id: String,
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

#[cfg(feature = "ssr")]
impl From<Profile> for ProfileModel {
    fn from(value: Profile) -> Self {
        Self {
            id: value.id,
            username: value.username,
            avatar: value.avatar,
            banner_art: value.banner_art,
            bio: value.bio,
            tagline: value.tagline,
            links: value.links,
            presence: value.presence,
            created_at: value.created_at,
            updated_at: value.updated_at,
        }
    }
}