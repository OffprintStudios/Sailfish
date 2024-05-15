use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use crate::client::ui::util::{MetaTags, MetaTagOptions};

#[component]
pub fn CheckEmail() -> impl IntoView {
    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/check-email".to_string(),
        title: "Check Your Email — Offprint".to_string(),
        author_url: None,
        description: "For The Stories Left Untold".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };
    
    view! {
        <MetaTags options=meta_options />
        
        <div class="flex flex-col items-center justify-center bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit overflow-y-scroll" style="box-shadow: var(--dropshadow);">
            <div class="flex flex-col items-center justify-center">
                <h1 class="text-3xl">"Check your inbox!"</h1>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pb-8 font-header">
                    "We've sent a confirmation email."
                </span>
                <span><Icon icon=remixicon::RiMailCheckBusinessLine width="150px" height="150px" /></span>
                <span class="text-zinc-500 dark:text-zinc-400 text-lg font-bold text-center pt-8 font-header">
                    "Your account will remain locked" <br/> "until you confirm it."
                </span>
                <A class="text-center w-full pt-4 text-zinc-500 dark:text-zinc-400 text-sm hover:underline" href="/log-in">
                    "After that, just log on in!"
                </A>
            </div>
        </div>
    }
}