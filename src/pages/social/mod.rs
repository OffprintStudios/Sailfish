use leptos::prelude::*;
use leptos_router::{path, components::Route, MatchNestedRoutes};

#[component(transparent)]
pub fn SocialRoutes() -> impl MatchNestedRoutes + Clone {
    view! {
        <Route path=path!("/social") view=SocialPage />
    }
    .into_inner()
}

#[component]
pub fn SocialPage() -> impl IntoView {
    view! {
        <div class="empty">
            <h3>"Nothing To See Here"</h3>
            <p>"This page is still under construction!"</p>
        </div>
    }
}