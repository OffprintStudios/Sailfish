use serde::{Serialize, Deserialize};
use strum::Display;

#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq, Eq, PartialOrd, Ord, Display)]
#[cfg_attr(feature = "ssr", derive(sqlx::Type))]
pub enum Role {
    Admin,
    Moderator,
    ChatModerator,
    WorkApprover,
    Contributor,
    User,
}

impl Role {
    /// Translates enum item into its respective, *themed* counterpart
    pub fn into_themed(&self) -> String {
        match self {
            Role::Admin => "Bartender",
            Role::Moderator => "Barback",
            Role::ChatModerator => "Bouncer",
            Role::WorkApprover => "Server",
            Role::Contributor => "Comrade",
            Role::User => "Patron",
        }.into()
    }
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