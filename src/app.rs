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
use crate::client::pages::explore::ExploreRoutes;
use crate::client::pages::social::SocialRoutes;
use crate::client::pages::docs::DocsRoutes;
use crate::client::pages::auth::AuthRoutes;
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
                        <ExploreRoutes />
                        <SocialRoutes />
                        <DocsRoutes />
                    </Route>
                    <AuthRoutes />
                </Routes>
            </main>
        </Router>
    }
}
