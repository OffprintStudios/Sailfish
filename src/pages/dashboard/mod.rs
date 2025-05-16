mod overview;
mod accounts;
mod reports;
mod audit_log;
mod tags;

use leptos::prelude::*;
use leptos_router::{MatchNestedRoutes, path, SsrMode};
use leptos_router::components::{ParentRoute, Route, Outlet};
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
        <MetaTags
            url="https://offprint.cafe/dashboard"
            title="Dashboard — Offprint"
            description="For The Stories Left Untold"
            image_url="/images/beatriz.png"
        />

        <ErrorBoundary fallback=move |errors| view! { <ErrorTemplate errors /> }.into_view()>
            <span>"hi"</span>
            <Outlet />
            {is_valid}
        </ErrorBoundary>        
    }
}