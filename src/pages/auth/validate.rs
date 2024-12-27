use leptos::prelude::*;
use crate::errors::AppError;

#[server(endpoint = "/auth/validate")]
pub async fn validate() -> Result<(), ServerFnError<AppError>> {
    use crate::state::AppState;
    use crate::models::accounts::Session;

    let state = expect_context::<AppState>();

    match Session::authorize(&state.db).await {
        Some(_) => Ok(()),
        None => Err(ServerFnError::WrappedServerError(AppError::Unauthorized))
    }
}
