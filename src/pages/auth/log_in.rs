use leptos::prelude::*;
use leptos_router::components::A;
use leptos_icons::*;
use icondata as TablerIcon;
use serde::{Serialize, Deserialize};
use thiserror::Error;
use crate::ui::forms::{TextField, TextFieldType};
use crate::ui::misc::{MetaTags, Button, ButtonKind, ButtonType};

#[derive(Debug, Clone, Serialize, Deserialize, Error)]
pub enum LogInError {
    #[error("You can't log in until your email's been confirmed, so we sent you a new confirmation code. Remember to check your inbox!")]
    EmailNotConfirmed,
    #[error("Doesn't look like you're on the list. Are you sure all your info's good?")]
    CredentialsInvalid,
    #[error("Uh-oh. Seems like something messed up on our end. Check back in a little bit.")]
    ServerError,
}

#[server(LogIn, "/api/auth/log-in")]
pub async fn log_in(email: String, password: String, remember_me: Option<String>) -> Result<(), ServerFnError> {
    use std::ops::Add;
    use apalis::prelude::Storage;
    use apalis_redis::RedisStorage;
    use axum::Extension;
    use tower_cookies::{Cookie, Cookies};
    use tower_cookies::cookie::time::{OffsetDateTime, Duration};
    use tower_cookies::cookie::SameSite;
    use crate::constants::{SECRET_KEY, MIN_SESSION_DURATION, MAX_SESSION_DURATION};
    use crate::state::AppState;
    use crate::models::accounts::{Account, Session, Otp, OtpKind};
    use crate::queues::email::{Email, EmailKind};

    let key = SECRET_KEY.get().unwrap();
    let state = expect_context::<AppState>();
    let cookies = leptos_axum::extract::<Cookies>().await?.private(key);
    let persist_session = remember_me.is_some_and(|v| v == "on");

    let account = match Account::verify(email, password, &state.db).await {
        Ok(val) => val,
        Err(_) => return Err(ServerFnError::new(LogInError::CredentialsInvalid))
    };

    if !account.email_confirmed {
        let Extension(mut queue) = leptos_axum::extract::<Extension<RedisStorage<Email>>>().await?;
        let code = Otp::new(account.id, OtpKind::EmailConfirmation, chrono::Utc::now() + chrono::Duration::seconds(3600), &state.db).await?;

        let new_email = Email {
            kind: EmailKind::ConfirmEmail,
            from: "Beatriz <beatriz@offprint.cafe>".to_string(),
            to: account.email.clone(),
            subject: "Welcome to Offprint!".to_string(),
            token: Some(code.token)
        };

        let job = queue.push(new_email).await;
        
        match job {
            Ok(_) => return Err(ServerFnError::new(LogInError::EmailNotConfirmed)),
            Err(_) => return Err(ServerFnError::new(LogInError::ServerError))
        }
    }

    let token_offset = match persist_session {
        true => MAX_SESSION_DURATION,
        false => MIN_SESSION_DURATION,
    };

    let session_id = match Session::start(
        account.id,
        chrono::Utc::now() + chrono::Duration::seconds(token_offset),
        &state.db
    ).await {
        Ok(session) => session,
        Err(_) => return Err(ServerFnError::new(LogInError::ServerError))
    };

    let session_token = Cookie::build(("session-token", session_id.to_string()))
        .path("/")
        .secure(true)
        .expires(OffsetDateTime::now_utc().add(Duration::seconds(token_offset)))
        .max_age(Duration::seconds(token_offset))
        .same_site(SameSite::Strict)
        .http_only(true)
        .build();

    cookies.add(session_token);

    leptos_axum::redirect("/switch-profile");
    Ok(())
}

#[component]
pub fn LogInPage() -> impl IntoView {
    let submit = ServerAction::<LogIn>::new();
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
        <MetaTags
            url="https://offprint.cafe/log-in"
            title="Log In — Offprint"
            description="For The Stories Left Untold"
            image_url="/images/beatriz.png"
        />
        
        <div class="flex flex-col items-center justify-center md:justify-normal bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit relative" style="box-shadow: var(--dropshadow);">
            <div class="flex flex-col items-center justify-center pb-4">
                <h1 class="text-3xl">"Welcome back!"</h1>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
                    "We're so glad you're here."
                </span>
            </div>
            <Show when=has_error>
                <div class="text-sm flex flex-col bg-red-600/25 border border-red-600/75 rounded-xl p-4 mb-4">
                    <div class="flex items-center mb-1">
                        <span class="mr-1"><Icon icon=TablerIcon::TbInfoCircle width="20px" height="20px" /></span>
                        <span class="font-bold">"Head's Up!"</span>
                    </div>
                    <span>{error()}</span>
                </div>
            </Show>
            <ActionForm attr:class="flex flex-col w-full" action=submit>
                <TextField
                    name="email"
                    label="Email Address"
                    kind=TextFieldType::Email
                    placeholder="somebody@example.net"
                    autocomplete="email"
                    required=true
                />
                <div class="my-1.5"></div>
                <TextField
                    name="password"
                    label="Password"
                    kind=TextFieldType::Password
                    placeholder="••••••••••"
                    autocomplete="current-password"
                    required=true
                />
                <A attr:class="text-zinc-500 dark:text-zinc-400 text-sm pt-2 hover:underline" href="/reset-password">"Forgot your password?"</A>
                <label class="flex mt-4">
                    <input
                        id="remember-me"
                        name="remember_me"
                        type="checkbox"
                        class="rounded bg-zinc-500 w-[18px] h-[18px] relative top-[0.075rem] border-0 mr-2 transition checked:bg-blue-500/75"
                    />
                    <span class="text-sm align-top select-none">
                        "Remember me for 30 days"
                    </span>
                </label>
                <div class="my-3"></div>
                <Button
                    id="log-in-button"
                    title="Log In"
                    type_of=ButtonType::Submit
                    kind=ButtonKind::Primary
                    full_width=true
                >
                    <span class="button-icon"><Icon icon=TablerIcon::TbLogin2 /></span>
                    <span class="button-text">"Log In"</span>
                </Button>
                <A attr:class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/sign-up">
                    "Looking to join? Sign up today!"
                </A>
            </ActionForm>
        </div>
    }
}