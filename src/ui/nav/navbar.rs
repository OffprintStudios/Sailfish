use codee::string::JsonSerdeCodec;
use leptos::prelude::*;
use leptos_icons::*;
use icondata as TablerIcon;
use leptos_router::components::A;
use leptos_use::storage::use_local_storage;
use crate::models::accounts::ProfileObject;
use crate::store::auth_store::AuthStore;
use super::search_bar::SearchBar;
use super::guide::Guide;
use crate::ui::misc::Modal;

#[component]
pub fn Nav() -> impl IntoView {
    let (curr_profile, set_curr_profile) = signal::<Option<ProfileObject>>(None);
    let (open_create, set_open_create) = signal(false);

    Effect::new(move |_| {
        let (auth, _, _) = use_local_storage::<AuthStore, JsonSerdeCodec>("auth");
        set_curr_profile(auth().current_profile);
    });

    view! {
        <div
            class="sticky top-0 w-full z-50 drop-shadow-2xl border-b border-white/25 backdrop-blur-lg bg-accent shadow-small-shadow"
        >
            <nav class="flex items-center max-w-[90rem] h-[65px] w-full md:w-11/12 pl-4 pr-2 md:px-0 mx-auto relative">
                <div class="flex items-center w-1/3 text-white">
                    <A href="/"><h3 class="text-2xl font-bold tracking-tighter text-white!">"Offprint"</h3></A>
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
                                <span class="hidden md:block all-small-caps font-semibold tracking-wider ml-1.5 text-sm">"Log In"</span>
                            </A>
                        }
                    >
                        <button 
                            class="hidden md:flex items-center text-white mx-1.5 px-4 py-2 firefox:text-sm rounded-full transition bg-zinc-300/25 hover:bg-zinc-300/50 hover:backdrop-blur cursor-pointer"
                            on:click=move |_| set_open_create(true)
                        >
                            <span><Icon icon=TablerIcon::TbLoader width="24px" height="24px" /></span>
                            <span class="top-[0.075rem] relative ml-1.5 hidden lg:block all-small-caps font-semibold text-lg font-header">"Create"</span>
                        </button>
                        <Modal
                            id="create-menu"
                            open=open_create
                            set_open=set_open_create
                        >
                            <div class="flex flex-col items-center justify-center p-8">
                                <h1 class="text-4xl">"Create Something New"</h1>
                                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold font-header text-center">
                                    "A whole slew of worlds bristle at your fingertips—"<br/>"Where should we begin?"
                                </span>
                                <div class="flex items-center mt-8">
                                    <A href="/create/original-works" attr:class="flex flex-col items-center justify-center min-w-[196px] min-h-[167px] p-8 rounded-xl bg-zinc-300/50 dark:bg-zinc-600/50 transition hover:bg-zinc-500/50 dark:hover:bg-zinc-400/50">
                                        <span><Icon icon=TablerIcon::TbFeather width="75px" height="75px" /></span>
                                        <span class="text-lg font-semibold tracking-wide all-small-caps">"Original Work"</span>
                                    </A>
                                    <div class="mx-1"></div>
                                    <A href="/create/fan-works" attr:class="flex flex-col items-center justify-center min-w-[196px] min-h-[167px] p-8 rounded-xl bg-zinc-300/50 dark:bg-zinc-600/50 transition hover:bg-zinc-500/50 dark:hover:bg-zinc-400/50">
                                        <span><Icon icon=TablerIcon::TbMoodCrazyHappy width="75px" height="75px" /></span>
                                        <span class="text-lg font-semibold tracking-wide all-small-caps">"Fan Work"</span>
                                    </A>
                                    <div class="mx-1"></div>
                                    <A href="/create/blogs" attr:class="flex flex-col items-center justify-center min-w-[196px] min-h-[167px] p-8 rounded-xl bg-zinc-300/50 dark:bg-zinc-600/50 transition hover:bg-zinc-500/50 dark:hover:bg-zinc-400/50">
                                        <span><Icon icon=TablerIcon::TbCoffee width="75px" height="75px" /></span>
                                        <span class="text-lg font-semibold tracking-wide all-small-caps">"Blog"</span>
                                    </A>
                                </div>
                                <A attr:class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/create">
                                    "See Overview"
                                </A>
                            </div>
                        </Modal>
                        <Guide profile=curr_profile().unwrap() />
                    </Show>
                </div>
            </nav>
        </div>
    }
}