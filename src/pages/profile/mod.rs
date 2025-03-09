mod followers;
mod following;
mod works;
mod blogs;
mod home;

use home::ProfileHomePage;

use leptos::prelude::*;
use leptos::server_fn::codec::GetUrl;
use leptos_router::components::{ParentRoute, A, Outlet, Route};
use leptos_router::{path, MatchNestedRoutes, SsrMode, hooks::use_params_map};
use serde::{Serialize, Deserialize};
use crate::errors::{AppError, ErrorTemplate};
use crate::models::accounts::Profile;
use crate::ui::misc::MetaTags;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProfileInfo {
    profile: Profile
}

#[component(transparent)]
pub fn ProfileRoutes() -> impl MatchNestedRoutes + Clone {
    view! {
        <ParentRoute path=path!("/profile/:id/:username") view=ProfileLayout ssr=SsrMode::Async>
            <Route path=path!("") view=ProfileHomePage />
        </ParentRoute>
    }
    .into_inner()
}

#[server(prefix = "/api", endpoint = "profile", input = GetUrl)]
pub async fn load_profile(id: String) -> Result<ProfileInfo, ServerFnError<AppError>> {
    use crate::state::AppState;

    let state = expect_context::<AppState>();
    let profile = Profile::fetch_one(id, &state.db).await?;

    Ok(ProfileInfo { profile })
}

#[component]
pub fn ProfileLayout() -> impl IntoView {
    let params = use_params_map();
    let id = move || params().get("id").unwrap();
    let profile = Resource::new(id, |profile_id| async move { load_profile(profile_id).await });

    view! {
        <ErrorBoundary fallback=move |errors| view! { <ErrorTemplate errors /> }.into_view()>
            <Suspense>
                {move || Suspend::new(async move {
                    profile.await.map(|page_info| {
                        view! {
                            <MetaTags
                                url=format!("https://offprint.cafe/profile/{}/{}", &page_info.profile.id, slug::slugify(&page_info.profile.username))
                                title=format!("{}'s Profile — Offprint", &page_info.profile.username)
                                description=&page_info.profile.bio
                                image_url=&page_info.profile.avatar
                            />

                            <Outlet />
                        }
                    })
                })} 
            </Suspense>
        </ErrorBoundary>
    }
}