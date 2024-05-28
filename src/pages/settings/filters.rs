use leptos::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use leptos_use::storage::use_local_storage;
use leptos_use::utils::JsonCodec;
use crate::state::AppState;
use crate::ui::util::{Button, KindOfButton};
use crate::ui::forms::Switch;

#[component]
pub fn FiltersSettings() -> impl IntoView {
    let (app, set_app, _) = use_local_storage::<AppState, JsonCodec>("app");

    view! {
         <div class="flex flex-col gap-4 p-6">
            <div>
                <h3 class="relative left-2">"Content Ratings"</h3>
                <Show
                    when=move || app().age_check
                    fallback=move || {
                        view! {
                            <div class="mb-4 flex flex-col items-center p-4 rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25">
                                <span>"Changing this setting may expose you to content not suitable for people under the age of 18."</span>
                                <span class="mb-4">"Are you sure you want to proceed?"</span>
                                <Button
                                    id="accept-terms-button".to_string()
                                    title="Accept Terms".to_string()
                                    kind=KindOfButton::Primary
                                    on:click=move |_| set_app(AppState { age_check: true, ..app() })
                                >
                                    <span class="button-icon"><Icon icon=remixicon::RiCheckSystemLine /></span>
                                    <span class="button-text">"Show Me The Money"</span>
                                </Button>
                            </div>
                        }
                    }
                >
                    <div class="flex flex-col">
                        <div class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-t-xl border-b border-zinc-600/25 dark:border-zinc-300/25">
                            <span class="flex-1">"Show Mature"</span>
                            <Switch />
                        </div>
                        <div class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-b-xl">
                            <span class="flex-1">"Show Explicit"</span>
                            <Switch />
                        </div>
                    </div>
                </Show>
            </div>
        </div>
    }
}