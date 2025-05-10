use leptos::prelude::*;
use crate::errors::AppError;

#[server(prefix = "/api/auth", endpoint = "validate")]
pub async fn validate() -> Result<(), AppError> {
    use crate::state::AppState;
    use crate::models::accounts::Session;

    let state = expect_context::<AppState>();

    match Session::authorize(&state.db).await {
        Some(_) => Ok(()),
        None => Err(AppError::Unauthorized),
    }
}