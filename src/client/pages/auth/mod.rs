mod log_in;
mod sign_up;
mod check_email;
mod forgot_password;
mod reset_password;
mod switch_profile;

pub use log_in::LogIn;
pub use sign_up::SignUp;
pub use check_email::CheckEmail;

use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;

#[component]
pub fn AuthLayout() -> impl IntoView {
    view! {
        <div
            class="flex flex-col items-center justify-center w-full h-screen bg-cover bg-center relative z-0"
            style="background-image: url('/images/mountains.jpg')"
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