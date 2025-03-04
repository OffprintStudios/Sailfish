use leptos::prelude::*;
use leptos::html::Button;
use leptos::reactive::computed;
use leptos_icons::*;
use icondata as TablerIcon;
use crate::models::accounts::Profile;
use crate::ui::misc::RoleBadge;

#[derive(Debug, Clone)]
pub enum Panel {
    Main,
    LogOut
}

#[component]
pub fn Guide(profile: Profile) -> impl IntoView {
    let (curr_panel, set_curr_panel) = signal(Panel::Main);
    let button_ref = NodeRef::<Button>::new();
    let window = leptos_use::use_window();
    let leptos_use::UseElementBoundingReturn { left, .. } = leptos_use::use_element_bounding(button_ref);
    let is_min_width = leptos_use::use_media_query("(min-width: 768px)");

    let (offset, set_offset) = signal::<String>("0px".into());

    Effect::new(move || {
        if window.is_some() {
            let scroll_x = window.as_ref().unwrap().scroll_x().unwrap_or(0.0);
            if !is_min_width() {
                set_offset("0px".into());
            } else {
                set_offset(format!("{}px", left() + scroll_x - 335.0));
            }
        } else {
            set_offset("0px".into());
        }
    });

    view! {
        <button class="relative mx-1 md:mr-0 transition transform hover:scale-110" popovertarget="guide-menu" node_ref=button_ref>
            <div class="absolute z-[2] top-0 right-0">
                <div class="w-[13px] h-[13px] bg-rose-500 rounded-full" style="box-shadow: var(--dropshadow);">
                    <div class="w-full h-full bg-rose-500 animate-ping rounded-full" />
                </div>
            </div>
            <div class="w-[40px] h-[40px] z-[1] relative rounded-full border-2 border-white overflow-hidden">
                <img src=profile.avatar.clone() class="w-full h-full object-cover" />
            </div>
        </button>
        <div
            id="guide-menu"
            class="[&:popover-open]:inset-[unset] [&:popover-open]:top-[66px] md:[&:popover-open]:top-[70px] md:[&:popover-open]:w-[375px] [&:popover-open]:w-full [&:popover-open]:m-0 p-2 bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur border-b md:border border-zinc-600/25 dark:border-zinc-300/25 md:rounded-xl motion-opacity-in-0 motion-blur-in-md motion-duration-200"
            style="box-shadow: var(--dropshadow); color: var(--text-color);"
            style:left=move || offset()
            popover="auto"
        >
            {move || match curr_panel() {
                Panel::Main => view! { <MainPanel profile=profile.clone() set_curr_panel /> }.into_any(),
                Panel::LogOut => view! { <LogOutPanel set_curr_panel /> }.into_any()
            }}
        </div>
    }
}

#[component]
pub fn MainPanel(profile: Profile, set_curr_panel: WriteSignal<Panel>) -> impl IntoView {
    view! {
        <div class="flex flex-col items-center justify-center w-full ml-1">
            <img src=profile.avatar.clone() class="w-[100px] h-[100px] object-cover rounded-full mr-2" />
            <h3 class="text-3xl relative top-0.5">{profile.username.clone()}</h3>
            <RoleBadge roles=profile.roles />
        </div>
    }
}

#[component]
pub fn LogOutPanel(set_curr_panel: WriteSignal<Panel>) -> impl IntoView {
    view! {
        <div class="flex flex-col w-full overflow-hidden rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25">
            "hi"
        </div>
    }
}