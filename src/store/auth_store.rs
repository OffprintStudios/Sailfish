use serde::{Serialize, Deserialize};
use crate::models::accounts::ProfileObject;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Default)]
pub struct AuthStore {
    pub profiles: Vec<ProfileObject>,
    pub current_profile: Option<ProfileObject>,
}