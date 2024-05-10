mod about;
mod constitution;
mod omnibus;
mod privacy_policy;
mod terms_of_service;

pub use about::About;
pub use constitution::Constitution;
pub use omnibus::Omnibus;
pub use privacy_policy::PrivacyPolicy;
pub use terms_of_service::TermsOfService;

use leptos::*;
use leptos_router::Outlet;

#[component]
pub fn DocsLayout() -> impl IntoView {
    view! {
        <article class="prose prose-base dark:text-white dark:prose-strong:text-white dark:prose-a:text-accent mx-auto my-12 w-11/12">
            <Outlet />
        </article>
    }
}