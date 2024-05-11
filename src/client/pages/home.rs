use leptos::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use crate::client::ui::nav::Footer;
use crate::client::ui::content::{Jumbotron, CardCarousel, NewsPanel, GenreGrid};
use crate::client::ui::util::{MetaTags, MetaTagOptions};

#[component]
pub fn Home() -> impl IntoView {
    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/".to_string(),
        title: "Home — Offprint".to_string(),
        author_url: None,
        description: "For The Stories Left Untold".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };
    
    view! {
        <MetaTags options=meta_options />
        
        <Jumbotron />
        <div class="flex flex-col max-w-6xl mx-auto w-full md:w-11/12 my-6">
            <CardCarousel>
                <Icon icon=remixicon::RiLoader2SystemLine width="30px" height="30px" />
                <h3 class="text-2xl text-black dark:text-white mx-2">"What's New"</h3>
            </CardCarousel>
            <div class="my-4">/* spacer */</div>
            <CardCarousel>
                <Icon icon=remixicon::RiSignalTowerMapLine width="30px" height="30px" />
                <h3 class="text-2xl text-black dark:text-white mx-2">"Recently Updated"</h3>
            </CardCarousel>
            <div class="my-4">/* spacer */</div>
            <NewsPanel />
            <GenreGrid />
        </div>
        <Footer />
    }
}