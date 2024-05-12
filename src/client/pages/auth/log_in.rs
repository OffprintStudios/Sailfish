use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use crate::client::ui::forms::{TextField, TextFieldType};
use crate::client::ui::util::{Button, KindOfButton, MetaTagOptions, MetaTags, TypeOfButton};

#[server(LogInForm)]
pub async fn log_in(email: String, password: String, remember_me: Option<String>) -> Result<(), ServerFnError> {
    use std::ops::Add;
    use leptos_axum::{extract, redirect};
    use tower_cookies::{Cookies, Cookie};
    use tower_cookies::cookie::time::{OffsetDateTime, Duration};
    use tower_cookies::cookie::SameSite;
    use crate::server::util::constants::{KEY, MAX_SESSION_DURATION, MIN_SESSION_DURATION};
    use crate::server::util::state::SailfishState;
    use crate::server::api::auth::log_in;

    let key = KEY.get().unwrap();
    let state = expect_context::<SailfishState>();
    let cookies = extract::<Cookies>().await?.private(key);
    let persist_session = remember_me.is_some_and(|v| v == "on");

    let session_id = log_in(email, password, persist_session, &state.db).await?;
    let token_offset = match persist_session {
        true => MAX_SESSION_DURATION,
        false => MIN_SESSION_DURATION,
    };

    let session_token = Cookie::build(("session_token", session_id.to_string()))
        .path("/")
        .secure(true)
        .expires(OffsetDateTime::now_utc().add(Duration::seconds(token_offset)))
        .max_age(Duration::seconds(token_offset))
        .same_site(SameSite::Strict)
        .http_only(true)
        .build();

    cookies.add(session_token);
    
    redirect("/switch-profile");

    Ok(())
}

#[component]
pub fn LogIn() -> impl IntoView {
    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/log-in".to_string(),
        title: "Log In — Offprint".to_string(),
        author_url: None,
        description: "For The Stories Left Untold".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };
    
    let log_in = create_server_action::<LogInForm>();
    let value = log_in.value();
    let _has_error = move || value.with(|val| matches!(val, Some(Err(_))));

    view! {
        <MetaTags options=meta_options />
        
        <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
            <div class="flex flex-col items-center justify-center pb-4">
                <h1 class="text-3xl">Welcome back!</h1>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
                    "We're so glad you're here."
                </span>
            </div>
            <ActionForm class="flex flex-col" action=log_in>
                <TextField
                    name="email".to_string()
                    label="Email Address".to_string()
                    kind=TextFieldType::Email
                    placeholder="somebody@example.net".to_string()
                    autocomplete="email".to_string()
                    required=true
                />
                <div class="my-1.5"></div>
                <TextField
                    name="password".to_string()
                    label="Password".to_string()
                    kind=TextFieldType::Password
                    placeholder="••••••••••".to_string()
                    autocomplete="current-password".to_string()
                    required=true
                />
                <A class="text-zinc-500 dark:text-zinc-400 text-sm pt-2 hover:underline" href="/auth/forgot-password">Forgot your password?</A>
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
                    id="log-in-button".to_string()
                    title="Log In".to_string()
                    type_of=TypeOfButton::Submit
                    kind=KindOfButton::Primary
                    full_width=true
                >
                    <span class="button-icon"><Icon icon=remixicon::RiLoginCircleSystemLine /></span>
                    <span class="button-text">"Log In"</span>
                </Button>
                <A class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/sign-up">
                    Looking to join? Sign up today!
                </A>
            </ActionForm>
        </div>
    }
}