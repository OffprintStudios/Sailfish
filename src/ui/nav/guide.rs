use leptos::*;
use crate::models::accounts::Profile;

#[component]
pub fn Guide(profile: Profile) -> impl IntoView {
    let is_open = create_rw_signal(false);

    view! {
        <button class="relative mx-1 md:mr-0 transition transform hover:scale-110">
            <div class="absolute top-0 right-0">
                <div class="w-[13px] h-[13px] bg-rose-500 rounded-full" style="box-shadow: var(--dropshadow);">
                    <div class="w-full h-full bg-rose-500 animate-ping rounded-full" />
                </div>
            </div>
            <div class="w-[40px] h-[40px] rounded-full border-2 border-white overflow-hidden">
                <img src=profile.avatar class="w-full h-full object-cover" />
            </div>
        </button>
    }
}