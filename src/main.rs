use anyhow::Result;

#[cfg(feature = "ssr")]
#[tokio::main]
async fn main() -> Result<()> {
    use axum::{Router, Extension};
    use leptos::*;
    use leptos_axum::{generate_route_list, LeptosRoutes};
    use tower_cookies::{CookieManagerLayer, Key};
    use apalis::prelude::*;
    use apalis::redis::{RedisStorage, connect};
    use apalis::layers::tracing::TraceLayer;
    use sailfish::sailfish::{Sailfish, SailfishState};
    use sailfish::database::connect_to_db;
    use sailfish::constants::SECRET_KEY;
    use sailfish::models::util::Email;
    use sailfish::fileserv::file_and_error_handler;

    dotenvy::dotenv().ok();

    // Setting get_configuration(None) means we'll be using cargo-leptos's env values
    // For deployment these variables are:
    // <https://github.com/leptos-rs/start-axum#executing-a-server-on-a-remote-machine-without-the-toolchain>
    // Alternately a file can be specified such as Some("Cargo.toml")
    // The file would need to be included with the executable when moved to deployment
    let conf = get_configuration(None).await.unwrap();
    let leptos_options = conf.leptos_options;
    let addr = leptos_options.site_addr;
    let routes = generate_route_list(Sailfish);

    // Create database pool and run migrations
    let db = connect_to_db().await;
    sqlx::migrate!()
        .run(&db)
        .await
        .expect("Could not run migrations!");

    // Get `SECRET_KEY` for private cookies and set it via `OnceLock<T>`
    let secret_key = std::env::var("SECRET_KEY")
        .expect("Could not find SECRET_KEY! Are you sure your environment is configured correctly?");
    SECRET_KEY.set(Key::from(secret_key.as_bytes())).ok();

    // Establish connection to redis for job queue
    let redis_url = std::env::var("REDIS_URL")
        .expect("Could not find REDIS_URL! Are you sure your environment is configured correctly?");
    let queue_conn = connect(redis_url).await
        .expect("Could not connect to Redis server!");
    let storage = RedisStorage::new(queue_conn);

    // Create `SailfishState` object
    let sailfish_state = SailfishState {
        db,
        leptos_options,
    };
    
    let app = Router::new()
        .leptos_routes_with_context(
            &sailfish_state,
            routes,
            {
                let app_state = sailfish_state.clone();
                move || provide_context(app_state.clone())
            },
            Sailfish,
        )
        .fallback(file_and_error_handler)
        .with_state(sailfish_state.clone())
        .layer(CookieManagerLayer::new())
        .layer(Extension(storage.clone()));

    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();
    logging::log!("listening on http://{}", &addr);

    let http = async {
        axum::serve(listener, app.into_make_service())
            .await
            .map_err(|e| std::io::Error::new(std::io::ErrorKind::Interrupted, e))
    };

    let monitor = async {
        Monitor::<TokioExecutor>::new()
            .register_with_count(2, {
                WorkerBuilder::new("sailfish-queue")
                    .layer(TraceLayer::new())
                    .with_storage(storage.clone())
                    .data(sailfish_state.clone())
                    .build_fn(Email::send_mail)
            })
    };

    _ = tokio::join!(http, monitor);
    Ok(())
}

#[cfg(not(feature = "ssr"))]
pub fn main() {
    // no client-side main function
    // unless we want this to work with e.g., Trunk for a purely client-side app
    // see lib.rs for hydration function instead
}
