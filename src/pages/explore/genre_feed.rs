use leptos::*;
use leptos_router::*;

#[derive(Params, PartialEq)]
struct GenreFeedParams {
    pub id: String
}

#[component]
pub fn GenreFeed() -> impl IntoView {
    let _params = use_params::<GenreFeedParams>();
}