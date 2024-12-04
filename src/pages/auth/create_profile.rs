use leptos::prelude::*;
use thiserror::Error;
use serde::{Serialize, Deserialize};
use crate::ui::misc::MetaTags;

#[derive(Debug, Clone, Serialize, Deserialize, Error)]
pub enum CreateProfileError {
    #[error("Whoops! Looks like this username is already being used.")]
    UsernameTaken,
    #[error("Sorry, but usernames have to be between 3 and 36 characters long.")]
    UsernameInvalidLength,
    #[error("Sorry, but your bio must be between 3 and 240 characters long.")]
    BioInvalidLength,
    #[error("Wait a minute, you can't be here!")]
    AuthFail,
    #[error("Uh-oh. Seems like something on our end messed up.")]
    ServerError,
}

#[server(CreateProfile, "/api/account/profiles/new")]
pub async fn create_profile(username: String, bio: Option<String>) -> Result<(), ServerFnError> {
    use crate::state::AppState;
    use crate::models::accounts::{Session, Profile};

    let state = expect_context::<AppState>();

    let account = match Session::authorize(&state.db).await {
        Some(account) => account,
        None => return Err(ServerFnError::new(CreateProfileError::AuthFail))
    };

    if username.chars().count() < 3 || username.chars().count() > 36 {
        return Err(ServerFnError::new(CreateProfileError::UsernameInvalidLength));
    }

    if Profile::fetch_by_username(username.clone(), &state.db).await.is_some() {
        return Err(ServerFnError::new(CreateProfileError::UsernameTaken));
    }

    if let Some(bio) = bio.clone() {
        if bio.chars().count() < 3 || bio.chars().count() > 240 {
            return Err(ServerFnError::new(CreateProfileError::BioInvalidLength));
        }
    }

    match Profile::new(account.id, username, bio, &state.db).await {
        Ok(_) => {
            leptos_axum::redirect("/switch-profile");
            Ok(())
        },
        Err(_) => Err(ServerFnError::new(CreateProfileError::ServerError))
    }
}

#[component]
pub fn CreateProfilePage() -> impl IntoView {
    view! {
        <MetaTags
            url="https://offprint.cafe/create-profile"
            title="Create A Profile — Offprint"
            description="For The Stories Left Untold"
            image_url="/images/beatriz.png"
        />

        <div>"hi"</div>
    }
}