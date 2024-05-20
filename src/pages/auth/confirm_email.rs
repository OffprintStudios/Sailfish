use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use icondata_lu as lucide;
use crate::error_template::SailfishError;
use crate::ui::util::{MetaTags, MetaTagOptions};

#[derive(Params, PartialEq)]
struct ConfirmEmailQuery {
    token: String,
}

#[server]
pub async fn confirm_email(token: Option<String>) -> Result<Option<()>, ServerFnError<SailfishError>> {
    use leptos::expect_context;
    use crate::sailfish::SailfishState;
    use crate::models::accounts::ConfirmationCode;

    if token.is_none() {
        return Ok(None);
    }

    let state = expect_context::<SailfishState>();

    let token = token.unwrap();

    let account = match ConfirmationCode::validate(token, &state.db).await {
        Ok(account) => account,
        Err(e) => return Err(ServerFnError::WrappedServerError(e))
    };

    account.confirm(&state.db)
        .await
        .map(|_| Some(()))
        .map_err(ServerFnError::WrappedServerError)
}

#[component]
pub fn ConfirmEmail() -> impl IntoView {
    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/check-email".to_string(),
        title: "Check Your Email — Offprint".to_string(),
        author_url: None,
        description: "For The Stories Left Untold".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };

    let query = use_query_map();
    let token = move || {
        query.with(|query| query.get("token").cloned())
    };

    let check_token = create_resource(token, |token| async move {
        confirm_email(token).await
    });

    view! {
        <MetaTags options=meta_options />

        <div class="flex flex-col items-center justify-center bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll" style="box-shadow: var(--dropshadow);">
            <Suspense
                fallback=move || view! {
                    <div class="flex flex-col items-center justify-center">
                        <h1 class="text-3xl">"Verifying Email"</h1>
                        <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8 font-header">
                            "Getting all your ducks in a row..."
                        </span>
                        <span><Icon icon=remixicon::RiLoader5SystemLine width="150px" height="150px" class="animate-spin" /></span>
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
                                    <span><Icon icon=lucide::LuCheckCircle width="150px" height="150px" class="text-green-500" /></span>
                                    <A class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/log-in">
                                        "Ready to get started?"
                                    </A>
                                }
                            } else if result.clone().is_ok_and(|res| res.is_none()) {
                                view! {
                                    <h1 class="text-3xl text-center mb-2">"There's something not quite right..."</h1>
                                    <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8 font-header">
                                        "Hey! Where's the code?"
                                    </span>
                                    <span><Icon icon=remixicon::RiQuestionSystemLine width="150px" height="150px" class="text-yellow-500" /></span>
                                }
                            } else {
                                view! {
                                    <h1 class="text-3xl text-center mb-2">"There's something not quite right..."</h1>
                                    <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8 font-header">
                                        "Seems like something went wrong on our end."
                                    </span>
                                    <span><Icon icon=remixicon::RiErrorWarningSystemLine width="150px" height="150px" class="text-red-500" /></span>
                                }
                            }
                        })
                    }}
                </div>
            </Suspense>
        </div>
    }
}