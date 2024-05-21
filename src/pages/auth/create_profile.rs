use garde::Validate;
use leptos::*;
use leptos_router::*;
use serde::{Deserialize, Serialize};
use crate::error_template::{ErrorTemplate, SailfishError};
use crate::ui::util::{MetaTags, MetaTagOptions};
use crate::ui::forms::{TextField, TextFieldType, TextArea};

#[derive(Debug, Clone, Serialize, Deserialize, Validate)]
pub struct CreateProfileForm {
    #[garde(alphanumeric, length(min=3, max=36))]
    username: String,
    #[garde(ascii, length(min=3, max=240))]
    bio: Option<String>,
}

#[server]
pub async fn verify_access() -> Result<(), ServerFnError<SailfishError>> {
    use crate::sailfish::SailfishState;
    use crate::util::auth::authorize;
    
    let state = expect_context::<SailfishState>();

    match authorize(&state.db).await {
        Some(_) => Ok(()),
        None => Err(ServerFnError::WrappedServerError(SailfishError::Unauthorized))
    }
}

#[server]
pub async fn create_profile_submit(form_info: CreateProfileForm) -> Result<(), ServerFnError> {
    todo!()
}

#[component]
pub fn CreateProfile() -> impl IntoView {
    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/create-profile".to_string(),
        title: "Create Profile — Offprint".to_string(),
        author_url: None,
        description: "Let's add a new member of the family".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };
    
    view! {
        <MetaTags options=meta_options />
        
        <Await
            future=verify_access
            blocking=true
            children=|auth| {
                let auth = auth.clone();
                let submit = Action::<CreateProfileSubmit, _>::server();
            
                view! {
                    <ErrorBoundary
                        fallback=move |errors| {
                            view! {
                                <ErrorTemplate outside_errors=errors.get() />
                            }
                        }
                    >
                        {auth.map(|_| {
                            view! {
                                <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
                                    <div class="flex flex-col items-center justify-center pb-4">
                                        <h1 class="text-3xl">"Create a Profile"</h1>
                                        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
                                            "Let's make your new persona."
                                        </span>
                                    </div>
                                    <ActionForm class="flex flex-col w-full" action=submit>
                                        <TextField
                                            name="form_info[username]".to_string()
                                            label="Email Address".to_string()
                                            kind=TextFieldType::Text
                                            placeholder="Somebody New".to_string()
                                            autocomplete="username".to_string()
                                            required=true
                                        />
                                        <div class="my-1.5"></div>
                                    </ActionForm>
                                </div>
                            }
                        })}
                    </ErrorBoundary>
                }
            }
        />
    }
}