use serde::{Serialize, Deserialize};
use uuid::Uuid;
use crate::client::models::accounts::ProfileModel;

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize, Default)]
pub struct AuthState {
    pub account_id: Option<Uuid>,
    pub profiles: Vec<ProfileModel>,
    pub curr_profile: Option<ProfileModel>,
}