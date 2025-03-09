use leptos::prelude::*;
use http::status::StatusCode;
use serde::{Serialize, Deserialize};
use thiserror::Error;
use strum::EnumString;

#[derive(Debug, Clone, Serialize, Deserialize, EnumString, Error, PartialEq, Eq)]
pub enum AppError {
    #[error("The page you're looking for ain't 'round here, friend")]
    NotFound,
    #[error("You shouldn't toy with fate like that")]
    Unauthorized,
    #[error("The ancient ways shall remain unknown to you, traveler")]
    Forbidden,
    #[error("Look, this page isn't a bug—it's a feature")]
    ServerError,
    #[error("Cleaning the espresso machines, be back soon")]
    ServiceUnavailable,
}

impl AppError {
    pub fn status_code(&self) -> StatusCode {
        match self {
            AppError::NotFound => StatusCode::NOT_FOUND,
            AppError::Unauthorized => StatusCode::UNAUTHORIZED,
            AppError::Forbidden => StatusCode::FORBIDDEN,
            AppError::ServerError => StatusCode::INTERNAL_SERVER_ERROR,
            AppError::ServiceUnavailable => StatusCode::SERVICE_UNAVAILABLE,
        }
    }
}

cfg_if::cfg_if! {
    if #[cfg(feature = "ssr")] {
        use sqlx::Error as SqlxError;
        use argon2::password_hash::Error as PasswordHashError;
        use tokio::task::JoinError;
        
        impl From<SqlxError> for AppError {
            fn from(e: SqlxError) -> Self {
                match e {
                    SqlxError::RowNotFound => Self::NotFound,
                    _ => Self::ServerError,
                }
            }
        }
        
        impl From<PasswordHashError> for AppError {
            fn from(_: PasswordHashError) -> Self {
                Self::ServerError
            }
        }
        
        impl From<JoinError> for AppError {
            fn from(_: JoinError) -> Self {
                Self::ServerError
            }
        }
    }
}

#[component]
pub fn ErrorTemplate(#[prop(into)] errors: Signal<Errors>) -> impl IntoView {
    let errors = Memo::new(move |_| {
        errors
            .get_untracked()
            .into_iter()
            .filter_map(|(_, v)| {
                let err = v.downcast_ref::<ServerFnError<AppError>>().cloned();
                if let Some(ServerFnError::WrappedServerError(e)) = err {
                    Some(e)
                } else {
                    None
                }
            })
            .collect::<Vec<_>>()
    });

    #[cfg(feature = "ssr")]
    {
        use leptos_axum::ResponseOptions;

        let response = use_context::<ResponseOptions>();
        if let Some(response) = response {
            response.set_status(errors.read_untracked()[0].status_code());
        }
    }

    view! {
        <div
            class="flex flex-col items-center justify-center w-full h-[100svh] bg-cover bg-center relative z-0"
            style="background-image: url('/images/backpacker.jpg')"
        >
            <div class="bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur-lg border border-zinc-300/25 dark:border-zinc-600/25 md:rounded-xl max-w-md p-6 md:p-12 w-full h-full md:h-fit" style="box-shadow: var(--dropshadow);">
                {move || {
                    errors.get()
                        .into_iter()
                        .map(|error| {
                            let error_string = error.to_string();
                            let error_code = error.status_code();
                            view! {
                                <div class="flex flex-col items-center justify-center pb-4">
                                    <h1 class="text-3xl">{error_code.to_string()}</h1>
                                </div>
                                <p class="text-center">{error_string}</p>
                            }
                        })
                        .collect_view()
                }}
            </div>
        </div>
    }
}