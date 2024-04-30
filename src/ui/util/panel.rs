use leptos::*;

#[component]
pub fn Panel(children: Children) -> impl IntoView {
    view! {
        <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl w-full" style="box-shadow: var(--dropshadow);">
            {children()}
        </div>
    }
}