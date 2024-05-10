#[cfg(feature = "ssr")]
#[tokio::main]
async fn main() {
    use std::net::SocketAddr;
    use axum::Router;
    use leptos::*;
    use leptos_axum::{generate_route_list, LeptosRoutes};
    use tower_cookies::{CookieManagerLayer, Key};
    use sailfish::app::*;
    use sailfish::server::db::connect_to_db;
    use sailfish::fileserv::file_and_error_handler;
    use sailfish::server::util::state::SailfishState;
    use sailfish::server::util::constants::KEY;
    
    dotenvy::dotenv().ok();

    // Setting get_configuration(None) means we'll be using cargo-leptos's env values
    // For deployment these variables are:
    // <https://github.com/leptos-rs/start-axum#executing-a-server-on-a-remote-machine-without-the-toolchain>
    // Alternately a file can be specified such as Some("Cargo.toml")
    // The file would need to be included with the executable when moved to deployment
    let conf = get_configuration(None).await.unwrap();
    let leptos_options = conf.leptos_options;
    let addr = leptos_options.site_addr;
    let routes = generate_route_list(App);
    
    let db = connect_to_db().await;
    sqlx::migrate!()
        .run(&db)
        .await
        .expect("Could not run migrations!");
    
    let secret_key = std::env::var("SECRET_KEY")
        .expect("Could not find SECRET_KEY! Are you sure your environment is configured correctly?");
    KEY.set(Key::from(secret_key.as_bytes())).ok();
    
    let sailfish_state = SailfishState {
        db,
        leptos_options,
    };

    // build our application with a route
    let app = Router::new()
        .leptos_routes_with_context(
            &sailfish_state,
            routes,
            {
                let app_state = sailfish_state.clone();
                move || provide_context(app_state.clone())
            },
            App,
        )
        .fallback(file_and_error_handler)
        .with_state(sailfish_state)
        .layer(CookieManagerLayer::new());

    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();
    logging::log!("listening on http://{}", &addr);
    axum::serve(listener, app.into_make_service_with_connect_info::<SocketAddr>())
        .await
        .unwrap();
}

#[cfg(not(feature = "ssr"))]
pub fn main() {
    // no client-side main function
    // unless we want this to work with e.g., Trunk for a purely client-side app
    // see lib.rs for hydration function instead
}
