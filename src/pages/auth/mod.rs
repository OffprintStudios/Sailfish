mod log_in;
mod sign_up;
mod check_email;
mod switch_profile;
mod confirm_email;
mod create_profile;

pub use log_in::LogIn;
pub use sign_up::SignUp;
pub use check_email::CheckEmail;
pub use switch_profile::SwitchProfile;
pub use confirm_email::ConfirmEmail;
pub use create_profile::CreateProfile;

use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;

#[component(transparent)]
pub fn AuthRoutes() -> impl IntoView { 
    view! {
        <Route path="/" view=AuthLayout>
            <Route path="log-in" view=LogIn />
            <Route path="sign-up" view=SignUp />
            <Route path="check-email" view=CheckEmail />
            <Route path="confirm-email" view=ConfirmEmail />
            <Route path="switch-profile" view=SwitchProfile ssr=SsrMode::PartiallyBlocked />
            <Route path="create-profile" view=CreateProfile ssr=SsrMode::PartiallyBlocked />
        </Route>
    }
}

#[component]
pub fn AuthLayout() -> impl IntoView {
    view! {
        <div
            class="flex flex-col items-center justify-center w-full h-[100svh] bg-cover bg-center relative z-0"
            style="background-image: url('/images/mountains.jpg')"
        >
            <div class="absolute top-4 left-4 z-50">
                <A href="/">
                    <span><Icon icon=remixicon::RiCloseSystemLine width="32px" height="32px" style="color: rgb(228 228 231 / 0.75);" /></span>
                </A>
            </div>
            <Outlet />
        </div>
    }
}