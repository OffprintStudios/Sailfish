use leptos::prelude::*;
use leptos_icons::*;
use icondata as TablerIcon;
use leptos_router::components::A;
use super::search_bar::SearchBar;

#[component]
pub fn Nav() -> impl IntoView {
    view! {
        <div
            class="sticky top-0 w-full z-50 drop-shadow-2xl border-b border-white border-opacity-25 backdrop-blur-lg bg-accent shadow-small-shadow"
        >
            <nav class="flex items-center max-w-[90rem] h-[65px] w-full md:w-11/12 pl-4 pr-2 md:px-0 mx-auto relative">
                <div class="flex items-center w-1/3 text-white">
                    <A href="/"><h3 class="text-2xl font-bold tracking-tighter text-white">"Offprint"</h3></A>
                    <A
                        attr:class="hidden md:block relative top-0.5 text-white ml-4 all-small-caps text-lg firefox:text-base border-b-2 border-transparent [&[aria-current=page]]:border-zinc-300/75 transition font-semibold font-header hover:border-zinc-300/75"
                        href="/explore"
                    >
                        "Explore"
                    </A>
                    <A
                        attr:class="hidden md:block relative top-0.5 text-white ml-4 all-small-caps text-lg firefox:text-base border-b-2 border-transparent [&[aria-current=page]]:border-zinc-300/75 transition font-semibold font-header hover:border-zinc-300/75"
                        href="/social"
                    >
                        "Social"
                    </A>
                </div>
                <div class="w-1/3">
                    <SearchBar />
                </div>
                <div class="w-1/3 flex items-center relative" style="font-family: var(--header-text);">
                    <div class="flex-1"></div>
                    <A
                        attr:class="flex lg:hidden items-center text-white px-3 py-2 firefox:text-sm rounded-xl transition hover:bg-zinc-300/25 hover:backdrop-blur"
                        href="/search"
                    >
                        <span class="relative"><Icon icon=TablerIcon::TbSearch width="20px" height="20px" /></span>
                    </A>
                    <div class="mx-0.5">/* spacer */</div>
                    <A
                        attr:class="flex items-center text-white px-3 py-2 firefox:text-sm rounded-xl transition hover:bg-zinc-300/25 hover:backdrop-blur"
                        href="/log-in"
                    >
                        <span class="relative"><Icon icon=TablerIcon::TbLogin2 width="20px" height="20px" /></span>
                        <span class="hidden md:block all-small-caps font-bold tracking-wider ml-1.5">"Log In"</span>
                    </A>
                </div>
            </nav>
        </div>
    }
}
