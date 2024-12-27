use leptos::prelude::*;
use leptos_icons::*;
use icondata as TablerIcon;
use serde::{Serialize, Deserialize};
use thiserror::Error;
use crate::ui::forms::TextField;
use crate::ui::misc::{Button, ButtonKind, ButtonType, LinkBlock, LinkKind, MetaTags};

#[derive(Debug, Clone, Serialize, Deserialize, Error)]
pub enum CreateProfileError {
    #[error("Whoops! Looks like this username is already being used.")]
    UsernameTaken,
    #[error("Sorry, but usernames have to be between 3 and 36 characters long.")]
    UsernameInvalidLength,
    #[error("Wait a minute, you can't be here!")]
    AuthFail,
    #[error("Uh-oh. Seems like something on our end messed up.")]
    ServerError,
}

#[server(CreateProfile, "/api/account/profiles/new")]
pub async fn create_profile(username: String) -> Result<(), ServerFnError> {
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

    match Profile::new(account.id, username, None, &state.db).await {
        Ok(_) => {
            leptos_axum::redirect("/switch-profile");
            Ok(())
        },
        Err(_) => Err(ServerFnError::new(CreateProfileError::ServerError))
    }
}

#[component]
pub fn CreateProfilePage() -> impl IntoView {
    let submit = ServerAction::<CreateProfile>::new();
    let value = submit.value();
    let has_error = move || value.with(|val| matches!(val, Some(Err(_))));
    let error = move || value.with(|val| {
        let some = val.to_owned();
        match some {
            Some(v) => {
                match v {
                    Ok(()) => CreateProfileError::ServerError.to_string(),
                    Err(e) => e.to_string().split_off(30),
                }
            },
            None => CreateProfileError::ServerError.to_string(),
        }
    });

    view! {
        <MetaTags
            url="https://offprint.cafe/create-profile"
            title="Create Profile — Offprint"
            description="For The Stories Left Untold"
            image_url="/images/beatriz.png"
        />

        <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
            <div class="flex flex-col items-center justify-center">
                <h1 class="text-3xl">"Create a Profile"</h1>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold font-header">
                    "Put a name to a face"
                </span>
            </div>
            <div class="flex items-center justify-center w-full">
                <ActionForm attr:class="flex flex-col w-full" action=submit>
                    <div class="flex items-center justify-center w-full mb-4">
                        <img src="https://images.offprint.net/avatars/avatar.png" class="w-[150px] h-[150px] rounded-full object-cover" />
                    </div>
                    <Show when=has_error>
                        <div class="text-sm flex flex-col bg-red-600/25 border border-red-600/75 rounded-xl p-4 mb-4">
                            <div class="flex items-center mb-1">
                                <span class="mr-1"><Icon icon=TablerIcon::TbInfoCircle width="20px" height="20px" /></span>
                                <span class="font-bold">"Head's Up!"</span>
                            </div>
                            <span>{error()}</span>
                        </div>
                    </Show>
                    <TextField
                        name="username"
                        label="Username"
                        placeholder="Somebody New"
                        autocomplete="username"
                        required=true
                    />
                    <div class="my-3" />
                    <Button
                        id="create-profile-button"
                        title="Create Profile"
                        type_of=ButtonType::Submit
                        kind=ButtonKind::Primary
                        full_width=true
                    >
                        <span class="button-icon"><Icon icon=TablerIcon::TbUserPlus /></span>
                        <span class="button-text">"Create Profile"</span>
                    </Button>
                    <div class="my-1.5" />
                    <LinkBlock
                        id="cancel-button"
                        title="Cancel"
                        href="/switch-profile"
                        kind=LinkKind::Normal
                        full_width=true
                    >
                        <span class="button-icon"><Icon icon=TablerIcon::TbSquareX /></span>
                        <span class="button-text">"Cancel"</span>
                    </LinkBlock>
                </ActionForm>
            </div>
        </div>
    }
}