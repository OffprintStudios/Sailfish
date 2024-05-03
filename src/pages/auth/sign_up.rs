use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use crate::ui::forms::{TextField, TextFieldType};
use crate::ui::util::{Button, KindOfButton, TypeOfButton};

#[server(SignUpForm)]
pub async fn sign_up(email: String, password: String, repeat_password: String, age_check: Option<String>, terms_agree: Option<String>) -> Result<(), ServerFnError> {
    /*use argon2::Argon2;
    use argon2::password_hash::{rand_core::OsRng, PasswordHasher, SaltString};
    use sea_orm::ActiveValue::Set;
    use sea_orm::ActiveModelTrait;
    use sea_orm::ActiveEnum;
    use crate::state::AppState;
    use crate::server::db::entities::*;

    if password != repeat_password {
        return Err(ServerFnError::ServerError("Your passwords don't match!".to_string()));
    }

    if age_check.is_some_and(|val| val != "on") {
        // WHY IS THE CHECKBOX VALUE "ON" OR "OFF" I DON'T UNDERSTAND JUST USE A FUCKING BOOLEAN
        return Err(ServerFnError::ServerError("You must be 13 years of age or older to access Offprint.".to_string()));
    }

    if terms_agree.is_some_and(|val| val != "on") {
        return Err(ServerFnError::ServerError("You must agree to the Terms of Service, Privacy Policy, and Offprint Constitution before joining.".to_string()));
    }

    let state = expect_context::<AppState>();
    let argon2 = Argon2::default();
    let salt = SaltString::generate(&mut OsRng);
    let password_hash = match argon2.hash_password(password.as_bytes(), &salt) {
        Ok(hash) => hash.to_string(),
        Err(_) => return Err(ServerFnError::ServerError("Unable to hash password!".to_string()))
    };

    let account = account::ActiveModel {
        email: Set(email.to_owned()),
        password: Set(password_hash.to_owned()),
        roles: Set(vec![roles::Roles::User.to_value()]),
        terms_agree: Set(true),
        email_confirmed: Set(false),
        ..Default::default()
    };

    let _result = account.insert(&state.database).await?;*/

    Ok(())
}

#[component]
pub fn SignUp() -> impl IntoView {
    let sign_up = create_server_action::<SignUpForm>();
    let value = sign_up.value();
    let _has_error = move || value.with(|val| matches!(val, Some(Err(_))));

    view! {
        <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll scrollbar-none" style="box-shadow: var(--dropshadow);">
            <div class="flex flex-col items-center justify-center pb-4">
                <h1 class="text-3xl">Welcome to Offprint!</h1>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center" style="font-family: var(--header-text);">
                    "Let's get started, shall we?"
                </span>
            </div>
            <ActionForm class="flex flex-col" action=sign_up>
                <TextField
                    name="email".to_string()
                    label="Email Address".to_string()
                    kind=TextFieldType::Email
                    placeholder="somebody@example.net".to_string()
                    autocomplete="email".to_string()
                    required=true
                />
                <div class="my-1"></div>
                <TextField
                    name="password".to_string()
                    label="Password".to_string()
                    kind=TextFieldType::Password
                    placeholder="••••••••••".to_string()
                    autocomplete="new-password".to_string()
                    required=true
                />
                <div class="my-1"></div>
                <TextField
                    name="repeat_password".to_string()
                    label="Repeat Password".to_string()
                    kind=TextFieldType::Password
                    placeholder="••••••••••".to_string()
                    autocomplete="new-password".to_string()
                    required=true
                />
                <label class="flex mt-4 mb-2">
                    <input
                        id="age-check"
                        name="age_check"
                        type="checkbox"
                        required
                        class="rounded bg-zinc-500 w-[18px] h-[18px] relative top-[0.075rem] border-0 mr-2 transition checked:bg-blue-500/75"
                    />
                    <span class="text-sm align-top select-none">I am 13 years of age or older</span>
                </label>
                <label class="flex mt-2 mb-4">
                    <input
                        id="terms-agree"
                        name="terms_agree"
                        type="checkbox"
                        required
                        class="rounded bg-zinc-500 w-[18px] h-[18px] relative top-[0.075rem] border-0 mr-2 transition checked:bg-blue-500/75"
                    />
                    <span class="text-sm align-top select-none">
                        I agree to the <A class="text-accent hover:underline" href="/docs/terms-of-service">Terms of Service</A>, <A class="text-accent hover:underline" href="/docs/privacy-policy">Privacy Policy</A>, and <A class="text-accent hover:underline" href="/docs/constitution">Offprint Constitution</A>
                    </span>
                </label>
                <Button
                    id="sign-up-button".to_string()
                    title="Sign Up".to_string()
                    type_of=TypeOfButton::Submit
                    kind=KindOfButton::Primary
                    full_width=true
                >
                    <span class="button-icon"><Icon icon=remixicon::RiUserAddUserFacesLine /></span>
                    <span class="button-text">"Sign Up"</span>
                </Button>
                <A class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/auth/log-in">
                    "Already have an account?"
                </A>
            </ActionForm>
        </div>
    }
}