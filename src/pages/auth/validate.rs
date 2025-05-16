use leptos::prelude::*;
use crate::errors::AppError;

#[server(prefix = "/api/auth", endpoint = "validate")]
pub async fn validate() -> Result<(), AppError> {
    use crate::state::AppState;
    use crate::models::accounts::{Session, Role};

    let state = expect_context::<AppState>();

    match Session::authorize(vec![Role::User], &state.db).await {
        Some(_) => Ok(()),
        None => Err(AppError::Unauthorized),
    }
}

#[server(prefix = "/api/auth", endpoint = "validate-approver")]
pub async fn validate_approver() -> Result<(), AppError> {
    use crate::state::AppState;
    use crate::models::accounts::{Session, Role};

    let state = expect_context::<AppState>();

    match Session::authorize(vec![Role::Admin, Role::Moderator, Role::WorkApprover], &state.db).await {
        Some(_) => Ok(()),
        None => Err(AppError::Forbidden),
    }
}

#[server(prefix = "/api/auth", endpoint = "validate-moderator")]
pub async fn validate_moderator() -> Result<(), AppError> {
    use crate::state::AppState;
    use crate::models::accounts::{Session, Role};

    let state = expect_context::<AppState>();

    match Session::authorize(vec![Role::Admin, Role::Moderator], &state.db).await {
        Some(_) => Ok(()),
        None => Err(AppError::Forbidden),
    }
}

#[server(prefix = "/api/auth", endpoint = "validate-admin")]
pub async fn validate_admin() -> Result<(), AppError> {
    use crate::state::AppState;
    use crate::models::accounts::{Session, Role};

    let state = expect_context::<AppState>();

    match Session::authorize(vec![Role::Admin], &state.db).await {
        Some(_) => Ok(()),
        None => Err(AppError::Forbidden)
    }
}