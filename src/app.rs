use leptos::*;
use leptos_meta::*;
use leptos_router::*;
use crate::pages::{HomeLayout, HomePage};
use crate::pages::explore::ExplorePage;
use crate::pages::auth::AuthLayout;
use crate::pages::auth::log_in::LogIn;
use crate::pages::auth::sign_up::SignUp;
use crate::pages::auth::check_email::CheckEmail;

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

        // content for this welcome page
        <Router>
            <main class="crimson">
                <Routes>
                    <Route path="/" view=HomeLayout>
                        <Route path="" view=HomePage />
                        <Route path="explore" view=ExplorePage />
                    </Route>
                    <Route path="auth" view=AuthLayout>
                        <Route path="log-in" view=LogIn />
                        <Route path="sign-up" view=SignUp />
                        <Route path="check-email" view=CheckEmail />
                    </Route>
                    <Route path="/*any" view=NotFound/>
                </Routes>
            </main>
        </Router>
    }
}

/// 404 - Not Found
#[component]
fn NotFound() -> impl IntoView {
    // set an HTTP status code 404
    // this is feature gated because it can only be done during
    // initial server-side rendering
    // if you navigate to the 404 page subsequently, the status
    // code will not be set because there is not a new HTTP request
    // to the server
    #[cfg(feature = "ssr")]
    {
        // this can be done inline because it's synchronous
        // if it were async, we'd use a server function
        let resp = expect_context::<leptos_actix::ResponseOptions>();
        resp.set_status(actix_web::http::StatusCode::NOT_FOUND);
    }

    view! {
        <h1>"Not Found"</h1>
    }
}
