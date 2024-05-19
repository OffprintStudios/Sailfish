pub mod sailfish;
pub mod error_template;
pub mod models;
pub mod pages;
pub mod state;
pub mod ui;
pub mod util;

cfg_if::cfg_if! {
    if #[cfg(feature = "ssr")] {
        pub mod fileserv;
        pub mod database;
        pub mod constants;
        pub mod mailer;
    }
}

#[cfg(feature = "hydrate")]
#[wasm_bindgen::prelude::wasm_bindgen]
pub fn hydrate() {
    use crate::sailfish::*;
    console_error_panic_hook::set_once();
    leptos::mount_to_body(Sailfish);
}
