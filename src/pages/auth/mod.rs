pub mod log_in;
pub mod sign_up;
pub mod check_email;
pub mod forgot_password;
pub mod switch_profile;

use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;

#[component]
pub fn AuthLayout() -> impl IntoView {
    view! {
        <div
            class="flex flex-col items-center justify-center w-full h-screen bg-cover bg-center relative z-0"
            style="background-image: url('/assets/images/mountains.jpg')"
        >
            <div class="absolute top-4 left-4 hidden md:block">
                <A href="/">
                    <span><Icon icon=remixicon::RiCloseSystemLine width="32px" height="32px" style="color: rgb(228 228 231 / 0.75);" /></span>
                </A>
            </div>
            <Outlet />
        </div>
    }
}