use leptos::prelude::*;
use leptos_router::components::A;
use leptos_router::params::Params;
use leptos_icons::*;
use icondata as TablerIcon;
use crate::errors::AppError;
use crate::ui::misc::MetaTags;

#[derive(Params, PartialEq)]
struct ConfirmEmailQuery {
    token: String
}

#[server(ConfirmEmail, "/api/auth/confirm-email")]
pub async fn confirm_email(token: Option<String>) -> Result<Option<()>, ServerFnError<AppError>> {
    use crate::state::AppState;
    use crate::models::accounts::ConfirmationCode;

    if let Some(token) = token {
        let state = expect_context::<AppState>();
        let account = match ConfirmationCode::validate(token, &state.db).await {
            Ok(account) => account,
            Err(e) => return Err(ServerFnError::WrappedServerError(e))
        };
        account.confirm(&state.db)
            .await
            .map(|_| Some(()))
            .map_err(ServerFnError::WrappedServerError)
    } else {
        Ok(None)
    }
}

#[component]
pub fn ConfirmEmailPage() -> impl IntoView {
    let query = leptos_router::hooks::use_query_map();
    let token = move || {
        query.with(|query| query.get("token"))
    };

    let check_token = Resource::new(token, | token| async move {
        confirm_email(token).await
    });

    view! {
        <MetaTags
            url="https://offprint.cafe/check-email"
            title="Check Your Email — Offprint"
            description="For The Stories Left Untold"
            image_url="/images/beatriz.png"
        />

        <div class="flex flex-col items-center justify-center bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll" style="box-shadow: var(--dropshadow);">
            <Suspense
                fallback=move || view! {
                    <div class="flex flex-col items-center justify-center">
                        <h1 class="text-3xl">"Verifying Email"</h1>
                        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold items-center pb-8 font-header">
                            "Getting all your ducks in a row ..."
                        </span>
                        <span><Icon icon=TablerIcon::TbLoader width="150px" height="150px" class="animate-spin" /></span>
                    </div>
                }
            >
                <div class="flex flex-col items-center justify-center">
                    {move || {
                        check_token.get().map(|result| {
                            if result.clone().is_ok_and(|res| res.is_some()) {
                                view! {
                                    <h1 class="text-3xl">"All good!"</h1>
                                    <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8 font-header">
                                        "You're all set to log on in."
                                    </span>
                                    <span><Icon icon=TablerIcon::TbCircleCheck width="150px" height="150px" class="text-green-500" /></span>
                                    <A attr:class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/log-in">
                                        "Ready to get started?"
                                    </A>
                                }.into_any()
                            } else if result.clone().is_ok_and(|res| res.is_none()) {
                                view! {
                                    <h1 class="text-3xl text-center mb-2">"There's something not quite right..."</h1>
                                    <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8 font-header">
                                        "Hey! Where's the code?"
                                    </span>
                                    <span><Icon icon=TablerIcon::TbHelp width="150px" height="150px" class="text-yellow-500" /></span>
                                }.into_any()
                            } else {
                                view! {
                                    <h1 class="text-3xl text-center mb-2">"There's something not quite right..."</h1>
                                    <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8 font-header">
                                        "Seems like something went wrong on our end."
                                    </span>
                                    <span><Icon icon=TablerIcon::TbAlertCircle width="150px" height="150px" class="text-red-500" /></span>
                                }.into_any()
                            }
                        })
                    }}
                </div>
            </Suspense>
        </div>
    }
}