mod overview;
mod original_works;
mod fan_works;
mod blogs;

use leptos::prelude::*;
use leptos_router::{path, MatchNestedRoutes, SsrMode};
use leptos_router::components::{ParentRoute, A, Outlet, Route};
use overview::CreateOverviewPage;
use original_works::CreateOriginalWorksPage;
use fan_works::CreateFanWorksPage;
use blogs::CreateBlogsPage;
use crate::pages::auth::validate;
use crate::errors::ErrorTemplate;
use crate::ui::misc::MetaTags;

#[component(transparent)]
pub fn CreateRoutes() -> impl MatchNestedRoutes + Clone {
    view! {
        <ParentRoute path=path!("/create") view=CreateLayout ssr=SsrMode::PartiallyBlocked>
            <Route path=path!("original-works") view=CreateOriginalWorksPage />
            <Route path=path!("fan-works") view=CreateFanWorksPage />
            <Route path=path!("blogs") view=CreateBlogsPage />
            <Route path=path!("") view=CreateOverviewPage />
        </ParentRoute>
    }.into_inner()
}

#[component]
pub fn CreateLayout() -> impl IntoView {
    let validation = Resource::new_blocking(|| (), |_| validate());

    let is_valid = move || {
        Suspend::new(async move {
            validation.await.map(|_| {
                view! {
                    <span class="hidden">"authorized"</span>
                }
            })
        })
    };

    view! {
        <ErrorBoundary fallback=move |errors| view! { <ErrorTemplate errors /> }.into_view()>
            <MetaTags
                url="https://offprint.cafe/create"
                title="Create — Offprint"
                description="For The Stories Left Untold"
                image_url="/images/beatriz.png"
            />

            <div>
                <div
                    class="w-full mb-8 h-[75px] backdrop-blur-lg z-10 border-b border-opacity-25 bg-zinc-200/50 dark:bg-zinc-700/50 border-zinc-700/25 dark:border-zinc-200/25"
                    style="box-shadow: var(--dropshadow);"
                >
                    <div class="flex items-center max-w-7xl mx-auto h-full">
                        <h1 class="text-4xl text-black! dark:text-white! relative top-1.5">"Create"</h1>
                        <div class="flex-1"></div>
                        <A 
                            href="/create"
                            exact=true
                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps font-semibold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                        >
                            "Overview"
                        </A>
                        <A
                            href="/create/original-works"
                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps font-semibold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                        >
                            "Original Works"
                        </A>
                        <A
                            href="/create/fan-works"
                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps font-semibold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                        >
                            "Fan Works"
                        </A>
                        <A
                            href="/create/blogs"
                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps font-semibold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                        >
                            "Blogs"
                        </A>
                    </div>
                </div>
                <Outlet />
                {is_valid}
            </div>
        </ErrorBoundary>
    }
}