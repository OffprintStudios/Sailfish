use chrono::{DateTime, Utc};
use serde::{Serialize, Deserialize};
use strum::Display;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[cfg_attr(feature = "ssr", derive(sqlx::FromRow))]
pub struct Tag {
    pub id: String,
    pub name: String,
    pub desc: Option<String>,
    pub parent_id: Option<String>,
    pub kind: TagKind,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq, PartialOrd, Ord, Display)]
#[cfg_attr(feature = "ssr", derive(sqlx::Type))]
pub enum TagKind {
    Fandom,
    Event,
    Warning,
    Genre,
    Form,
    User,
}

impl From<String> for TagKind {
    fn from(value: String) -> Self {
        match value.as_str() {
            "Fandom" => Self::Fandom,
            "Event" => Self::Event,
            "Warning" => Self::Warning,
            "Genre" => Self::Genre,
            "Form" => Self::Form,
            "User" => Self::User,
            _ => Self::User,
        }
    }
}

impl Tag {
    #[cfg(feature = "ssr")]
    pub async fn new(name: String, desc: Option<String>, kind: TagKind, db: &sqlx::PgPool) -> Result<Self, crate::errors::AppError> {
        let clean_name = ammonia::clean(&name);
        let clean_desc = desc.map(|desc| ammonia::clean(&desc));

        let result: Self = sqlx::query_as!(
            Self,
            r#"
                INSERT INTO tags (name, "desc", kind) VALUES ($1, $2, $3) RETURNING *;
            "#,
            clean_name,
            clean_desc,
            kind.to_string(),
        ).fetch_one(db).await?;

        Ok(result)
    }

    #[cfg(feature = "ssr")]
    pub async fn new_child(&self, child_name: String, child_desc: Option<String>, db: &sqlx::PgPool) -> Result<Self, crate::errors::AppError> {
        let clean_name = ammonia::clean(&child_name);
        let clean_desc = child_desc.map(|desc| ammonia::clean(&desc));

        let result: Self = sqlx::query_as!(
            Self,
            r#"
                INSERT INTO tags (name, "desc", parent_id, kind) VALUES ($1, $2, $3, $4) RETURNING *;
            "#,
            clean_name,
            clean_desc,
            self.id,
            self.kind.to_string()
        ).fetch_one(db).await?;

        Ok(result)
    }

    #[cfg(feature = "ssr")]
    pub async fn fetch_tags(kind: TagKind, page: i64, per: i64,  db: &sqlx::PgPool) -> Result<Vec<Self>, crate::errors::AppError> {
        let result = sqlx::query_as!(
            Self,
            r#"
                SELECT * FROM tags WHERE kind = $1 ORDER BY created_at DESC OFFSET $2 LIMIT $3;
            "#,
            kind.to_string(),
            per * (page - 1),
            per
        ).fetch_all(db).await?;

        Ok(result)
    }
}