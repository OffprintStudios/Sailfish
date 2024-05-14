use leptos::*;
use pulldown_cmark::{Parser, html::push_html};
use crate::client::ui::util::{MetaTags, MetaTagOptions};

#[component]
pub fn About() -> impl IntoView {
    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/docs/about".to_string(),
        title: "About — Offprint".to_string(),
        author_url: None,
        description: "About Offprint".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };
    
    let to_parse = r#"
Offprint is a community-focused writing site for fanfiction, original stories, and blog posts. Our goal is to provide a place where authors can form communities for their readers, promote themselves, and collaborate with other authors. We are constantly building up features to encourage this, and quickly respond to user feedback.

Offprint aims to be a safe and welcoming space, and as such is committed to excluding exceptionally harmful content and users.

Offprint is built on open source software, hosted on Github, and welcomes contributions. The site is funded entirely by donations, and there are no advertisements.
    "#;
    
    let parser = Parser::new(to_parse);
    let mut parsed_str = String::new();
    push_html(&mut parsed_str, parser);

    view! {
        <MetaTags options=meta_options />
        
        <div class="text-center">
            <h1 class="flex flex-col">
                <span>"What is Offprint?"</span>
                <span class="text-lg text-zinc-600 dark:text-zinc-300">"Who are we? Who are you? Who are any of us?"</span>
                <span class="text-base text-zinc-600 dark:text-zinc-300 italic">"Edited February 25, 2024"</span>
            </h1>
        </div>
        
        <div inner_html=parsed_str></div>
    }
}