use leptos::prelude::*;
use crate::errors::AppError;

#[server(endpoint = "/auth/validate")]
pub async fn validate() -> Result<Option<bool>, ServerFnError<AppError>> {
    use crate::state::AppState;
    use crate::models::accounts::Session;

    let state = expect_context::<AppState>();
    println!("hit!");

    match Session::authorize(&state.db).await {
        Some(_) => {
            println!("valid!");
            Ok(Some(true))
        },
        None => {
            println!("invalid!");
            Ok(Some(false))
        }
    }
}
