use leptos::prelude::*;
use crate::errors::AppError;

#[server(endpoint = "/auth/validate")]
pub async fn validate() -> Result<bool, ServerFnError<AppError>> {
    use crate::state::AppState;
    use crate::models::accounts::Session;

    let state = expect_context::<AppState>();

    match Session::authorize(&state.db).await {
        Some(_) => Ok(true),
        None => Ok(false)
    }
}