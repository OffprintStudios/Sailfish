mod home;
pub mod auth;

pub use home::HomePage;

use leptos::prelude::*;
use leptos_router::components::Outlet;
use crate::ui::nav::Nav;

#[component]
pub fn BaseLayout() -> impl IntoView {
    view! {
        <Nav />
        <Outlet />
    }
}