mod log_in;
mod sign_up;
mod check_email;
mod confirm_email;
mod reset_password;
mod switch_profile;
mod create_profile;
mod validate;

use leptos::prelude::*;
use leptos_icons::*;
use icondata as TablerIcon;
use leptos_router::components::{ParentRoute, A, Outlet, Route};
use leptos_router::{path, MatchNestedRoutes, SsrMode};
use log_in::LogInPage;
use sign_up::SignUpPage;
use check_email::CheckEmailPage;
use confirm_email::ConfirmEmailPage;
use reset_password::ResetPasswordPage;
use switch_profile::SwitchProfilePage;
use create_profile::CreateProfilePage;
use validate::validate;

#[component(transparent)]
pub fn AuthRoutes() -> impl MatchNestedRoutes + Clone {
    view! {
        <ParentRoute path=path!("/") view=AuthLayout>
            <Route path=path!("log-in") view=LogInPage />
            <Route path=path!("sign-up") view=SignUpPage />
            <Route path=path!("check-email") view=CheckEmailPage />
            <Route path=path!("confirm-email") view=ConfirmEmailPage />
            <Route path=path!("reset-password") view=ResetPasswordPage />
            <Route path=path!("switch-profile") view=SwitchProfilePage ssr=SsrMode::PartiallyBlocked />
            <Route path=path!("create-profile") view=CreateProfilePage ssr=SsrMode::PartiallyBlocked />
        </ParentRoute>
    }
    .into_inner()
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
                    <span><Icon icon=TablerIcon::TbSquareRoundedX width="32px" height="32px" style="color: rgb(228 228 231 / 0.75);" /></span>
                </A>
            </div>
            <Outlet />
        </div>
    }
}
