use leptos::*;
use leptos_icons::*;
use icondata_ri as remixicon;

pub enum WorkCardWidth {
    Default,
    Auto,
}

#[component]
pub fn WorkCard(
    #[prop(default = WorkCardWidth::Default)] width: WorkCardWidth
) -> impl IntoView {
    let w = match width {
        WorkCardWidth::Default => "360px",
        WorkCardWidth::Auto => "100%"
    };

    view! {
        <div
            class="flex flex-col h-[256px] rounded-xl overflow-hidden bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur border border-zinc-600/25 dark:border-zinc-300/25 hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 transition"
            style="box-shadow: var(--dropshadow);"
            style:width=w
        >
            <div class="w-full h-[5rem] bg-accent">/* banner */</div>
            <div class="flex items-center px-4 pt-2">
                <div class="flex flex-col">
                    <span class="all-small-caps font-semibold">SPECULATIVE FICTION</span>
                    <h3 class="text-xl line-clamp-1 text-black dark:text-white">Roquelle Pellegnon, Mad Peer Reviewer</h3>
                    <span class="text-zinc-400 font-header">by baxil</span>
                </div>
            </div>
            <div class=" px-4 pb-4 pt-2 text-sm italic h-[56px]">
                <p class="line-clamp-2">
                    "It's time for Madame Pellegnon to put the science in Mad Science, and teach a peer some lessons about real scientific discovery."
                </p>
            </div>
            <div class="flex items-center px-4 pt-2">
                <div class="flex items-center text-sm text-green-600 font-bold">
                    <Icon icon=remixicon::RiThumbUpSystemLine />
                    <span class="ml-0.5">0</span>
                </div>
                <div class="mx-1">/* spacer */</div>
                <div class="flex items-center text-sm text-red-600 font-bold">
                    <Icon icon=remixicon::RiThumbDownSystemLine />
                    <span class="ml-0.5">0</span>
                </div>
                <div class="flex-1">/* spacer */</div>
                <div class="font-semibold text-zinc-400 text-xs">ORIGINAL</div>
            </div>
        </div>
    }
}