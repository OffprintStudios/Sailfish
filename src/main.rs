
#[cfg(feature = "ssr")]
#[tokio::main]
async fn main() -> anyhow::Result<()> {
    use apalis::prelude::*;
    use apalis_redis::RedisStorage;
    use axum::{Router, Extension};
    use leptos::prelude::*;
    use leptos::logging::log;
    use leptos_axum::{generate_route_list, LeptosRoutes};
    use sailfish::app::*;
    use sailfish::state::AppState;
    use sailfish::constants::SECRET_KEY;
    use sailfish::database::connect_to_db;
    use sailfish::queues::email::send_email;
    use tower_sessions::cookie::Key;

    dotenvy::dotenv().ok();

    let conf = get_configuration(None).unwrap();
    let addr = conf.leptos_options.site_addr;
    let leptos_options = conf.leptos_options;
    // Generate the list of routes in your Leptos App
    let routes = generate_route_list(App);

    // Create a database pool and run migrations
    let db = connect_to_db().await;
    sqlx::migrate!().run(&db).await.expect("Failed to run migrations!");

    // Set secret key for private cookies
    let secret_key = std::env::var("SECRET_KEY")
        .expect("Could not find SECRET_KEY! Are you sure your environment is configured correctly?");
    SECRET_KEY.set(Key::from(secret_key.as_bytes())).ok();

    // Create job queue storage
    let redis_url = std::env::var("REDIS_URL")
        .expect("Could not find REDIS_URL! Are you sure your environment is configured correctly?");
    let queue_conn = apalis_redis::connect(redis_url).await
        .expect("Could not connect to Redis!");
    let storage = RedisStorage::new(queue_conn);

    // Create a state object
    let app_state = AppState {
        db,
        leptos_options,
    };

    let app = Router::new()
        .leptos_routes_with_context(
            &app_state,
            routes,
            {
                let state = app_state.clone();
                move || provide_context(state.clone())
            },
            {
                let leptos_options = app_state.leptos_options.clone();
                move || shell(leptos_options.clone())
            },
        )
        .fallback(leptos_axum::file_and_error_handler::<AppState, _>(shell))
        .with_state(app_state.clone())
        .layer(CookieManagerLayer::new())
        .layer(Extension(storage.clone()));

    // run our app with hyper
    // `axum::Server` is a re-export of `hyper::Server`
    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();
    log!("listening on http://{}", &addr);

    let http = async {
        axum::serve(listener, app.into_make_service())
            .await
            .map_err(|e| std::io::Error::new(std::io::ErrorKind::Interrupted, e))
    };

    let monitor = async {
        Monitor::new()
            .register({
                WorkerBuilder::new("app-mailer")
                    .enable_tracing()
                    .backend(storage.clone())
                    .build_fn(send_email)
            })
            .run()
            .await
            .unwrap();

        Ok::<(), std::io::Error>(())
    };

    _ = tokio::join!(http, monitor);
    Ok(())
}

#[cfg(not(feature = "ssr"))]
pub fn main() {
    // no client-side main function
    // unless we want this to work with e.g., Trunk for pure client-side testing
    // see lib.rs for hydration function instead
}
