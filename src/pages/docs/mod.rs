mod about_page;
mod omnibus_page;
mod constitution_page;
mod terms_of_service_page;
mod privacy_policy_page;

pub use about_page::AboutPage;
pub use constitution_page::ConstitutionPage;
pub use omnibus_page::OmnibusPage;
pub use privacy_policy_page::PrivacyPolicyPage;
pub use terms_of_service_page::TermsOfServicePage;

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