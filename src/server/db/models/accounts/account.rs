use serde::{Serialize, Deserialize};
use chrono::{DateTime, Utc};

#[derive(Debug, Deserialize)]
pub struct Account {
    pub id: String,
    pub email: String,
    pub password: String,
    pub terms_agree: bool,
    pub email_confirmed: bool,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>
}

#[derive(Serialize)]
pub struct AccountForm {
    pub email: String,
    pub password: String,
    pub terms_agree: bool,
}