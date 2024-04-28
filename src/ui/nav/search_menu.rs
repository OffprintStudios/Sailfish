 use leptos::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use rand::seq::SliceRandom;
use crate::models::util::DEFAULT_SLOGANS;

#[component]
pub fn SearchMenu() -> impl IntoView {
    let currSlogan = DEFAULT_SLOGANS.choose(&mut rand::thread_rng()).unwrap_or_else(|| &"For The Stories Left To Tell");

    view! {
        <div class="w-full relative">
            <button
                class="hidden md:flex w-11/12 h-[36px] mx-auto items-center justify-center rounded-xl border-2 border-x-transparent border-t-transparent border-zinc-300 bg-zinc-300/40 backdrop-blur py-1 text-white transition firefox:bg-accent-light hover:firefox:bg-accent-light/75"
            >
                <span class="mr-2 relative"><Icon icon=remixicon::RiSearchEyeSystemLine width="18px" height="18px" /></span>
                <span class="text-xs">{*currSlogan}</span>
            </button>
        </div>
    }
}