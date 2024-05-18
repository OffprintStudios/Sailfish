mod home;
pub mod explore;
pub mod social;
pub mod docs;
pub mod auth;

pub use home::Home;

use leptos::*;
use leptos_router::*;
use crate::ui::nav::Nav;

#[component]
pub fn BaseLayout() -> impl IntoView {
    view! {
        <Nav />
        <Outlet />
    }
}