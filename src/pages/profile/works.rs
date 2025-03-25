use leptos::prelude::*;
use leptos_icons::*;
use leptos_router::hooks::use_params_map;
use icondata as TablerIcon;
use codee::string::JsonSerdeCodec;
use crate::store::auth_store::AuthStore;
use crate::ui::misc::{Button, LinkBlock, LinkKind};

#[component]
pub fn ProfileWorksPage() -> impl IntoView {
    let params = use_params_map();
    let id = move || params().get("id").unwrap();
    let (auth, _, _) = leptos_use::storage::use_local_storage::<AuthStore, JsonSerdeCodec>("auth");

    view! { 
        <div class="flex items-center h-[58px] bg-zinc-200/50 px-4 py-2 md:p-2 dark:bg-zinc-700/50 backdrop-blur-lg md:rounded-b-xl border-b md:border border-zinc-600/25 dark:border-zinc-300/25" style="box-shadow: var(--dropshadow);">
            <div class="flex items-center rounded-xl overflow-hidden max-w-[255px] h-[40px] bg-zinc-200 dark:bg-zinc-700">
                <input
                    id="work-search"
                    title="Search Works"
                    type="text"
                    placeholder="Search ..."
                    class="bg-zinc-300/25 dark:bg-zinc-600/25 backdrop-blur-lg border-0 focus:ring-0 w-full h-full"
                />
                <button class="h-full px-3 bg-zinc-300/25 dark:bg-zinc-600/25 backdrop-blur-lg hover:bg-zinc-300 dark:hover:bg-zinc-600 transition">
                    <span class="relative"><Icon icon=TablerIcon::TbSearch width="20px" height="20px" /></span>
                </button>
            </div>
            <div class="flex-1"></div>
            <div class="hidden md:flex items-center rounded-lg">
                <Button
                    id="grid-view"
                    title="Grid View"
                >
                    <span class="button-icon no-text"><Icon icon=TablerIcon::TbLayoutGrid /></span>
                </Button>
                <div class="mx-0.5"></div>
                <Button
                    id="list-view"
                    title="List View"
                >
                    <span class="button-icon no-text"><Icon icon=TablerIcon::TbListDetails /></span>
                </Button>
                <div class="hidden md:block mx-1 text-2xl text-zinc-400 dark:text-zinc-500 relative top-[0.075rem]">"|"</div>
                <div class="hidden md:block">
                    <Button
                        id="filter-button"
                        title="Filter Works"
                    >
                        <span class="button-icon"><Icon icon=TablerIcon::TbFilter /></span>
                        <span class="button-text">"Filter"</span>
                    </Button>
                </div>
                <Show
                    when=move || auth().current_profile.is_some_and(|c| c.id == id())
                >
                    <div class="mx-0.5"></div>
                    <LinkBlock
                        id="create-link"
                        title="Create Blog"
                        href="/stuff/create"
                        kind=LinkKind::Primary
                    >
                        <span class="button-icon"><Icon icon=TablerIcon::TbPlus /></span>
                        <span class="button-text">"Add"</span>
                    </LinkBlock>
                </Show>
            </div>
        </div>
    }
}