use crate::error_template::{AppError, ErrorTemplate};
use leptos::*;
use leptos_meta::*;
use leptos_router::*;
use leptos_use::storage::use_local_storage;
use leptos_use::{use_css_var, use_preferred_dark};
use leptos_use::utils::JsonCodec;
// use leptoaster::{Toaster, provide_toaster};
use crate::client::state::AppState;
use crate::client::pages::{DefaultLayout, Home};
use crate::client::pages::explore::{Explore, NewsFeed, NewsPost, GenreFeed, FandomFeed};
use crate::client::pages::docs::{DocsLayout, About, Constitution, Omnibus, PrivacyPolicy, TermsOfService};
use crate::client::pages::auth::{AuthLayout, LogIn, SignUp, CheckEmail, SwitchProfile};
use crate::client::util::modes::Mode;

#[component]
pub fn App() -> impl IntoView {
    // provide_toaster();

    let (app, _, _) = use_local_storage::<AppState, JsonCodec>("app");
    let is_preferred_dark = use_preferred_dark();
    let (accent, _) = use_css_var("--accent");

    let classes = move || {
        let state = app.get();
        let preferred_dark = is_preferred_dark.get();
        if state.mode == Mode::System {
            match preferred_dark {
                true => format!("{} {}", Mode::Dark, state.theme),
                false => format!("{} {}", Mode::Light, state.theme),
            }
        } else {
            format!("{} {}", state.mode, state.theme)
        }
    };

    // Provides context that manages stylesheets, titles, meta tags, etc.
    provide_meta_context();

    view! {
        <Html class=classes />

        // injects a stylesheet into the document <head>
        // id=leptos means cargo-leptos will hot-reload this stylesheet
        <Stylesheet id="leptos" href="/pkg/sailfish.css"/>

        // sets the document title
        <Title text="Offprint"/>

        <Meta name="theme-color" content=move || format!("rgb({})", accent.get()) />

        // <Toaster stacked=true />

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
                        <Route path="switch-profile" view=SwitchProfile ssr=SsrMode::Async />
                    </Route>
                </Routes>
            </main>
        </Router>
    }
}
