use leptos::prelude::*;

use crate::errors::AppError;
use crate::models::content::{Tag, TagKind};

#[server(prefix = "/api/dashboard/tags", endpoint = "all")]
pub async fn load_tags(kind: TagKind, page: i64, per: i64) -> Result<Vec<Tag>, AppError> {
    use crate::state::AppState;

    let state = expect_context::<AppState>();
    let tags = Tag::fetch(kind, page, per, &state.db).await?;

    Ok(tags)
}

#[component]
pub fn DashboardTagsPage() -> impl IntoView {
    view! {
        <span>"hello"</span>
    }
}