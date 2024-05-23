use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use leptos::html::Button;
use leptos_use::{use_element_bounding, use_media_query, use_window, UseElementBoundingReturn};
use crate::models::accounts::Profile;

#[component]
pub fn Guide(profile: Profile) -> impl IntoView {
    let button = create_node_ref::<Button>();
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
            class="crimson [&:popover-open]:inset-[unset] [&:popover-open]:top-[70px] md:[&:popover-open]:w-[375px] [&:popover-open]:w-full [&:popover-open]:m-0 p-4 bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur border border-zinc-600/25 dark:border-zinc-300/25 rounded-xl"
            style="box-shadow: var(--dropshadow); color: var(--text-color);"
            style:left=get_offset
            popover="auto"
        >
            <MainPanel profile=profile.clone() />
        </div>
    }
}

#[component]
pub fn MainPanel(profile: Profile) -> impl IntoView {
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
                <span class="flex-1 relative top-0.5">Create New Work</span>
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
                <span class="flex-1 relative top-0.5">Create New Blog</span>
                <span class="relative text-zinc-400 dark:text-zinc-500">
                    <Icon icon=remixicon::RiLinksBusinessLine width="20px" height="20px" />
                </span>
            </A>
        </div>
    }
}