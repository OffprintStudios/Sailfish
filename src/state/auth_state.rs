use serde::{Deserialize, Serialize};
use crate::models::accounts::Profile;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Default)]
pub struct AuthState {
    pub current_profile: Option<Profile>
}