use leptos::either::Either;
use leptos::prelude::*;
use leptos::html::Button;
use leptos_router::components::A;
use leptos::reactive::computed;
use leptos_icons::*;
use icondata as TablerIcon;
use crate::models::accounts::Profile;
use crate::ui::misc::{RoleBadge, LinkBlock, LinkKind};

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
            class="[&:popover-open]:inset-[unset] [&:popover-open]:top-[66px] md:[&:popover-open]:w-[375px] [&:popover-open]:w-full [&:popover-open]:m-0 p-0 bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur border-b md:border-x border-zinc-600/25 dark:border-zinc-300/25 md:rounded-b-xl motion-opacity-in-0 motion-blur-in-md motion-duration-200"
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
        <div class="flex flex-col items-center justify-center w-full pb-4">
            <div class="h-16 w-full">
                {if let Some(banner_art) = profile.banner_art{
                    Either::Left(view! {
                        <img src=banner_art class="w-full h-16 object-cover" />
                    })
                } else {
                    Either::Right(view! {
                        <div class="w-full h-28 bg-gradient-to-b from-accent to-transparent"></div>
                    })
                }}
            </div>
            <div class="flex items-center w-full px-4">
                <img src=profile.avatar.clone() class="block w-[80px] h-[80px] object-cover rounded-full mr-2" />
                <div>
                    <h3 class="text-3xl relative top-0.5">{profile.username.clone()}</h3>
                    <RoleBadge roles=profile.roles />
                </div>
            </div>
            <div class="flex items-center w-full px-4 py-4 border-b border-zinc-300/75 dark:border-zinc-600/75">
                <LinkBlock
                    id="create-work"
                    title="Create Work"
                    href="/profile/id/username/works"
                    kind=LinkKind::Primary
                    full_width=true
                >
                    <span class="button-icon"><Icon icon=TablerIcon::TbWriting /></span>
                    <span class="button-text">"Create Work"</span>
                </LinkBlock>
                <div class="mx-1"></div>
                <LinkBlock
                    id="create-blog"
                    title="Create Blog"
                    href="/profile/id/username/blogs"
                    kind=LinkKind::Primary
                    full_width=true
                >
                    <span class="button-icon"><Icon icon=TablerIcon::TbCoffee /></span>
                    <span class="button-text">"Create Blog"</span>
                </LinkBlock>
            </div>
            <div class="flex flex-col w-full px-4 pt-4">
                <div class="flex flex-col w-full rounded-xl bg-zinc-300/75 dark:bg-zinc-600/75 overflow-hidden">
                    <div class="flex items-center w-full px-2 pt-2 pb-3 border-b border-zinc-500/50 dark:border-zinc-400/50">
                        <img src="/images/ashtree-lane.jpg" class="max-w-[50px] object-contain rounded-md mr-2" />
                        <div class="flex flex-col w-full">
                            <div class="flex items-center">
                                <span class="all-small-caps font-bold tracking-wide text-base">"Continue Reading"</span>
                                <span class="mx-1 relative top-0.5">"•"</span>
                                <span class="text-xs text-zinc-500 dark:text-zinc-400 font-default">"3 chapters left"</span>
                            </div>
                            <h6 class="text-lg relative -top-0.5">"The Chronicles of Ashtree Lane"</h6>
                            <span class="text-sm text-zinc-500 dark:text-zinc-400 relative -top-1.5">"by Figments"</span>
                            <progress id="reading-progress" value="73" max="100" class="w-full h-2 [&::-webkit-progress-bar]:rounded-lg [&::-webkit-progress-value]:rounded-lg [&::-webkit-progress-bar]:bg-zinc-500 dark:[&::-webkit-progress-bar]:bg-zinc-400 [&::-webkit-progress-value]:bg-accent [&::-moz-progress-bar]:bg-accent">"73%"</progress>
                        </div>
                    </div>
                    <A href="/library" attr:class="flex items-center px-4 py-2.5 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition">
                        <span class="all-small-caps tracking-wide font-bold">"View Library"</span>
                        <span class="flex-1"></span>
                        <span class="text-xs font-default text-zinc-500 dark:text-zinc-400">"27 updates"</span>
                        <span class="ml-0.5 text-zinc-500 dark:text-zinc-400 "><Icon icon=TablerIcon::TbBooks width="1.25rem" height="1.25rem" /></span>
                    </A>
                </div>
                <div class="my-1"></div>
                <div class="flex flex-col w-full rounded-xl bg-zinc-300/75 dark:bg-zinc-600/75 overflow-hidden">
                    <A href="/messages" attr:class="flex items-center px-4 py-2.5 border-b border-zinc-500/50 dark:border-zinc-400/50 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition">
                        <span class="mr-1"><Icon icon=TablerIcon::TbMailbox width="1.25rem" height="1.25rem" /></span>
                        <span class="relative top-0.5">"1.2k messages"</span>
                        <span class="flex-1"></span>
                        <span class="text-xs font-default text-zinc-500 dark:text-zinc-400">"8 unread"</span>
                    </A>
                    <A href="/notifications" attr:class="flex items-center px-4 py-2.5 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition">
                        <span class="mr-1"><Icon icon=TablerIcon::TbBellExclamation width="1.25rem" height="1.25rem" /></span>
                        <span class="relative top-0.5">"18 nudges"</span>
                        <span class="flex-1"></span>
                        <span class="text-xs font-default text-zinc-500 dark:text-zinc-400">"3 unchecked"</span>
                    </A>
                </div>
                <div class="my-1"></div>
                <div class="flex flex-col w-full rounded-xl bg-zinc-300/75 dark:bg-zinc-600/75 overflow-hidden">
                    <A href="/switch-profile" attr:class="flex items-center px-4 py-2.5 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition">
                        <span class="mr-1"><Icon icon=TablerIcon::TbSwitch3 width="1.25rem" height="1.25rem" /></span>
                        <span class="relative top-0.5">"Switch Profile"</span>
                        <span class="flex-1"></span>
                        <span class="text-zinc-500 dark:text-zinc-400"><Icon icon=TablerIcon::TbLink width="1.25rem" height="1.25rem" /></span>
                    </A>
                </div>
                <div class="my-1"></div>
                <div class="flex flex-col w-full rounded-xl bg-zinc-300/75 dark:bg-zinc-600/75 overflow-hidden">
                    <button class="flex items-center px-4 py-2.5 border-b border-zinc-500/50 dark:border-zinc-400/50 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition">
                        <span class="mr-1"><Icon icon=TablerIcon::TbSettings width="1.25rem" height="1.25rem" /></span>
                        <span class="relative top-0.5">"Settings"</span>
                        <span class="flex-1"></span>
                        <span class="text-zinc-500 dark:text-zinc-400"><Icon icon=TablerIcon::TbChevronRight width="1.25rem" height="1.25rem" /></span>
                    </button>
                    <button class="flex items-center px-4 py-2.5 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition">
                        <span class="mr-1"><Icon icon=TablerIcon::TbLogout2 width="1.25rem" height="1.25rem" /></span>
                        <span class="relative top-0.5">"Log Out"</span>
                        <span class="flex-1"></span>
                        <span class="text-zinc-500 dark:text-zinc-400"><Icon icon=TablerIcon::TbChevronRight width="1.25rem" height="1.25rem" /></span>
                    </button>
                </div>
            </div>
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