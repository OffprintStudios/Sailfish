use axum::async_trait;
use axum::extract::FromRequestParts;
use axum::http::HeaderValue;
use http::header::USER_AGENT;
use http::request::Parts;

pub struct ExtractUserAgent(HeaderValue);

#[async_trait]
impl<S> FromRequestParts<S> for ExtractUserAgent {
    type Rejection = ();

    async fn from_request_parts(parts: &mut Parts, _state: &S) -> Result<Self, Self::Rejection> {
        if let Some(user_agent) = parts.headers.get(USER_AGENT) {
            Ok(ExtractUserAgent(user_agent.clone()))
        } else {
            Err(())
        }
    }
}