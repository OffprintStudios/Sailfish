use serde::{Serialize, Deserialize};
use sqlx::Error as SqlxError;
use argon2::password_hash::Error as HashError;
use leptos::ServerFnError;
use tokio::task::JoinError;

#[derive(Debug, Serialize, Deserialize)]
pub struct ApiError {
    pub code: u16,
    pub name: String,
    pub message: Option<String>,
}

impl ApiError {
    pub fn create(code: u16, name: String, message: Option<String>) -> Self {
        ApiError {
            code,
            name,
            message,
        }
    }

    pub fn internal_server_error(message: Option<String>) -> Self {
        Self::create(500, String::from("Internal Server Error"), message)
    }

    pub fn unauthorized(message: Option<String>) -> Self {
        Self::create(401, String::from("Unauthorized"), message)
    }

    pub fn not_found(message: Option<String>) -> Self {
        Self::create(404, String::from("Not Found"), message)
    }
}

impl From<SqlxError> for ApiError {
    fn from(_: SqlxError) -> Self {
        Self::internal_server_error(None)
    }
}

impl From<HashError> for ApiError {
    fn from(_: HashError) -> Self {
        Self::internal_server_error(None)
    }
}

impl From<JoinError> for ApiError {
    fn from(_: JoinError) -> Self {
        Self::internal_server_error(None)
    }
}

impl From<ApiError> for ServerFnError {
    fn from(value: ApiError) -> Self {
        ServerFnError::new(value.name)
    }
}
