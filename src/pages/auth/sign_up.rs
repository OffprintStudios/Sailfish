use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use serde::{Deserialize, Serialize};
use garde::Validate;
use thiserror::Error;
use crate::ui::forms::{TextField, TextFieldType};
use crate::ui::util::{Button, MetaTags, MetaTagOptions, KindOfButton, TypeOfButton};

#[derive(Debug, Clone, Serialize, Deserialize, Validate)]
pub struct SignUpForm {
    #[garde(email)]
    email: String,
    #[garde(ascii, length(min=3))]
    password: String,
    #[garde(ascii, length(min=3))]
    repeat_password: String,
    #[garde(required, ascii, length(min=1))]
    age_check: Option<String>,
    #[garde(required, ascii, length(min=1))]
    terms_agree: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize, Error)]
pub enum SignUpError {
    #[error("That's not a valid email address!")]
    InvalidEmail,
    #[error("Your passwords don't match! Check to make sure you've entered them correctly.")]
    PasswordsDontMatch,
    #[error("You must be 13 years of age or older to join Offprint.")]
    AgeCheckFail,
    #[error("You must agree to the Terms of Service, Privacy Policy, and Offprint Constitution before joining Offprint.")]
    TermsAgreeFail,
    #[error("An account with this email address already exists!")]
    Conflict,
    #[error("Uh-oh. Seems like something on our end messed up.")]
    ServerError,
}

#[server]
pub async fn sign_up_submit(form_info: SignUpForm) -> Result<(), ServerFnError> {
    use chrono::{Utc, Duration};
    use leptos_axum::extract;
    use axum::Extension;
    use apalis::prelude::*;
    use apalis::redis::RedisStorage;
    use crate::sailfish::SailfishState;
    // use crate::util::mail::send_confirmation;
    use crate::models::accounts::{Account, ConfirmationCode};
    use crate::models::util::{Email, EmailKind};
    
    if form_info.password != form_info.repeat_password {
        return Err(ServerFnError::new(SignUpError::PasswordsDontMatch));
    }

    if form_info.age_check.is_some_and(|val| val != "on") {
        // WHY IS THE CHECKBOX VALUE "ON" OR "OFF" I DON'T UNDERSTAND JUST USE A FUCKING BOOLEAN
        return Err(ServerFnError::new(SignUpError::AgeCheckFail));
    }

    if form_info.terms_agree.is_some_and(|val| val != "on") {
        return Err(ServerFnError::new(SignUpError::TermsAgreeFail));
    }

    let state = expect_context::<SailfishState>();
    let Extension(mut queue) = extract::<Extension<RedisStorage<Email>>>().await?;

    if Account::fetch_by_email(form_info.email.clone(), &state.db).await.is_some() {
        return Err(ServerFnError::new(SignUpError::Conflict));
    }

    let account = Account::new(form_info.email, form_info.password, &state.db).await?;
    let code = ConfirmationCode::new(account.id, Utc::now() + Duration::seconds(3600), &state.db).await?;
    
    let new_email = Email {
        kind: EmailKind::ConfirmEmail,
        from: "Beatriz <beatriz@offprint.cafe>".to_string(),
        to: account.email.clone(),
        subject: "Welcome to Offprint!".to_string(),
        token: Some(code.token)
    };
    
    let job = queue.push(new_email).await;
    
    match job {
        Ok(_) => {
            leptos_axum::redirect("/check-email");
            Ok(())
        },
        Err(_) => Err(ServerFnError::new(SignUpError::ServerError))
    }
}

#[component]
pub fn SignUp() -> impl IntoView {
    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/sign-up".to_string(),
        title: "Sign Up — Offprint".to_string(),
        author_url: None,
        description: "For The Stories Left Untold".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };

    let submit = Action::<SignUpSubmit, _>::server();
    let value = submit.value();
    let has_error = move || value.with(|val| matches!(val, Some(Err(_))));
    let error = move || value.with(|val| {
        let some = val.to_owned();
        match some {
            Some(v) => {
                match v {
                    Ok(()) => SignUpError::ServerError.to_string(),
                    Err(e) => e.to_string().split_off(30),
                }
            },
            None => SignUpError::ServerError.to_string(),
        }
    });

    view! {
        <MetaTags options=meta_options />
        
        <div class="flex flex-col items-center justify-center bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll scrollbar-none" style="box-shadow: var(--dropshadow);">
            <div class="flex flex-col items-center justify-center pb-4">
                <h1 class="text-3xl">Welcome to Offprint!</h1>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center" style="font-family: var(--header-text);">
                    "Let's get started, shall we?"
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
                    name="form_info[email]".to_string()
                    label="Email Address".to_string()
                    kind=TextFieldType::Email
                    placeholder="somebody@example.net".to_string()
                    autocomplete="email".to_string()
                    required=true
                />
                <div class="my-1"></div>
                <TextField
                    name="form_info[password]".to_string()
                    label="Password".to_string()
                    kind=TextFieldType::Password
                    placeholder="••••••••••".to_string()
                    autocomplete="new-password".to_string()
                    required=true
                />
                <div class="my-1"></div>
                <TextField
                    name="form_info[repeat_password]".to_string()
                    label="Repeat Password".to_string()
                    kind=TextFieldType::Password
                    placeholder="••••••••••".to_string()
                    autocomplete="new-password".to_string()
                    required=true
                />
                <label class="flex mt-4 mb-2">
                    <input
                        id="age-check"
                        name="form_info[age_check]"
                        type="checkbox"
                        required
                        class="rounded bg-zinc-500 w-[18px] h-[18px] relative top-[0.075rem] border-0 mr-2 transition checked:bg-blue-500/75"
                    />
                    <span class="text-sm align-top select-none">I am 13 years of age or older</span>
                </label>
                <label class="flex mt-2 mb-4">
                    <input
                        id="terms-agree"
                        name="form_info[terms_agree]"
                        type="checkbox"
                        required
                        class="rounded bg-zinc-500 w-[18px] h-[18px] relative top-[0.075rem] border-0 mr-2 transition checked:bg-blue-500/75"
                    />
                    <span class="text-sm align-top select-none">
                        I agree to the <A class="text-accent hover:underline" href="/settings/about/terms-of-service">Terms of Service</A>, <A class="text-accent hover:underline" href="/settings/about/privacy-policy">Privacy Policy</A>, and <A class="text-accent hover:underline" href="/settings/about/constitution">Offprint Constitution</A>
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
                <A class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/log-in">
                    "Already have an account?"
                </A>
            </ActionForm>
        </div>
    }
}