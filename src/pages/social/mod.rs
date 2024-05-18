use leptos::*;
use leptos_router::*;

#[component(transparent)]
pub fn SocialRoutes() -> impl IntoView {
    view! {
        <Route path="/social" view=Social />
    }
}

#[component]
pub fn Social() -> impl IntoView {
    view! {
        <p>Social</p>
    }
}