use leptos::*;
use leptos::html::{Div, Button};
use leptos_use::{use_element_bounding, use_window, UseElementBoundingReturn};
use crate::models::accounts::Profile;

#[component]
pub fn Guide(profile: Profile) -> impl IntoView {
    let button = create_node_ref::<Button>();
    let window = use_window();
    let UseElementBoundingReturn { left, .. } = use_element_bounding(button);

    let get_offset = move || {
        if window.is_some() {
            let scroll_x = window.as_ref().unwrap().scroll_x().unwrap_or(0.0);

            format!("{}px", left() + scroll_x - 335.0)
        } else {
            String::from("0px")
        }
    };

    view! {
        <button class="relative mx-1 md:mr-0 transition transform hover:scale-110" node_ref=button popovertarget="guide-menu">
            <div class="absolute z-[2] top-0 right-0">
                <div class="w-[13px] h-[13px] bg-rose-500 rounded-full" style="box-shadow: var(--dropshadow);">
                    <div class="w-full h-full bg-rose-500 animate-ping rounded-full" />
                </div>
            </div>
            <div class="w-[40px] h-[40px] z-[1] relative rounded-full border-2 border-white overflow-hidden">
                <img src=profile.avatar class="w-full h-full object-cover" />
            </div>
        </button>
        <div
            id="guide-menu"
            class="[&:popover-open]:inset-[unset] [&:popover-open]:top-[70px] md:[&:popover-open]:w-[375px] [&:popover-open]:w-full [&:popover-open]:m-0 p-4 bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur rounded-xl"
            style="box-shadow: var(--dropshadow); color: var(--text-color);"
            style:left=get_offset
            popover="auto"
        >
            "hi hello"
        </div>
    }
}