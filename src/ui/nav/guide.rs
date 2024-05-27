use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use leptos::html::Button as HtmlButton;
use leptos_use::{use_element_bounding, use_media_query, use_window, UseElementBoundingReturn};
use leptos_use::storage::use_local_storage;
use leptos_use::utils::JsonCodec;
use strum::IntoEnumIterator;
use crate::models::accounts::Profile;
use crate::ui::util::{Button, KindOfButton};
use crate::state::AppState;
use crate::models::util::{BrightnessMode, Theme};

#[derive(Debug, Clone)]
pub enum Panel {
    Main,
    LogOut,
}

#[component]
pub fn Guide(profile: Profile) -> impl IntoView {
    let (curr_panel, set_curr_panel) = create_signal(Panel::Main);
    let button = create_node_ref::<HtmlButton>();
    let window = use_window();
    let UseElementBoundingReturn { left, .. } = use_element_bounding(button);
    let is_min_width = use_media_query("(min-width: 768px)");

    let get_offset = move || {
        if window.is_some() {
            let scroll_x = window.as_ref().unwrap().scroll_x().unwrap_or(0.0);
            if !is_min_width() {
                String::from("0px")
            } else {
                format!("{}px", left() + scroll_x - 335.0)
            }
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
                <img src=&profile.avatar class="w-full h-full object-cover" />
            </div>
        </button>
        <div
            id="guide-menu"
            class="[&:popover-open]:inset-[unset] [&:popover-open]:top-[66px] md:[&:popover-open]:top-[70px] md:[&:popover-open]:w-[375px] [&:popover-open]:w-full [&:popover-open]:m-0 p-2 bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur border-b md:border border-zinc-600/25 dark:border-zinc-300/25 md:rounded-xl"
            style="box-shadow: var(--dropshadow); color: var(--text-color);"
            style:left=get_offset
            popover="auto"
        >
            {move || match curr_panel() {
                Panel::Main => view! { <MainPanel profile=profile.clone() set_curr_panel /> },
                Panel::LogOut => view! { <LogOutPanel set_curr_panel /> }
            }}
        </div>
    }
}

#[component]
pub fn MainPanel(profile: Profile, set_curr_panel: WriteSignal<Panel>) -> impl IntoView {
    view! {
        <div class="flex flex-col w-full overflow-hidden rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25">
            <div class="h-[75px] overflow-hidden w-full relative bg-accent">
                {match profile.banner_art {
                    Some(art) => view! { <img src=art class="h-full w-full object-cover" alt="profile avatar" /> }.into_view(),
                    None => view! { /* renders nothing */ }.into_view()
                }}
            </div>
            <div class="w-full flex items-center p-2">
                <div class="mr-2 w-[60px] h-[60px] overflow-hidden rounded-full border-2 border-white">
                    <img src=profile.avatar class="w-full h-full object-cover" alt="avatar" />
                </div>
                <div class="flex flex-1 flex-col">
                    <h1 class="max-w-[270px] truncate text-2xl">
                        <A class="hover:underline" href="">
                            {profile.username}
                        </A>
                    </h1>
                    // TODO: add role badges
                </div>
            </div>
            <div class="all-small-caps flex w-full border-t border-zinc-400 text-lg font-bold dark:border-zinc-500 font-header">
                <A
                    class="flex h-[65px] w-1/3 flex-col items-center justify-center pt-0.5 transition hover:bg-zinc-300 hover:dark:bg-zinc-600"
                    href=""
                >
                    <div class="flex items-center relative top-2">
                        <span class="relative -top-1"><Icon icon=remixicon::RiQuillPenDesignLine width="18px" height="18px" /></span>
                        <span class="relative -top-1 ml-1 text-xl">0</span>
                    </div>
                    <span class="relative -top-1">"Works"</span>
                </A>
                <A
                    class="flex h-[65px] w-1/3 flex-col items-center justify-center border-l border-r border-zinc-400 pt-0.5 transition hover:bg-zinc-300 dark:border-zinc-500 hover:dark:bg-zinc-600"
                    href=""
                >
                    <div class="flex items-center relative top-2">
                        <span class="relative -top-1"><Icon icon=remixicon::RiCupMapLine width="18px" height="18px" /></span>
                        <span class="relative -top-1 ml-1 text-xl">0</span>
                    </div>
                    <span class="relative -top-1.5">"Blogs"</span>
                </A>
                <A
                    class="flex h-[65px] w-1/3 flex-col items-center justify-center pt-0.5 transition hover:bg-zinc-300 hover:dark:bg-zinc-600"
                    href=""
                >
                    <div class="flex items-center relative top-2">
                        <span class="relative -top-1"><Icon icon=remixicon::RiEyeSystemLine width="18px" height="18px" /></span>
                        <span class="relative -top-1 ml-1 text-xl">0</span>
                    </div>
                    <span class="relative -top-1.5">"Follows"</span>
                </A>
            </div>
        </div>
        <div class="my-2" />
        <div
            class="flex w-full flex-col overflow-hidden rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25"
        >
            <A
                class="flex items-center border-b border-zinc-400 px-4 py-3 transition hover:bg-zinc-300/75 dark:border-zinc-500 dark:hover:bg-zinc-600/75"
                href=""
            >
                <span class="relative mr-2">
                    <Icon icon=remixicon::RiBook2DocumentLine width="24px" height="24px" />
                </span>
                <span class="flex-1 relative top-0.5">"Create New Work"</span>
                <span class="relative text-zinc-400 dark:text-zinc-500">
                    <Icon icon=remixicon::RiLinksBusinessLine width="20px" height="20px" />
                </span>
            </A>
            <A
                class="flex items-center px-4 py-3 transition hover:bg-zinc-300/75 dark:hover:bg-zinc-600/75"
                href=""
            >
                <span class="relative mr-2">
                    <Icon icon=remixicon::RiCupMapLine width="24px" height="24px" />
                </span>
                <span class="flex-1 relative top-0.5">"Create New Blog"</span>
                <span class="relative text-zinc-400 dark:text-zinc-500">
                    <Icon icon=remixicon::RiLinksBusinessLine width="20px" height="20px" />
                </span>
            </A>
        </div>
        <div class="my-2" />
        <div
            class="flex w-full flex-col overflow-hidden rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25"
        >
            <A
                class="flex items-center px-4 py-3 transition hover:bg-zinc-300/75 dark:hover:bg-zinc-600/75"
                href="/switch-profile"
            >
                <span class="relative mr-2">
                    <Icon icon=remixicon::RiGroupUserFacesLine width="24px" height="24px" />
                </span>
                <span class="flex-1 relative top-0.5">"Switch Profile"</span>
                <span class="relative text-zinc-400 dark:text-zinc-500">
                    <Icon icon=remixicon::RiArrowLeftRightArrowsLine width="20px" height="20px" />
                </span>
            </A>
        </div>
        <div class="my-2" />
        <div
            class="flex w-full flex-col overflow-hidden rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25"
        >
            <A
                class="flex items-center px-4 py-3 transition hover:bg-zinc-300/75 dark:hover:bg-zinc-600/75 border-b border-zinc-400 dark:border-zinc-500"
                href="/settings/about"
            >
                <span class="relative mr-2">
                    <Icon icon=remixicon::RiSettings6SystemLine width="24px" height="24px" />
                </span>
                <span class="flex-1 relative top-0.5">"Settings"</span>
                <span class="relative text-zinc-400 dark:text-zinc-500">
                    <Icon icon=remixicon::RiLinksBusinessLine width="20px" height="20px" />
                </span>
            </A>
            <button
                class="flex items-center px-4 py-3 transition hover:bg-zinc-300/75 dark:hover:bg-zinc-600/75"
                on:click=move |_| set_curr_panel(Panel::LogOut)
            >
                <span class="relative mr-2">
                    <Icon icon=remixicon::RiLogoutBoxSystemLine width="24px" height="24px" />
                </span>
                <span class="flex-1 text-left relative top-0.5">"Log Out"</span>
                <span class="relative text-zinc-400 dark:text-zinc-500">
                    <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                </span>
            </button>
        </div>
    }
}

#[component]
pub fn QuickSettingsPanel(set_curr_panel: WriteSignal<Panel>) -> impl IntoView {
    let (app, set_app, _) = use_local_storage::<AppState, JsonCodec>("app");

    view! {
        <div class="flex items-center mb-4">
            <Button
                id="back-button".to_string()
                title="Go Back".to_string()
                on:click=move |_| set_curr_panel(Panel::Main)
            >
                <span class="button-icon"><Icon icon=remixicon::RiArrowLeftSArrowsLine /></span>
                <span class="button-text">"Back"</span>
            </Button>
        </div>

        <h3 class="relative left-2">Color</h3>
        <div class="mb-4 flex flex-col items-center p-4 rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25">
            <h3 class="all-small-caps mb-4 text-xl" style="color: var(--text-color);">
                {move || app().theme.to_string()}
            </h3>
            <div class="flex items-center justify-center">
                <For
                    each=Theme::iter
                    key=|n| *n
                    let:theme
                >
                    <div class=format!("mx-1 {theme}") title=format!("{theme}")>
                        <button
                            class="flex items-center justify-center h-12 w-12 rounded-full border bg-accent"
                            on:click=move |_| set_app(AppState { theme, ..app() })
                        >
                            <Show when=move || app().theme == theme>
                                <span class="relative text-white">
                                    <Icon icon=remixicon::RiCheckSystemLine width="20px" height="20px" />
                                </span>
                            </Show>
                        </button>
                    </div>
                </For>
            </div>
        </div>

        <h3 class="relative left-2">Brightness</h3>
        <div class="mb-4 flex items-center justify-center p-4 rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25">
            <button
                class="flex flex-col items-center justify-center pt-0.5 border-2 border-zinc-400 dark:border-white rounded-lg mx-2 w-[80px] h-[68px]"
                class:text-white=move || app().brightness_mode == BrightnessMode::System
                class:bg-accent=move || app().brightness_mode == BrightnessMode::System
                on:click=move |_| set_app(AppState { brightness_mode: BrightnessMode::System, ..app() })
            >
                {move || {
                    if app().brightness_mode == BrightnessMode::System {
                        view! { <Icon icon=remixicon::RiComputerDeviceFill width="24px" height="24px" /> }
                    } else {
                        view! { <Icon icon=remixicon::RiComputerDeviceLine width="24px" height="24px" /> }
                    }
                }}
                <span class="all-small-caps font-bold">"System"</span>
            </button>
            <button
                class="flex flex-col items-center justify-center pt-0.5 border-2 border-zinc-400 dark:border-white rounded-lg mx-2 w-[80px] h-[68px]"
                class:text-white=move || app().brightness_mode == BrightnessMode::Light
                class:bg-accent=move || app().brightness_mode == BrightnessMode::Light
                on:click=move |_| set_app(AppState { brightness_mode: BrightnessMode::Light, ..app() })
            >
                {move || {
                    if app().brightness_mode == BrightnessMode::Light {
                        view! { <Icon icon=remixicon::RiSunWeatherFill width="24px" height="24px" /> }
                    } else {
                        view! { <Icon icon=remixicon::RiSunWeatherLine width="24px" height="24px" /> }
                    }
                }}
                <span class="all-small-caps font-bold">"Light"</span>
            </button>
            <button
                class="flex flex-col items-center justify-center pt-0.5 border-2 border-zinc-400 dark:border-white rounded-lg mx-2 w-[80px] h-[68px]"
                class:text-white=move || app().brightness_mode == BrightnessMode::Dark
                class:bg-accent=move || app().brightness_mode == BrightnessMode::Dark
                on:click=move |_| set_app(AppState { brightness_mode: BrightnessMode::Dark, ..app() })
            >
                {move || {
                    if app().brightness_mode == BrightnessMode::Dark {
                        view! { <Icon icon=remixicon::RiMoonClearWeatherFill width="24px" height="24px" /> }
                    } else {
                        view! { <Icon icon=remixicon::RiMoonClearWeatherLine width="24px" height="24px" /> }
                    }
                }}
                <span class="all-small-caps font-bold">"Dark"</span>
            </button>
        </div>
    }
}

#[component]
pub fn LogOutPanel(set_curr_panel: WriteSignal<Panel>) -> impl IntoView {
    view! {
        <div class="flex items-center">
            <Button
                id="back-button".to_string()
                title="Go Back".to_string()
                on:click=move |_| set_curr_panel(Panel::Main)
            >
                <span class="button-icon"><Icon icon=remixicon::RiArrowLeftSArrowsLine /></span>
                <span class="button-text">"Back"</span>
            </Button>
        </div>
        <div class="mx-4 mb-4 mt-8 flex flex-col">
            <h2 class="mb-8 text-center text-3xl">"Log Out"</h2>
            <p
                class="mb-8 text-center"
                style="font-family: var(--body-text); color: var(--text-color)"
            >
                "Are you sure you want to log out?"
            </p>
            <Button
                id="yes-button".to_string()
                title="Yes".to_string()
                kind=KindOfButton::Primary
                full_width=true
            >
                <span class="button-icon"><Icon icon=remixicon::RiCheckSystemLine /></span>
                <span class="button-text">"Yes"</span>
            </Button>
            <div class="my-1" />
            <Button
                id="no-button".to_string()
                title="No".to_string()
                kind=KindOfButton::Normal
                full_width=true
            >
                <span class="button-icon"><Icon icon=remixicon::RiCloseSystemLine /></span>
                <span class="button-text">"No"</span>
            </Button>
        </div>
    }
}