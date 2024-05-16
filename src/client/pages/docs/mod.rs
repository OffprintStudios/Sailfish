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
use leptos_router::*;

#[component(transparent)]
pub fn DocsRoutes() -> impl IntoView {
    view! {
        <Route path="docs" view=DocsLayout>
            <Route path="about" view=About />
            <Route path="constitution" view=Constitution />
            <Route path="omnibus" view=Omnibus />
            <Route path="privacy-policy" view=PrivacyPolicy />
            <Route path="terms-of-service" view=TermsOfService />
        </Route>
    }
}

#[component]
pub fn DocsLayout() -> impl IntoView {
    view! {
        <article class="prose prose-base dark:text-white dark:prose-strong:text-white dark:prose-a:text-accent mx-auto my-12 w-11/12">
            <Outlet />
        </article>
    }
}