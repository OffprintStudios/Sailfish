use leptos::*;
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
        Some(acc) => acc,
        None => {
            leptos_axum::redirect("/");
            return Err(ServerFnError::new(LoadProfileError::AuthFail));
        }
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

    let (profiles, _) = create_signal::<Vec<ProfileModel>>(vec![]);

    let profiles_data = create_blocking_resource(profiles, |_| async move {
        load_profiles().await
    });

    view! {
        <MetaTags options=meta_options />

        <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
            <Suspense
                fallback=move || view! { <p>Loading</p> }
            >
                <div class="flex flex-col items-center justify-center pb-4">
                    <h1 class="text-3xl">"Select a Profile"</h1>
                    <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
                        "Who's gonna be with us today?"
                    </span>
                    <div>
                    {move || match profiles_data.get() {
                        Some(v) => {
                            match v {
                                Ok(p) => format!("{}", p.len()),
                                Err(e) => e.to_string()
                            }
                        },
                        None => "Nothing found".to_string()
                    }}
                    </div>
                </div>
                <div class="flex items-center justify-center w-full">
                    <div>"hello"</div>
                    <div>"hello"</div>
                    <div>"hello"</div>
                </div>
            </Suspense>
        </div>
    }
}