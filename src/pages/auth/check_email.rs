use leptos::prelude::*;
use leptos_router::components::A;
use leptos_icons::*;
use icondata as TablerIcon;
use crate::ui::misc::MetaTags;

#[component]
pub fn CheckEmailPage() -> impl IntoView {
    view! {
        <MetaTags
            url="https://offprint.cafe/check-email"
            title="Check Email — Offprint"
            description="For The Stories Left Untold"
            image_url="/images/beatriz.png"
        />
        
        <div class="flex flex-col items-center justify-center bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll" style="box-shadow: var(--dropshadow);">
            <div class="flex flex-col items-center justify-center">
                <h1 class="text-3xl">"Check your inbox!"</h1>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8 font-header">
                    "We've sent a confirmation email."
                </span>
                <span><Icon icon=TablerIcon::TbMailCheck width="150px" height="150px" /></span>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pt-8 font-header">
                    "Your account will remain locked" <br/> "until you confirm it."
                </span>
                <A attr:class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/log-in">
                    "After that, just log on in!"
                </A>
            </div>
        </div>
    }
}