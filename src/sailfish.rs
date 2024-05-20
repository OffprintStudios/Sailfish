use crate::error_template::{SailfishError, ErrorTemplate};
use leptos::*;
use leptos_meta::*;
use leptos_router::*;
use leptos_use::storage::use_local_storage;
use leptos_use::{use_css_var, use_preferred_dark};
use leptos_use::utils::JsonCodec;
use crate::models::util::BrightnessMode;
use crate::pages::{BaseLayout, Home};
use crate::pages::explore::Explore;
use crate::pages::search::Search;
use crate::pages::docs::DocsRoutes;
use crate::pages::auth::AuthRoutes;
use crate::state::AppState;

#[component]
pub fn Sailfish() -> impl IntoView {
    let (app, _, _) = use_local_storage::<AppState, JsonCodec>("app");
    let is_preferred_dark = use_preferred_dark();
    let (accent, _) = use_css_var("--accent");
    
    let classes = move || {
        let state = app.get();
        let preferred_dark = is_preferred_dark.get();
        if state.brightness_mode == BrightnessMode::System {
            match preferred_dark {
                true => format!("{} {}", BrightnessMode::Dark, state.theme),
                false => format!("{} {}", BrightnessMode::Light, state.theme),
            }
        } else {
            format!("{} {}", state.brightness_mode, state.theme)
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
        
        // sets the theme color
        <Meta name="theme-color" content=move || format!("rgb({})", accent.get()) />

        // content for this welcome page
        <Router fallback=|| {
            let mut outside_errors = Errors::default();
            outside_errors.insert_with_default_key(SailfishError::NotFound);
            view! {
                <ErrorTemplate outside_errors/>
            }
        }>
            <main>
                <Routes>
                    <Route path="/" view=BaseLayout>
                        <Route path="" view=Home />
                        <Route path="explore" view=Explore />
                        <Route path="search" view=Search />
                        <DocsRoutes />
                    </Route>
                    <AuthRoutes />
                </Routes>
            </main>
        </Router>
    }
}

cfg_if::cfg_if! {
    if #[cfg(feature = "ssr")] {
        use axum::async_trait;
        use axum::extract::{FromRef, FromRequestParts};
        use http::request::Parts;
        use leptos::LeptosOptions;
        use sqlx::{Pool, Postgres};

        #[derive(Debug, Clone, FromRef)]
        pub struct SailfishState {
            pub db: Pool<Postgres>,
            pub leptos_options: LeptosOptions,
        }

        #[async_trait]
        impl<S> FromRequestParts<S> for SailfishState
        where
            Self: FromRef<S>,
            S: Send + Sync {
            type Rejection = ();

            async fn from_request_parts(_: &mut Parts, state: &S) -> Result<Self, Self::Rejection> {
                Ok(Self::from_ref(state))
            }
        }
    }
}
