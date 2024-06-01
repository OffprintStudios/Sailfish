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
    let (theme, set_theme) = create_signal(Theme::Crimson);
    let (brightness, set_brightness) = create_signal(BrightnessMode::System);
    let (app, set_app, _) = use_local_storage::<AppState, JsonCodec>("app");
    
    create_effect(move |_| {
        set_theme(app().theme);
        set_brightness(app().brightness_mode);
    });
    
    view! {
        <div class="flex flex-col gap-4 p-6">
            <div>
                <h3 class="relative left-2">Color</h3>
                <div class="mb-4 flex flex-col items-center p-4 rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25">
                    <h3 class="all-small-caps mb-4 text-xl" style="color: var(--text-color);">
                        {move || theme().to_string()}
                    </h3>
                    <div class="flex items-center justify-center">
                        <For
                            each=Theme::iter
                            key=|n| *n
                            let:t
                        >
                            <div class=format!("mx-1 {t}") title=format!("{t}")>
                                <button
                                    class="flex items-center justify-center h-12 w-12 rounded-full border bg-accent"
                                    on:click=move |_| set_app(AppState { theme: t, ..app() })
                                >
                                    <Show when=move || theme() == t>
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
                        class:text-white=move || brightness() == BrightnessMode::System
                        class:bg-accent=move || brightness() == BrightnessMode::System
                        on:click=move |_| set_app(AppState { brightness_mode: BrightnessMode::System, ..app() })
                    >
                        {move || {
                            if brightness() == BrightnessMode::System {
                                view! { <Icon icon=remixicon::RiComputerDeviceFill width="24px" height="24px" /> }
                            } else {
                                view! { <Icon icon=remixicon::RiComputerDeviceLine width="24px" height="24px" /> }
                            }
                        }}
                        <span class="all-small-caps font-bold">"System"</span>
                    </button>
                    <button
                        class="flex flex-col items-center justify-center pt-0.5 border-2 border-zinc-400 dark:border-white rounded-lg mx-2 w-[80px] h-[68px]"
                        class:text-white=move || brightness() == BrightnessMode::Light
                        class:bg-accent=move || brightness() == BrightnessMode::Light
                        on:click=move |_| set_app(AppState { brightness_mode: BrightnessMode::Light, ..app() })
                    >
                        {move || {
                            if brightness() == BrightnessMode::Light {
                                view! { <Icon icon=remixicon::RiSunWeatherFill width="24px" height="24px" /> }
                            } else {
                                view! { <Icon icon=remixicon::RiSunWeatherLine width="24px" height="24px" /> }
                            }
                        }}
                        <span class="all-small-caps font-bold">"Light"</span>
                    </button>
                    <button
                        class="flex flex-col items-center justify-center pt-0.5 border-2 border-zinc-400 dark:border-white rounded-lg mx-2 w-[80px] h-[68px]"
                        class:text-white=move || brightness() == BrightnessMode::Dark
                        class:bg-accent=move || brightness() == BrightnessMode::Dark
                        on:click=move |_| set_app(AppState { brightness_mode: BrightnessMode::Dark, ..app() })
                    >
                        {move || {
                            if brightness() == BrightnessMode::Dark {
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