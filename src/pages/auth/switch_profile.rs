use codee::string::JsonSerdeCodec;
use leptos::prelude::*;
use leptos::either::Either;
use leptos_router::hooks::use_navigate;
use leptos_use::storage::use_local_storage;
use leptos_icons::*;
use icondata as TablerIcon;
use serde::{Serialize, Deserialize};
use thiserror::Error;
use crate::models::accounts::Profile;
use crate::store::auth_store::AuthStore;
use crate::ui::forms::TextField;
use crate::ui::misc::{MetaTags, Button, ButtonType, ButtonKind};
use crate::errors::{AppError, ErrorTemplate};

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

#[server(endpoint = "/account/profiles")]
pub async fn load_profiles() -> Result<Vec<Profile>, ServerFnError<AppError>> {
    use crate::state::AppState;
    use crate::models::accounts::Session;

    let state = expect_context::<AppState>();
    let account = match Session::authorize(&state.db).await {
        Some(account) => account,
        None => return Err(ServerFnError::WrappedServerError(AppError::Unauthorized))
    };

    let profiles = match Profile::fetch_owned(account.id, &state.db).await {
        Ok(profiles) => profiles,
        Err(_) => return Err(ServerFnError::WrappedServerError(AppError::ServerError))
    };

    Ok(profiles)
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
pub fn SwitchProfilePage() -> impl IntoView {
    let load_profiles = Resource::new(|| (), |_| load_profiles());
    let (_, set_auth, _) = use_local_storage::<AuthStore, JsonSerdeCodec>("auth");
    let count = RwSignal::<usize>::new(0);
    let show_form = RwSignal::new(false);

    let profiles = move || {
        Suspend::new(async move {
            load_profiles
                .await
                .map(|profiles| {
                    count.set(profiles.len());

                    if profiles.is_empty() {
                        Either::Left(view! {
                            <span></span>
                        })
                    } else {
                        Either::Right(
                            profiles
                                .iter()
                                .map(move |profile| {
                                    let p = profile.clone();

                                    view! {
                                        <button
                                            class="flex flex-col items-center rounded-xl p-4 mx-2 w-[180px] h-[210px] hover:bg-zinc-300 dark:bg-zinc-600 transition"
                                            on:click=move |_| {
                                                let navigate = use_navigate();
                                                set_auth(AuthStore { current_profile: Some(p.clone()) });
                                                navigate("/", Default::default());
                                            }
                                        >
                                            <img class="rounded-full border-2 object-cover w-[125px] h-[125px]" src=profile.avatar.clone() alt=format!("{}'s Avatar", profile.username.clone()) />
                                            <span class="pt-3 all-small-caps font-bold text-2xl truncate max-w-[120px]">
                                                {profile.username.clone()}
                                            </span>
                                        </button>
                                    }
                                })
                                .collect::<Vec<_>>()
                        )
                    }
                })
        })
    };

    view! {
        <MetaTags
            url="https://offprint.cafe/switch-profile"
            title="Switch Profile — Offprint"
            description="For The Stories Left Untold"
            image_url="/images/beatriz.png"
        />

        <ErrorBoundary fallback=move |errors| view! { <ErrorTemplate errors /> }.into_view()>
            <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
                <div class="flex flex-col items-center justify-center pb-4">
                    <Show
                        when=move || !show_form()
                        fallback=move || view! {
                            <h1 class="text-3xl">"Create a Profile"</h1>
                            <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold font-header">
                                "Put a name to a face"
                            </span>
                        }
                    >
                        <h1 class="text-3xl">"Select a Profile"</h1>
                        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold font-header">
                            "Who's gonna be with us today?"
                        </span>
                    </Show>
                </div>
                <div class="flex items-center justify-center w-full">
                    <Show 
                        when=move || !show_form()
                        fallback=move || view! { <CreateProfileForm /> }
                    >
                        {profiles}
                        <Show
                            when=move || count() < 3
                        >
                            <button
                                class="flex flex-col items-center rounded-xl p-4 mx-2 w-[180px] h-[210px] hover:bg-zinc-300 dark:hover:bg-zinc-600 transition"
                                on:click=move |_| show_form.update(|v| *v = true)
                            >
                                <div class="flex flex-col items-center justify-center w-[125px] h-[125px] rounded-full border-2 border-dotted">
                                    <Icon icon=TablerIcon::TbUserPlus width="48px" height="48px" />
                                </div>
                                <span class="pt-3 all-small-caps font-bold text-2xl">
                                    "Add New"
                                </span>
                            </button>
                        </Show>
                    </Show>
                </div>
            </div>
        </ErrorBoundary>
    }
}

#[component]
pub fn CreateProfileForm() -> impl IntoView {
    let submit_form = ServerAction::<CreateProfile>::new();

    view! {
        <ActionForm attr:class="flex flex-col w-full" action=submit_form>
            <div class="flex items-center justify-center w-full mb-4">
                <img src="https://images.offprint.net/avatars/avatar.png" class="w-[150px] h-[150px] rounded-full object-cover" />
            </div>
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
            <Button
                id="cancel-button"
                title="Cancel"
                type_of=ButtonType::Default
                kind=ButtonKind::Normal
                full_width=true
            >
                <span class="button-icon"><Icon icon=TablerIcon::TbSquareX /></span>
                <span class="button-text">"Cancel"</span>
            </Button>
        </ActionForm>
    }
}