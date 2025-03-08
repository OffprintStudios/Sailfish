mod followers;
mod following;
mod works;
mod blogs;
mod home;

use leptos::prelude::*;
use leptos_router::components::{ParentRoute, A, Outlet, Route};
use leptos_router::{path, MatchNestedRoutes, SsrMode};

use home::ProfileHomePage;

#[component(transparent)]
pub fn ProfileRoutes() -> impl MatchNestedRoutes + Clone {
    view! {
        <ParentRoute path=path!("/profile/:id/:username?") view=ProfileLayout ssr=SsrMode::Async>
            <Route path=path!("") view=ProfileHomePage />
        </ParentRoute>
    }
    .into_inner()
}

#[component]
pub fn ProfileLayout() -> impl IntoView {
    view! {
        <span>"hi"</span>
        <Outlet />
    }
}