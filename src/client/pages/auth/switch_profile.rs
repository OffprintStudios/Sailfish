use leptos::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use serde::{Serialize, Deserialize};
use thiserror::Error;
use crate::client::models::accounts::ProfileModel;
use crate::client::ui::util::{MetaTags, MetaTagOptions};

cfg_if::cfg_if! {
    if #[cfg(feature = "ssr")] {
        use leptos_axum::extract;
        use tower_cookies::Cookies;
        use crate::server::api::auth::authorize;
        use crate::server::db::accounts::Profile;
        use crate::server::util::constants::KEY;
        use crate::server::util::state::SailfishState;
    }
}

#[derive(Debug, Clone, Serialize, Deserialize, Error)]
pub enum LoadProfileError {
    #[error("You don't have permission to view this page.")]
    AuthFail,
    #[error("Something went wrong attempting to fetch your profiles.")]
    FetchFail,
}

#[server]
pub async fn load_profiles() -> Result<Vec<ProfileModel>, ServerFnError> {
    let key = KEY.get().unwrap();
    let state = expect_context::<SailfishState>();
    let cookies = extract::<Cookies>().await?.private(key);
    
    let account = match authorize(cookies, &state.db).await {
        Ok(acc) => acc,
        Err(_) => return Err(ServerFnError::new(LoadProfileError::AuthFail))
    };
    
    let profiles = match Profile::fetch_owned(account.id, &state.db).await {
        Ok(prof) => prof,
        Err(_) => return Err(ServerFnError::new(LoadProfileError::FetchFail))
    };
    
    let mut profile_models = Vec::new();
    for profile in profiles {
        profile_models.push(ProfileModel::from(profile));
    }
    
    Ok(profile_models)
}

#[component]
pub fn SwitchProfile() -> impl IntoView {
    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/switch-profile".to_string(),
        title: "Switch Profile — Offprint".to_string(),
        author_url: None,
        description: "For The Stories Left Untold".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };

    view! {
        <MetaTags options=meta_options />

        <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
            <Await future=load_profiles let:data>
                <ErrorBoundary fallback=move |errors| {
                    view! {
                        <div class="text-sm flex flex-col bg-red-600/25 border border-red-600/75 rounded-xl p-4 mb-4">
                            <div class="flex items-center mb-1">
                                <span class="mr-1"><Icon icon=remixicon::RiInformationSystemLine width="20px" height="20px" /></span>
                                <span class="font-bold">"Head's Up!"</span>
                            </div>
                            <span>
                                {move || errors.get()
                                    .into_iter()
                                    .map(|(_, e)| view! { <li>{e.to_string()}</li> })
                                    .collect_view()
                                }
                            </span>
                        </div>
                    }       
                }>
                    <div class="flex flex-col items-center justify-center pb-4">
                        <h1 class="text-3xl">"Select a Profile"</h1>
                        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
                            "Who's gonna be with us today?"
                        </span>
                    </div>
                    <div class="flex items-center justify-center w-full">
                        <div>"hello"</div>
                        <div>"hello"</div>
                        <div>"hello"</div>
                    </div>
                </ErrorBoundary>
            </Await>
        </div>
    }
}