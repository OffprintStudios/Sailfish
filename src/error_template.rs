use http::status::StatusCode;
use leptos::*;
use thiserror::Error;

#[derive(Clone, Debug, Error)]
pub enum AppError {
    #[error("The page you're looking for ain't around here")]
    NotFound,
    #[error("You don't have permission to do that")]
    Unauthorized,
    #[error("Where were you even going, anyway?")]
    Forbidden,
}

impl AppError {
    pub fn status_code(&self) -> StatusCode {
        match self {
            AppError::NotFound => StatusCode::NOT_FOUND,
            AppError::Unauthorized => StatusCode::UNAUTHORIZED,
            AppError::Forbidden => StatusCode::FORBIDDEN,
        }
    }
}

// A basic function to display errors served by the error boundaries.
// Feel free to do more complicated things here than just displaying the error.
#[component]
pub fn ErrorTemplate(
    #[prop(optional)] outside_errors: Option<Errors>,
    #[prop(optional)] errors: Option<RwSignal<Errors>>,
) -> impl IntoView {
    let errors = match outside_errors {
        Some(e) => create_rw_signal(e),
        None => match errors {
            Some(e) => e,
            None => panic!("No Errors found and we expected errors!"),
        },
    };
    // Get Errors from Signal
    let errors = errors.get_untracked();

    // Downcast lets us take a type that implements `std::error::Error`
    let errors: Vec<AppError> = errors
        .into_iter()
        .filter_map(|(_k, v)| v.downcast_ref::<AppError>().cloned())
        .collect();
    println!("Errors: {errors:#?}");

    // Only the response code for the first error is actually sent from the server
    // this may be customized by the specific application
    #[cfg(feature = "ssr")]
    {
        use leptos_axum::ResponseOptions;
        let response = use_context::<ResponseOptions>();
        if let Some(response) = response {
            response.set_status(errors[0].status_code());
        }
    }

    view! {
        <div
            class="flex flex-col items-center justify-center w-full h-[100svh] bg-cover bg-center relative z-0"
            style="background-image: url('/images/backpacker.jpg')"
        >
            <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
                <For
                    // a function that returns the items we're iterating over; a signal is fine
                    each= move || {errors.clone().into_iter().enumerate()}
                    // a unique key for each item as a reference
                    key=|(index, _error)| *index
                    // renders each item to a view
                    children=move |error| {
                        let error_string = error.1.to_string();
                        let error_code= error.1.status_code();
                        view! {
                            <div class="flex flex-col items-center justify-center pb-4">
                                <h1 class="text-3xl">{error_code.to_string()}</h1>
                            </div>
                            <p>{error_string}</p>
                        }
                    }
                />
            </div>
        </div>
    }
}
