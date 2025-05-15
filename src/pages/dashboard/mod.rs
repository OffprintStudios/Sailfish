mod overview;
mod accounts;
mod reports;
mod audit_log;
mod tags;

use leptos::prelude::*;
use leptos_router::{MatchNestedRoutes, path, SsrMode};
use leptos_router::components::{ParentRoute, Route, A, Outlet};
use overview::DashboardOverviewPage;

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
    view! {
        <span>"hi"</span>
        <Outlet />
    }
}