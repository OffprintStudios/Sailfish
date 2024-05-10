use crate::error_template::{AppError, ErrorTemplate};
use leptos::*;
use leptos_meta::*;
use leptos_router::*;
use crate::client::pages::{DefaultLayout, Home};
use crate::client::pages::explore::{Explore, NewsFeed, NewsPost, GenreFeed, FandomFeed};
use crate::client::pages::docs::{DocsLayout, About, Constitution, Omnibus, PrivacyPolicy, TermsOfService};
use crate::client::pages::auth::{AuthLayout, LogIn, SignUp, CheckEmail};

#[component]
pub fn App() -> impl IntoView {
    // Provides context that manages stylesheets, titles, meta tags, etc.
    provide_meta_context();

    view! {


        // injects a stylesheet into the document <head>
        // id=leptos means cargo-leptos will hot-reload this stylesheet
        <Stylesheet id="leptos" href="/pkg/sailfish.css"/>

        // sets the document title
        <Title text="Offprint"/>
        
        <Body class="dark crimson" />

        // content for this welcome page
        <Router fallback=|| {
            let mut outside_errors = Errors::default();
            outside_errors.insert_with_default_key(AppError::NotFound);
            view! {
                <ErrorTemplate outside_errors/>
            }
            .into_view()
        }>
            <main>
                <Routes>
                    <Route path="/" view=DefaultLayout>
                        <Route path="" view=Home />
                        <Route path="explore" view=Explore />
                        <Route path="news" view=NewsFeed />
                        <Route path="post/:id" view=NewsPost />
                        <Route path="post/:id/:title" view=NewsPost />
                        <Route path="genre/:id" view=GenreFeed />
                        <Route path="fandom/:id" view=FandomFeed />
                        <Route path="docs" view=DocsLayout>
                            <Route path="about" view=About ssr=SsrMode::Async />
                            <Route path="constitution" view=Constitution ssr=SsrMode::Async />
                            <Route path="omnibus" view=Omnibus ssr=SsrMode::Async />
                            <Route path="privacy-policy" view=PrivacyPolicy ssr=SsrMode::Async />
                            <Route path="terms-of-service" view=TermsOfService ssr=SsrMode::Async />
                        </Route>
                    </Route>
                    <Route path="/" view=AuthLayout>
                        <Route path="log-in" view=LogIn />
                        <Route path="sign-up" view=SignUp />
                        <Route path="check-email" view=CheckEmail />
                    </Route>
                </Routes>
            </main>
        </Router>
    }
}
