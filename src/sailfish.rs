use crate::error_template::{SailfishError, ErrorTemplate};
use leptos::*;
use leptos_meta::*;
use leptos_router::*;
use leptos_use::storage::use_local_storage;
use leptos_use::use_preferred_dark;
use leptos_use::utils::JsonCodec;
use crate::models::util::BrightnessMode;
use crate::pages::{BaseLayout, Home};
use crate::pages::explore::Explore;
use crate::pages::search::Search;
use crate::pages::social::Social;
use crate::pages::docs::DocsRoutes;
use crate::pages::auth::AuthRoutes;
use crate::state::AppState;

#[component]
pub fn Sailfish() -> impl IntoView {
    let (app, _, _) = use_local_storage::<AppState, JsonCodec>("app");
    let is_preferred_dark = use_preferred_dark();
    
    // Provides context that manages stylesheets, titles, meta tags, etc.
    provide_meta_context();

    view! {
        <Body class=move || {
            let theme = app().theme;
            if app().brightness_mode == BrightnessMode::System {
                match is_preferred_dark() {
                    true => format!("{} {}", BrightnessMode::Dark, theme),
                    false => format!("{} {}", BrightnessMode::Light, theme),
                }
            } else {
                format!("{} {}", app().brightness_mode, theme)
            }
        } />

        // injects a stylesheet into the document <head>
        // id=leptos means cargo-leptos will hot-reload this stylesheet
        <Stylesheet id="leptos" href="/pkg/sailfish.css"/>

        // sets the document title
        <Title text="Offprint"/>
        
        // sets the theme color
        <Meta name="theme-color" content=move || format!("rgb({})", app().theme.accent_color()) />

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
                        <Route path="social" view=Social />
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
