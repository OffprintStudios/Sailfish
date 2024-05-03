use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub enum Roles {
    Admin,
    Moderator,
    ChatModerator,
    WorkApprover,
    Contributor,
    User,
}