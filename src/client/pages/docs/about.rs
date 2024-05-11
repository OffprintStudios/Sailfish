use leptos::*;

#[server]
pub async fn get_about_page() -> Result<String, ServerFnError> {
    use std::fs::read_to_string;
    use std::path::Path;
    use ammonia::Builder;
    use pulldown_cmark::{Parser, Options, html::push_html};
    use maplit::hashset;

    // Getting the page file
    let curr_dir = match std::env::current_dir() {
        Ok(val) => val,
        Err(_) => return Err(ServerFnError::new("something went wrong!"))
    };
    let path_url = format!("{}/public/docfiles/about.md", curr_dir.to_str().unwrap());
    let page_data = match read_to_string(Path::new(path_url.clone().as_str())) {
        Ok(val) => val,
        Err(_) => return Err(ServerFnError::new("something went wrong!"))
    };

    // Converting it from Markdown to HTML
    let md_parse = Parser::new_ext(&page_data, Options::empty());
    let mut unsafe_html = String::new();
    push_html(&mut unsafe_html, md_parse);

    // Finally, sanitize the remaining output and return
    let safe_html = Builder::default()
        .generic_attributes(hashset!["class"])
        .clean(&*unsafe_html)
        .to_string();
    Ok(safe_html)
}

#[component]
pub fn About() -> impl IntoView {
    use leptos::Await;
    use crate::client::ui::util::{MetaTags, MetaTagOptions};

    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/docs/about".to_string(),
        title: "About — Offprint".to_string(),
        author_url: None,
        description: "About Offprint".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };

    view! {
        <MetaTags options=meta_options />
        
        <Await future=|| get_about_page() let:data>
            <div inner_html=data.clone().unwrap()></div>
        </Await>
    }
}