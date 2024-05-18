use leptos::*;
use leptos_meta::*;

#[derive(Debug, Clone)]
pub struct MetaTagOptions {
    pub url: String,
    pub title: String,
    pub author_url: Option<String>,
    pub description: String,
    pub image_url: String,
}

#[component]
pub fn MetaTags(options: MetaTagOptions) -> impl IntoView {
    view! {
        <Title text=options.title.clone() />

        <Meta name="title" content=options.title.clone() />
        <Meta name="description" content=options.description.clone() />

        // Open Graph / Facebook
        <Meta property="og:type" content="website" />
        <Meta property="og:url" content=options.url.clone() />
        <Meta property="og:title" content=options.title.clone() />
        {if options.author_url.is_some() {
            view! {
                <Meta property="book:author" content=options.author_url.unwrap().clone() />
            }
        } else {
            view! {
                <Meta property="book:author" content="" />
            }
        }}
        <Meta property="og:description" content=options.description.clone() />
        <Meta property="og:image" content=options.image_url.clone() />

        // Twitter
        <Meta property="twitter:card" content="summary" />
        <Meta property="twitter:url" content=options.url.clone() />
        <Meta property="twitter:title" content=options.title.clone() />
        <Meta property="twitter:description" content=options.description.clone() />
        <Meta property="twitter:image" content=options.image_url.clone() />
    }
}