use leptos::*;
use leptos_icons::*;
use icondata_ri as remixicon;

#[component]
pub fn CheckEmail() -> impl IntoView {
    view! {
        <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll" style="box-shadow: var(--dropshadow);">
            <div class="flex flex-col items-center justify-center">
                <h1 class="text-3xl">"Check your inbox!"</h1>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8 font-header">
                    "We've sent a confirmation email."
                </span>
                <span><Icon icon=remixicon::RiMailCheckBusinessLine width="150px" height="150px" /></span>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pt-8 font-header">
                    "Your account will remain locked" <br/> "until you confirm it."
                </span>
                <a class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/auth/log-in">
                    "After that, just log on in!"
                </a>
            </div>
        </div>
    }
}