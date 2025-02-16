use serde::{Serialize, Deserialize};
use crate::models::accounts::Profile;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Default)]
pub struct AuthStore {
    pub profiles: Vec<Profile>,
    pub current_profile: Option<Profile>,
}