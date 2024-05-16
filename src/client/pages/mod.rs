mod home;
pub mod explore;
pub mod docs;
pub mod auth;
pub mod social;

pub use home::Home;

use leptos::*;
use leptos_router::*;
use crate::client::ui::nav::Nav;

#[component]
pub fn DefaultLayout() -> impl IntoView {
    view! {
        <Nav />
        <Outlet />
    }
}
