mod overview;
mod accounts;
mod reports;
mod audit_log;
mod tags;

use leptos::prelude::*;
use leptos_router::{MatchNestedRoutes, path, SsrMode};
use leptos_router::components::{ParentRoute, Route, A, Outlet};
use overview::DashboardOverviewPage;
use crate::errors::ErrorTemplate;
use crate::pages::auth::validate_moderator;
use crate::ui::misc::MetaTags;

#[component(transparent)]
pub fn DashboardRoutes() -> impl MatchNestedRoutes + Clone {
    view! {
        <ParentRoute path=path!("/dashboard") view=DashboardLayout ssr=SsrMode::PartiallyBlocked>
            <Route path=path!("") view=DashboardOverviewPage />
        </ParentRoute>
    }.into_inner()
}

#[component]
pub fn DashboardLayout() -> impl IntoView {
    let validation = Resource::new_blocking(|| (), |_| validate_moderator());

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
                url="https://offprint.cafe/dashboard"
                title="Dashboard — Offprint"
                description="For The Stories Left Untold"
                image_url="/images/beatriz.png"
            />

            <div>
                <div
                    class="w-full mb-8 h-[75px] backdrop-blur-lg z-10 border-b border-opacity-25 bg-zinc-200/50 dark:bg-zinc-700/50 border-zinc-700/25 dark:border-zinc-200/25"
                    style="box-shadow: var(--dropshadow);"
                >
                    <div class="flex items-center max-w-7xl mx-auto h-full">
                        <h1 class="text-4xl text-black! dark:text-white! relative top-1.5">"Dashboard"</h1>
                        <div class="flex-1"></div>
                        <A 
                            href="/dashboard"
                            exact=true
                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps font-semibold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                        >
                            "Overview"
                        </A>
                        <A
                            href="/dashboard/tags"
                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps font-semibold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                        >
                            "Tags"
                        </A>
                        <A
                            href="/dashboard/accounts"
                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps font-semibold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                        >
                            "Accounts"
                        </A>
                        <A
                            href="/dashboard/reports"
                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps font-semibold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                        >
                            "Reports"
                        </A>
                        <A
                            href="/dashboard/audit-log"
                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps font-semibold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                        >
                            "Audit Log"
                        </A>
                    </div>
                </div>
                <Outlet />
                {is_valid}
            </div>
        </ErrorBoundary>        
    }
}