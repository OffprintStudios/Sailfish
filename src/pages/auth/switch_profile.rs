use codee::string::JsonSerdeCodec;
use leptos::prelude::*;
use leptos::either::Either;
use leptos_router::hooks::use_navigate;
use leptos_router::components::A;
use leptos_use::storage::use_local_storage;
use leptos_icons::*;
use icondata as TablerIcon;
use crate::models::accounts::Profile;
use crate::store::auth_store::AuthStore;
use crate::ui::misc::MetaTags;
use crate::errors::{AppError, ErrorTemplate};

#[server(prefix = "/api/account/profiles", endpoint = "all")]
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

#[component]
pub fn SwitchProfilePage() -> impl IntoView {
    let load_profiles = Resource::new(|| (), |_| load_profiles());
    let (_, set_auth, _) = use_local_storage::<AuthStore, JsonSerdeCodec>("auth");
    let count = RwSignal::<usize>::new(0);

    let profiles = move || {
        Suspend::new(async move {
            load_profiles
                .await
                .map(|profiles| {
                    count.set(profiles.len());
                    set_auth.update(|auth| {
                        auth.profiles = profiles.clone();
                    });

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
                                            class="flex flex-col items-center rounded-xl p-4 mx-2 w-[180px] h-[210px] hover:bg-zinc-300 dark:hover:bg-zinc-600 transition"
                                            on:click=move |_| {
                                                let navigate = use_navigate();
                                                set_auth.update(|auth| {
                                                    auth.current_profile = Some(p.clone());
                                                });
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
                    <h1 class="text-3xl">"Select a Profile"</h1>
                    <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold font-header">
                        "Who's gonna be with us today?"
                    </span>
                </div>
                <div class="flex items-center justify-center w-full">
                    {profiles}
                    <Show
                        when=move || count() < 3
                    >
                        <A
                            attr:class="flex flex-col items-center rounded-xl p-4 mx-2 w-[180px] h-[210px] hover:bg-zinc-300 dark:hover:bg-zinc-600 transition"
                            href="/create-profile"
                        >
                            <div class="flex flex-col items-center justify-center w-[125px] h-[125px] rounded-full border-2 border-dotted">
                                <Icon icon=TablerIcon::TbUserPlus width="48px" height="48px" />
                            </div>
                            <span class="pt-3 all-small-caps font-bold text-2xl">
                                "Add New"
                            </span>
                        </A>
                    </Show>
                </div>
            </div>
        </ErrorBoundary>
    }
}
