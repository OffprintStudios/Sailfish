use leptos::*;
use leptos_router::*;

#[derive(Params, PartialEq)]
struct PostParams {
    pub id: String,
    pub title: Option<String>,
}

#[component]
pub fn NewsPost() -> impl IntoView {
    let _params = use_params::<PostParams>();
}