use leptos::*;
use leptos_icons::*;
use leptos_router::*;
use icondata_ri as remixicon;
use garde::Validate;
use serde::{Deserialize, Serialize};
use thiserror::Error;
use crate::client::ui::forms::{TextField, TextFieldType};
use crate::client::pages::auth::log_in::LogInError;

#[derive(Debug, Clone, Serialize, Deserialize, Validate)]
pub struct ProfileForm {
    #[garde(length(min=3, max=48))]
    pub username: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, Error)]
pub enum CreateProfileError {
    #[error("This username is already taken.")]
    UsernameTaken,
    #[error("An unknown error has occurred.")]
    ServerError,
}

#[server]
pub async fn create_profile_submit(form_info: ProfileForm) -> Result<(), ServerFnError> {
    todo!()
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
                    Ok(()) => LogInError::ServerError.to_string(),
                    Err(e) => e.to_string().split_off(30),
                }
            },
            None => LogInError::ServerError.to_string(),
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
            </ActionForm>
        </div>
    }
}