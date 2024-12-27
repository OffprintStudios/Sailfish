use codee::string::JsonSerdeCodec;
use leptos::prelude::*;
use leptos_icons::*;
use icondata as TablerIcon;
use leptos_router::components::A;
use leptos_use::storage::use_local_storage;
use crate::models::accounts::Profile;
use crate::store::auth_store::AuthStore;
use super::search_bar::SearchBar;
use super::guide::Guide;

#[component]
pub fn Nav() -> impl IntoView {
    let (curr_profile, set_curr_profile) = signal::<Option<Profile>>(None);

    Effect::new(move |_| {
        let (auth, _, _) = use_local_storage::<AuthStore, JsonSerdeCodec>("auth");
        set_curr_profile(auth().current_profile);
    });

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
                    <Show
                        when=move || curr_profile().is_some()
                        fallback=|| view! {
                            <A
                                attr:class="flex items-center text-white px-3 py-2 firefox:text-sm rounded-xl transition hover:bg-zinc-300/25 hover:backdrop-blur"
                                href="/log-in"
                            >
                                <span class="relative"><Icon icon=TablerIcon::TbLogin2 width="20px" height="20px" /></span>
                                <span class="hidden md:block all-small-caps font-bold tracking-wider ml-1.5">"Log In"</span>
                            </A>
                        }
                    >
                        <button class="hidden md:flex items-center text-white mx-0.5 px-2 py-2 firefox:text-sm rounded-xl transition hover:bg-zinc-300/25 hover:backdrop-blur">
                            <span><Icon icon=TablerIcon::TbBooks width="24px" height="24px" /></span>
                            <span class="top-0.5 ml-1.5 hidden lg:block">"27"</span>
                        </button>
                        <button class="hidden md:flex items-center text-white mx-0.5 px-2 py-2 firefox:text-sm rounded-xl transition hover:bg-zinc-300/25 hover:backdrop-blur">
                            <span><Icon icon=TablerIcon::TbMailbox width="24px" height="24px" /></span>
                            <span class="top-0.5 ml-1.5 hidden lg:block">"1.2k"</span>
                        </button>
                        <Guide profile=curr_profile().unwrap() />
                    </Show>
                </div>
            </nav>
        </div>
    }
}
