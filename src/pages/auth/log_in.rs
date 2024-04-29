use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use crate::ui::forms::{TextField, TextFieldType};
use crate::ui::util::{Button, KindOfButton, TypeOfButton};

#[server(LogInForm)]
pub async fn log_in(email: String, password: String) -> Result<(), ServerFnError> {
    // todo: actually implement this

    println!("Email: {:1}", email);
    println!("Password: {:1}", password);

    Ok(())
}

#[component]
pub fn LogIn() -> impl IntoView {
    let log_in = create_server_action::<LogInForm>();
    let value = log_in.value();
    let _has_error = move || value.with(|val| matches!(val, Some(Err(_))));

    view! {
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
                <A class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/auth/sign-up">
                    Looking to join? Sign up today!
                </A>
            </ActionForm>
        </div>
    }
}