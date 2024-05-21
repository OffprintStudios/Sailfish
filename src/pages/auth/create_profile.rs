use garde::Validate;
use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use serde::{Deserialize, Serialize};
use crate::error_template::{ErrorTemplate};
use crate::ui::util::{MetaTags, MetaTagOptions, Button, KindOfButton, TypeOfButton};
use crate::ui::forms::{TextField, TextFieldType, TextArea};
use crate::util::auth::verify_access;

#[derive(Debug, Clone, Serialize, Deserialize, Validate)]
pub struct CreateProfileForm {
    #[garde(alphanumeric, length(min=3, max=36))]
    username: String,
    #[garde(ascii, length(min=3, max=240))]
    bio: Option<String>,
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
                                        <div class="flex items-center justify-center w-full mb-4">
                                            <img src="https://images.offprint.net/avatars/avatar.png" class="w-[150px] h-[150px] rounded-full object-cover" />
                                        </div>
                                        <TextField
                                            name="form_info[username]".to_string()
                                            label="Username".to_string()
                                            kind=TextFieldType::Text
                                            placeholder="Somebody New".to_string()
                                            autocomplete="username".to_string()
                                            required=true
                                        />
                                        <div class="my-1.5"></div>
                                        <TextArea
                                            name="form_info[bio]".to_string()
                                            label="Bio (Optional)".to_string()
                                            placeholder="Just Another Friendly Face In The Crowd".to_string()
                                        />
                                        <div class="my-3" />
                                        <Button
                                            id="create-profile-button".to_string()
                                            title="Create Profile".to_string()
                                            type_of=TypeOfButton::Submit
                                            kind=KindOfButton::Primary
                                            full_width=true
                                        >
                                            <span class="button-icon"><Icon icon=remixicon::RiUserAddUserFacesLine /></span>
                                            <span class="button-text">"Create Profile"</span>
                                        </Button>
                                        <div class="my-1.5" />
                                        <Button
                                            id="cancel-button".to_string()
                                            title="Cancel".to_string()
                                            type_of=TypeOfButton::Default
                                            kind=KindOfButton::Normal
                                            full_width=true
                                        >
                                            <span class="button-icon"><Icon icon=remixicon::RiCloseSystemLine /></span>
                                            <span class="button-text">"Cancel"</span>
                                        </Button>
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