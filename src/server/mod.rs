use serde::{Deserialize, Serialize};
use sqlx::Error as SqlxError;
use argon2::password_hash::Error as Argon2Error;

pub mod db;
pub mod auth;
pub mod extractors;

#[derive(Debug, Serialize, Deserialize)]
pub struct SailfishError {
    pub code: u16,
    pub name: String,
    pub message: Option<String>,
}

impl SailfishError {
    fn create(code: u16, name: String, message: Option<String>) -> Self {
        SailfishError {
            code,
            name,
            message,
        }
    }
    
    fn internal_server_error(message: Option<String>) -> Self {
        Self::create(500, String::from("Internal Server Error"), message)
    }
    
    fn unauthorized(message: Option<String>) -> Self {
        Self::create(401, String::from("Unauthorized"), message)
    }
    
    fn not_found(message: Option<String>) -> Self {
        Self::create(404, String::from("Not Found"), message)
    }
}

impl From<SqlxError> for SailfishError {
    fn from(_: SqlxError) -> Self {
        Self::internal_server_error(None)
    }
}

impl From<Argon2Error> for SailfishError {
    fn from(_: Argon2Error) -> Self {
        Self::internal_server_error(None)
    }
}
