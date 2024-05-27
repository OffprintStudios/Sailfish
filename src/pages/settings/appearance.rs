use leptos::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use leptos_use::storage::use_local_storage;
use leptos_use::utils::JsonCodec;
use strum::IntoEnumIterator;
use crate::state::AppState;
use crate::models::util::{Theme, BrightnessMode};

#[component]
pub fn AppearanceSettings() -> impl IntoView {
    let (app, set_app, _) = use_local_storage::<AppState, JsonCodec>("app");
    
    view! {
        <div class="flex flex-col gap-4 p-6">
            <div>
                <h3 class="relative left-2">Color</h3>
                <div class="mb-4 flex flex-col items-center p-4 rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25">
                    <h3 class="all-small-caps mb-4 text-xl" style="color: var(--text-color);">
                        {move || app().theme.to_string()}
                    </h3>
                    <div class="flex items-center justify-center">
                        <For
                            each=Theme::iter
                            key=|n| *n
                            let:theme
                        >
                            <div class=format!("mx-1 {theme}") title=format!("{theme}")>
                                <button
                                    class="flex items-center justify-center h-12 w-12 rounded-full border bg-accent"
                                    on:click=move |_| set_app(AppState { theme, ..app() })
                                >
                                    <Show when=move || app().theme == theme>
                                        <span class="relative text-white">
                                            <Icon icon=remixicon::RiCheckSystemLine width="20px" height="20px" />
                                        </span>
                                    </Show>
                                </button>
                            </div>
                        </For>
                    </div>
                </div>
            </div>
            <div>
                <h3 class="relative left-2">Brightness</h3>
                <div class="mb-4 flex items-center justify-center p-4 rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25">
                    <button
                        class="flex flex-col items-center justify-center pt-0.5 border-2 border-zinc-400 dark:border-white rounded-lg mx-2 w-[80px] h-[68px]"
                        class:text-white=move || app().brightness_mode == BrightnessMode::System
                        class:bg-accent=move || app().brightness_mode == BrightnessMode::System
                        on:click=move |_| set_app(AppState { brightness_mode: BrightnessMode::System, ..app() })
                    >
                        {move || {
                            if app().brightness_mode == BrightnessMode::System {
                                view! { <Icon icon=remixicon::RiComputerDeviceFill width="24px" height="24px" /> }
                            } else {
                                view! { <Icon icon=remixicon::RiComputerDeviceLine width="24px" height="24px" /> }
                            }
                        }}
                        <span class="all-small-caps font-bold">"System"</span>
                    </button>
                    <button
                        class="flex flex-col items-center justify-center pt-0.5 border-2 border-zinc-400 dark:border-white rounded-lg mx-2 w-[80px] h-[68px]"
                        class:text-white=move || app().brightness_mode == BrightnessMode::Light
                        class:bg-accent=move || app().brightness_mode == BrightnessMode::Light
                        on:click=move |_| set_app(AppState { brightness_mode: BrightnessMode::Light, ..app() })
                    >
                        {move || {
                            if app().brightness_mode == BrightnessMode::Light {
                                view! { <Icon icon=remixicon::RiSunWeatherFill width="24px" height="24px" /> }
                            } else {
                                view! { <Icon icon=remixicon::RiSunWeatherLine width="24px" height="24px" /> }
                            }
                        }}
                        <span class="all-small-caps font-bold">"Light"</span>
                    </button>
                    <button
                        class="flex flex-col items-center justify-center pt-0.5 border-2 border-zinc-400 dark:border-white rounded-lg mx-2 w-[80px] h-[68px]"
                        class:text-white=move || app().brightness_mode == BrightnessMode::Dark
                        class:bg-accent=move || app().brightness_mode == BrightnessMode::Dark
                        on:click=move |_| set_app(AppState { brightness_mode: BrightnessMode::Dark, ..app() })
                    >
                        {move || {
                            if app().brightness_mode == BrightnessMode::Dark {
                                view! { <Icon icon=remixicon::RiMoonClearWeatherFill width="24px" height="24px" /> }
                            } else {
                                view! { <Icon icon=remixicon::RiMoonClearWeatherLine width="24px" height="24px" /> }
                            }
                        }}
                        <span class="all-small-caps font-bold">"Dark"</span>
                    </button>
                </div>
            </div>
        </div>
    }
}