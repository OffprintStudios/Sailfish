use leptos::prelude::*;
use leptos_router::params::Params;
use leptos_icons::*;
use icondata as TablerIcon;
use crate::ui::misc::{MetaTags, Button, ButtonKind, ButtonType};
use crate::ui::forms::{TextField, TextFieldType};

#[derive(Params, PartialEq)]
struct ResetPasswordQuery {
    token: String
}

#[server(SendResetCode, "/api/auth/send-reset-code")]
pub async fn send_reset_code(email: String) -> Result<(), ServerFnError> {
    use axum::Extension;
    use apalis::prelude::Storage;
    use apalis_redis::RedisStorage;
    use crate::state::AppState;
    use crate::queues::email::{Email, EmailKind};
    use crate::models::accounts::{Account, Otp, OtpKind};

    let state = expect_context::<AppState>();
    if let Some(account) = Account::fetch_by_email(email, &state.db).await {
        let Extension(mut queue) = leptos_axum::extract::<Extension<RedisStorage<Email>>>().await?;
        let reset_code = Otp::new(account.id, OtpKind::PasswordReset, chrono::Utc::now() + chrono::Duration::seconds(3600), &state.db).await?;

        let new_email = Email {
            kind: EmailKind::PasswordReset,
            from: "Beatriz <beatriz@offprint.cafe>".to_string(),
            to: account.email.clone(),
            subject: "Reset Your Offprint Password".to_string(),
            token: Some(reset_code.token)
        };

        let job = queue.push(new_email).await;
        match job {
            Ok(_) => Ok(()),
            Err(_) => Ok(())
        }
    } else {
        Ok(())
    }
}

#[server(ResetPassword, "/api/auth/reset-password")]
pub async fn reset_password(new_password: String, repeat_password: String, token: String) -> Result<(), ServerFnError> {
    use crate::state::AppState;
    use crate::models::accounts::{Otp, OtpKind};

    let state = expect_context::<AppState>();

    if new_password != repeat_password {
        return Err(ServerFnError::new("Your passwords don't match!"));
    }
    if let Ok(valid_account) = Otp::validate(token, OtpKind::PasswordReset, &state.db).await {
        valid_account.reset_password(new_password, &state.db).await.unwrap_or(());
        leptos_axum::redirect("/log-in");
        Ok(())
    } else {
        leptos_axum::redirect("/log-in");
        Ok(())
    }
}

#[component]
pub fn ResetPasswordPage() -> impl IntoView {
    let query = leptos_router::hooks::use_query_map();
    let token = move || {
        query.with(|query| query.get("token"))
    };

    let send_code_submit = ServerAction::<SendResetCode>::new();
    let send_code_value = send_code_submit.value();
    let has_code_success = move || send_code_value.with(|val| matches!(val, Some(Ok(()))));

    let reset_password_submit = ServerAction::<ResetPassword>::new();

    view! {
        <MetaTags
            url="https://offprint.cafe/reset-password"
            title="Reset Password — Offprint"
            description="For The Stories Left Untold"
            image_url="/images/beatriz.png"
        />

        <div class="flex flex-col items-center justify-center bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll" style="box-shadow: var(--dropshadow);">
            <Show
                when=move || token().is_some()
                fallback=move || view! {
                    <ActionForm attr:class="flex flex-col w-full" action=send_code_submit>
                        <h1 class="text-3xl text-center">"Forgot Your Password?"</h1>
                        <Show when=has_code_success>
                            <div class="text-sm flex flex-col bg-green-600/25 border border-green-600/75 rounded-xl p-4 mb-4">
                                <div class="flex items-center mb-1">
                                    <span class="mr-1"><Icon icon=TablerIcon::TbInfoCircle width="20px" height="20px" /></span>
                                    <span class="font-bold">"Head's Up!"</span>
                                </div>
                                <span>"If you've got an account with us, we've sent instructions on how to reset your password."</span>
                            </div>
                        </Show>
                        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold items-center text-center py-2 font-header">
                            "Enter your email address"
                        </span>
                        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold items-center text-center pb-8 font-header">
                            "We'll send you instructions on how to reset your password"
                        </span>
                        <TextField
                            name="email"
                            label="Email Address"
                            kind=TextFieldType::Email
                            placeholder="somebody@example.net"
                            autocomplete="email"
                            required=true
                        />
                        <div class="my-3"></div>
                        <Button
                            id="send-email-button"
                            title="Send Reset Email"
                            type_of=ButtonType::Submit
                            kind=ButtonKind::Primary
                            full_width=true
                        >
                            <span class="button-icon"><Icon icon=TablerIcon::TbMailFast /></span>
                            <span class="button-text">"Send Reset Email"</span>
                        </Button>
                    </ActionForm>
                }
            >
                <ActionForm attr:class="flex flex-col w-full" action=reset_password_submit>
                    <h1 class="text-3xl text-center">"Reset Your Password"</h1>
                    <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold items-center text-center py-2 font-header">
                        "Enter your new password"
                    </span>
                    <TextField
                        name="new_password"
                        label="Password"
                        kind=TextFieldType::Password
                        placeholder="••••••••••"
                        autocomplete="new-password"
                        required=true
                    />
                    <TextField
                        name="repeat_password"
                        label="Password"
                        kind=TextFieldType::Password
                        placeholder="••••••••••"
                        autocomplete="new-password"
                        required=true
                    />
                    <div class="hidden">
                        <input type="text" name="token" value={token()} required=true />
                    </div>
                    <div class="my-3"></div>
                    <Button
                        id="reset-password-button"
                        title="Reset Password"
                        type_of=ButtonType::Submit
                        kind=ButtonKind::Primary
                        full_width=true
                    >
                        <span class="button-icon"><Icon icon=TablerIcon::TbKey /></span>
                        <span class="button-text">"Reset Password"</span>
                    </Button>
                </ActionForm>
            </Show>
        </div>
    }
}