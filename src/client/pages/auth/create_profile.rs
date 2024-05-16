use leptos::*;
use leptos_icons::*;
use leptos_router::*;
use icondata_ri as remixicon;
use garde::Validate;
use serde::{Deserialize, Serialize};
use thiserror::Error;
use crate::client::ui::forms::{TextField, TextFieldType, TextArea};

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

#[derive(Debug, Clone, Serialize, Deserialize, Validate)]
pub struct ProfileForm {
    #[garde(length(min=3, max=48))]
    pub username: String,
    #[garde(length(max=240))]
    pub bio: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Error)]
pub enum CreateProfileError {
    #[error("You don't have permission to view this page.")]
    AuthFail,
    #[error("This username is already taken.")]
    UsernameTaken,
    #[error("An unknown error has occurred.")]
    ServerError,
}

#[server]
pub async fn create_profile_submit(form_info: ProfileForm) -> Result<(), ServerFnError> {
    let key = KEY.get().unwrap();
    let state = expect_context::<SailfishState>();
    let cookies = extract::<Cookies>().await?.private(key);
    
    let account = match authorize(cookies, &state.db).await {
        Some(account) => account,
        None => {
            leptos_axum::redirect("/");
            return Err(ServerFnError::new(CreateProfileError::AuthFail));
        }
    };
    
    let fresh_username = match Profile::is_username_taken(form_info.username.clone(), &state.db).await {
        Ok(v) => !v,
        Err(_) => return Err(ServerFnError::new(CreateProfileError::ServerError))
    };
    
    if !fresh_username {
        return Err(ServerFnError::new(CreateProfileError::UsernameTaken));
    }
    
    match Profile::new(account.id, form_info.username, form_info.bio, &state.db).await {
        Ok(_) => {
            leptos_axum::redirect("/switch-profile");
            Ok(())
        },
        Err(_) => Err(ServerFnError::new(CreateProfileError::ServerError))
    }
}

#[component]
pub fn CreateProfile() -> impl IntoView {
    let submit = Action::<CreateProfileSubmit, _>::server();
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
        <div class="flex flex-col items-center justify-center md:justify-normal bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit relative" style="box-shadow: var(--dropshadow);">
            <div class="flex flex-col items-center justify-center pb-4">
                <h1 class="text-3xl">"Create a Profile"</h1>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
                    "Let's make a whole new you"
                </span>
            </div>
            <Show when=has_error>
                <div class="text-sm flex flex-col bg-red-600/25 border border-red-600/75 rounded-xl p-4 mb-4">
                    <div class="flex items-center mb-1">
                        <span class="mr-1"><Icon icon=remixicon::RiInformationSystemLine width="20px" height="20px" /></span>
                        <span class="font-bold">"Head's Up!"</span>
                    </div>
                    <span>{error()}</span>
                </div>
            </Show>
            <ActionForm class="flex flex-col w-full" action=submit>
                <TextField
                    name="form_info[username]".to_string()
                    label="Username".to_string()
                    kind=TextFieldType::Text
                    placeholder="SomeoneSpecial".to_string()
                    autocomplete="username".to_string()
                    required=true
                />
                <div class="my-1.5" />
                <TextArea
                    name="form_info[bio]".to_string()
                    label="Bio (Optional)".to_string()
                    placeholder="Just Another Friendly Face In The Crowd".to_string()
                />
            </ActionForm>
        </div>
    }
}