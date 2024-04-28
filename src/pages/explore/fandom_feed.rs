use leptos::*;
use leptos_router::*;

#[derive(Params, PartialEq)]
struct FandomFeedParams {
    pub id: String,
}

#[component]
pub fn FandomFeed() -> impl IntoView {
    let _params = use_params::<FandomFeedParams>();
}