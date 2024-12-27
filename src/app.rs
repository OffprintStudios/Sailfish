use leptos::prelude::*;
use leptos_meta::{provide_meta_context, MetaTags, Stylesheet, Title, Link, Body};
use leptos_router::{
    path,
    components::{Route, Router, Routes, ParentRoute},
};
use leptos_use::use_preferred_dark;
use leptos_use::storage::use_local_storage;
use codee::string::JsonSerdeCodec;
use crate::errors::{AppError, ErrorTemplate};
use crate::store::app_store::AppStore;
use crate::models::util::themes::Brightness;

/* Pages */
use crate::pages::{BaseLayout, HomePage};
use crate::pages::auth::AuthRoutes;
use crate::pages::explore::ExplorePage;
use crate::pages::social::SocialRoutes;
use crate::pages::search::SearchPage;

pub fn shell(options: LeptosOptions) -> impl IntoView {
    view! {
        <!DOCTYPE html>
        <html lang="en">
            <head>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <AutoReload options=options.clone() />
                <HydrationScripts options/>
                <MetaTags/>
            </head>
            <body class="crimson">
                <App/>
            </body>
        </html>
    }
}

#[component]
pub fn App() -> impl IntoView {
    let (app, _, _) = use_local_storage::<AppStore, JsonSerdeCodec>("app");
    let is_preferred_dark = use_preferred_dark();

    // Provides context that manages stylesheets, titles, meta tags, etc.
    provide_meta_context();

    view! {
        // determines which theme and brightness classes to use based on 
        // per-browser settings and dark mode preferences
        <Body attr:class=move || {
            let theme = app().theme;
            if app().brightness == Brightness::System {
                match is_preferred_dark() {
                    true => format!("{} {}", Brightness::Dark, theme),
                    false => format!("{} {}", Brightness::Light, theme),
                }
            } else {
                format!("{} {}", app().brightness, theme)
            }
        }/>

        <Link rel="shortcut icon" type_="image/png" href="/favicon.png"/>

        // injects a stylesheet into the document <head>
        // id=leptos means cargo-leptos will hot-reload this stylesheet
        <Stylesheet id="leptos" href="/pkg/sailfish2.css"/>

        // sets the document title
        <Title text="Offprint"/>

        // content for this welcome page
        <Router>
            <main>
                <Routes 
                    transition=true 
                    fallback=|| {
                        let mut errors = Errors::default();
                        errors.insert_with_default_key(ServerFnError::WrappedServerError(AppError::NotFound));
                        view! {
                            <ErrorTemplate errors />
                        }.into_view()
                    }
                >
                    <ParentRoute path=path!("/") view=BaseLayout>
                        <Route path=path!("") view=HomePage />
                        <Route path=path!("explore") view=ExplorePage />
                        <SocialRoutes />
                        <Route path=path!("search") view=SearchPage />
                    </ParentRoute>
                    <AuthRoutes />
                </Routes>
            </main>
        </Router>
    }
}
