pub mod app;
pub mod errors;
pub mod models;
pub mod pages;
pub mod store;
pub mod ui;
pub mod util;

cfg_if::cfg_if! {
    if #[cfg(feature = "ssr")] {
        pub mod constants;
        pub mod database;
        pub mod mailer;
        pub mod queues;
        pub mod state;
    }
}

#[cfg(feature = "hydrate")]
#[wasm_bindgen::prelude::wasm_bindgen]
pub fn hydrate() {
    use crate::app::*;
    console_error_panic_hook::set_once();
    leptos::mount::hydrate_body(App);
}
