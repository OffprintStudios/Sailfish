use http::status::StatusCode;
use leptos::*;
use serde::{Deserialize, Serialize};
use thiserror::Error;
use strum::EnumString;

#[derive(Clone, Debug, Error, EnumString, Serialize, Deserialize)]
pub enum SailfishError {
    #[error("The page you're looking for ain't 'round here, friend")]
    NotFound,
    #[error("You shouldn't toy with fate like that")]
    Unauthorized,
    #[error("The ancient ways shall remain unknown to you, traveler")]
    Forbidden,
    #[error("Look, this page isn't a bug—it's a feature")]
    ServerError,
}

impl SailfishError {
    pub fn status_code(&self) -> StatusCode {
        match self {
            SailfishError::NotFound => StatusCode::NOT_FOUND,
            SailfishError::Unauthorized => StatusCode::UNAUTHORIZED,
            SailfishError::Forbidden => StatusCode::FORBIDDEN,
            SailfishError::ServerError => StatusCode::INTERNAL_SERVER_ERROR,
        }
    }
}

cfg_if::cfg_if! {
    if #[cfg(feature = "ssr")] {
        use sqlx::Error as SqlxError;
        use argon2::password_hash::Error as PasswordHashError;
        use tokio::task::JoinError;
        
        impl From<SqlxError> for SailfishError {
            fn from(_: SqlxError) -> Self {
                Self::ServerError
            }
        }
        
        impl From<PasswordHashError> for SailfishError {
            fn from(_: PasswordHashError) -> Self {
                Self::ServerError
            }
        }
        
        impl From<JoinError> for SailfishError {
            fn from(_: JoinError) -> Self {
                Self::ServerError
            }
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
    let errors: Vec<SailfishError> = errors
        .into_iter()
        .filter_map(|(_k, v)| {
            let err = v.downcast_ref::<ServerFnError<SailfishError>>().cloned();
            if let Some(ServerFnError::WrappedServerError(e)) = err {
                Some(e)
            } else {
                None
            }
        })
        .collect();

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
                            <p class="text-center">{error_string}</p>
                        }
                    }
                />
            </div>
        </div>
    }
}
