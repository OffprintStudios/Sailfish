use leptos::prelude::*;
use rand::seq::SliceRandom;
use leptos_icons::*;
use icondata as TablerIcon;
use crate::models::util::slogans::DEFAULT_SLOGANS;

#[component]
pub fn SearchBar() -> impl IntoView {
    let currSlogan = DEFAULT_SLOGANS.choose(&mut rand::thread_rng()).unwrap_or(&"For The Stories Left To Tell");

    view! {
        <div class="w-full relative">
            <button
                class="hidden lg:flex w-11/12 h-[36px] mx-auto items-center justify-center rounded-xl border-2 border-x-transparent border-t-transparent border-zinc-300 bg-zinc-300/40 backdrop-blur py-1 text-white transition firefox:bg-accent-light hover:firefox:bg-accent-light/75"
            >
                <span class="mr-2 relative"><Icon icon=TablerIcon::TbSearch /></span>
                <span class="text-xs">{*currSlogan}</span>
            </button>
        </div>
    }
}