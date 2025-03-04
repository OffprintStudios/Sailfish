use serde::{Serialize, Deserialize};
use strum::Display;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Display)]
#[cfg_attr(feature = "ssr", derive(sqlx::Type))]
pub enum Role {
    Admin,
    Moderator,
    ChatModerator,
    WorkApprover,
    Contributor,
    User,
}

impl From<String> for Role {
    fn from(value: String) -> Self {
        match value.as_str() {
            "Admin" => Role::Admin,
            "Moderator" => Role::Moderator,
            "ChatModerator" => Role::ChatModerator,
            "WorkApprover" => Role::WorkApprover,
            "Contributor" => Role::Contributor,
            "User" => Role::User,
            _ => Role::User,
        }
    }
}