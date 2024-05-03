use crate::error_template::{AppError, ErrorTemplate};
use leptos::*;
use leptos_meta::*;
use leptos_router::*;
use crate::pages::{HomeLayout, HomePage};
use crate::pages::auth::{AuthLayout, LogIn, SignUp, CheckEmail};
use crate::pages::explore::{ExplorePage, NewsFeed, NewsPost, FandomFeed, GenreFeed};

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
        }>
            <main>
                <Routes>
                    <Route path="/" view=HomeLayout>
                        <Route path="" view=HomePage />
                        <Route path="explore" view=ExplorePage />
                        <Route path="news" view=NewsFeed />
                        <Route path="post/:id" view=NewsPost />
                        <Route path="post/:id/:title" view=NewsPost />
                        <Route path="genre/:id" view=GenreFeed />
                        <Route path="fandom/:id" view=FandomFeed />
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
