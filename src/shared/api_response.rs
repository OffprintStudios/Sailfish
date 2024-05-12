use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ApiResponse<T> {
    pub status: u16,
    pub name: String,
    pub data: Option<T>,
    pub message: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ApiResult<T> {
    Success(ApiResponse<T>),
    Failure(ApiResponse<T>),
}

impl<T> ApiResponse<T> {
    cfg_if::cfg_if! {
        if #[cfg(feature = "ssr")] {
            /// Creates a new API response
            pub fn new(status: u16, name: String, data: Option<T>, message: Option<String>) -> Self {
                ApiResponse {
                    status,
                    name,
                    data,
                    message,
                }
            }
            
            /// 200: Okay
            pub fn okay(data: Option<T>) -> Self {
                ApiResponse {
                    status: 200,
                    name: "Ok".to_string(),
                    data,
                    message: None,
                }
            }
            
            /// 201: Created
            pub fn created(data: Option<T>) -> Self {
                ApiResponse {
                    status: 201,
                    name: "Created".to_string(),
                    data,
                    message: None,
                }
            }
            
            /// 204: No Content
            pub fn no_content() -> Self {
                ApiResponse {
                    status: 204,
                    name: "No Content".to_string(),
                    data: None,
                    message: None,
                }
            }
            
            /// 400: Bad Request
            pub fn bad_request(message: Option<String>) -> Self {
                ApiResponse {
                    status: 400,
                    name: "Bad Request".to_string(),
                    data: None,
                    message,
                }
            }
            
            /// 401: Unauthorized
            pub fn unauthorized(message: Option<String>) -> Self {
                ApiResponse {
                    status: 401,
                    name: "Unauthorized".to_string(),
                    data: None,
                    message,
                }
            }
            
            /// 403: Forbidden
            pub fn forbidden(message: Option<String>) -> Self {
                ApiResponse {
                    status: 403,
                    name: "Forbidden".to_string(),
                    data: None,
                    message,
                }
            }
            
            /// 404: Not Found
            pub fn not_found(message: Option<String>) -> Self {
                ApiResponse {
                    status: 404,
                    name: "Not Found".to_string(),
                    data: None,
                    message,
                }
            }
            
            /// 405: Not Allowed
            pub fn not_allowed(message: Option<String>) -> Self {
                ApiResponse {
                    status: 405,
                    name: "Not Allowed".to_string(),
                    data: None,
                    message,
                }
            }
            
            /// 409: Conflict
            pub fn conflict(message: Option<String>) -> Self {
                ApiResponse {
                    status: 409,
                    name: "Conflict".to_string(),
                    data: None,
                    message,
                }
            }
            
            /// 500: Internal Server Error
            pub fn internal_server_error(message: Option<String>) -> Self {
                ApiResponse {
                    status: 500,
                    name: "Internal Server Error".to_string(),
                    data: None,
                    message,
                }
            }
            
            /// 501: Not Implemented
            pub fn not_implemented(message: Option<String>) -> Self {
                ApiResponse {
                    status: 501,
                    name: "Not Implemented".to_string(),
                    data: None,
                    message,
                }
            }
            
            /// 503: Service Unavailable
            pub fn service_unavailable(message: Option<String>) -> Self {
                ApiResponse {
                    status: 503,
                    name: "Service Unavailable".to_string(),
                    data: None,
                    message,
                }
            }
        }
    }
}

cfg_if::cfg_if! {
    if #[cfg(feature = "ssr")] {
        use sqlx::Error as SqlxError;
        use argon2::password_hash::Error as HashError;
        use leptos::ServerFnError;
        use tokio::task::JoinError;
        
        impl<T> From<SqlxError> for ApiResult<T> {
            fn from(_: SqlxError) -> Self {
                Self::Failure(ApiResponse::internal_server_error(None))
            }
        }
        
        impl<T> From<HashError> for ApiResult<T> {
            fn from(_: HashError) -> Self {
                Self::Failure(ApiResponse::internal_server_error(None))
            }
        }
        
        impl<T> From<JoinError> for ApiResult<T> {
            fn from(_: JoinError) -> Self {
                Self::Failure(ApiResponse::internal_server_error(None))
            }
        }
        
        impl<T> From<ApiResult<T>> for ServerFnError {
            fn from(value: ApiResult<T>) -> Self {
                match value {
                    ApiResult::Success(res) => ServerFnError::new(res.name),
                    ApiResult::Failure(res) => ServerFnError::new(res.name),
                }
            }
        }

        // impl<T> Try for ApiResult<T> {
        //     type Output = ApiResponse<T>;
        //     type Residual = ApiResult<!>;
        //     
        //     #[inline]
        //     fn from_output(output: Self::Output) -> Self {
        //         Self::Success(output)
        //     }
        //     
        //     #[inline]
        //     fn branch(self) -> ControlFlow<Self::Residual, Self::Output> {
        //         match self {
        //             ApiResult::Success(response) => ControlFlow::Continue(response),
        //             ApiResult::Failure(response) => ControlFlow::Break(ApiResult::Failure(response))
        //         }
        //     }
        // }
        // 
        // impl<T> FromResidual for ApiResult<T> {
        //     fn from_residual(residual: <Self as Try>::Residual) -> Self {
        //         match residual {
        //             ApiResult::Failure(response) => ApiResult::Failure(response)
        //         }
        //     }
        // }
    }
}
