#![feature(try_trait_v2)]
#![feature(never_type)]

pub mod app;
pub mod error_template;
pub mod client;

pub mod shared;

#[cfg(feature = "ssr")]
pub mod server;

#[cfg(feature = "ssr")]
pub mod fileserv;

#[cfg(feature = "hydrate")]
#[wasm_bindgen::prelude::wasm_bindgen]
pub fn hydrate() {
    use crate::app::*;
    console_error_panic_hook::set_once();
    leptos::mount_to_body(App);
}
