use leptos::*;
use crate::models::accounts::Profile;
use crate::error_template::{SailfishError, ErrorTemplate};
use crate::ui::util::{MetaTags, MetaTagOptions};

#[server]
pub async fn load_profiles() -> Result<Vec<Profile>, ServerFnError<SailfishError>> {
    use crate::sailfish::SailfishState;
    use crate::util::auth::authorize;

    let state = expect_context::<SailfishState>();

    let account = match authorize(&state.db).await {
        Some(acc) => acc,
        None => return Err(ServerFnError::WrappedServerError(SailfishError::Unauthorized))
    };
    
    let profiles = match Profile::fetch_owned(account.id, &state.db).await {
        Ok(result) => result,
        Err(_) => return Err(ServerFnError::WrappedServerError(SailfishError::ServerError))
    };
    
    Ok(profiles)
}

#[component]
pub fn SwitchProfile() -> impl IntoView {
    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/switch-profile".to_string(),
        title: "Switch Profile — Offprint".to_string(),
        author_url: None,
        description: "So, who's gonna be with us today?".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };
    
    view! {
        <MetaTags options=meta_options />
        
        <Await
            future=load_profiles
            blocking=true
            children=|data| {
                let profiles = data.clone();
            
                view! {
                    <ErrorBoundary fallback=move |errors| {
                        view! {
                            <ErrorTemplate outside_errors=errors.get() />
                        }
                    }>
                        <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
                            <div class="flex flex-col items-center justify-center pb-4">
                                <h1 class="text-3xl">"Select a Profile"</h1>
                                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold" style="font-family: var(--header-text);">
                                    "Who's gonna be with us today?"
                                </span>
                            </div>
                            <div>{profiles.map(|p| p.len())}</div>
                            <div class="flex items-center justify-center w-full">
                                <div>"hello"</div>
                                <div>"hello"</div>
                                <div>"hello"</div>
                            </div>
                        </div>
                    </ErrorBoundary>
                }
            }   
        />
    }
}