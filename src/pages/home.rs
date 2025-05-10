use leptos::prelude::*;
use leptos_icons::*;
use icondata as TablerIcon;
use crate::ui::content::{Jumbotron, CardCarousel, NewsPanel, GenreGrid};
use crate::ui::misc::MetaTags;

#[component]
pub fn HomePage() -> impl IntoView {
    view! {
        <MetaTags
            url="https://offprint.cafe/"
            title="Home — Offprint"
            description="For The Stories Left Untold"
            image_url="/images/beatriz.png"
        />
        
        <Jumbotron />
        <div class="flex flex-col max-w-6xl mx-auto w-full md:w-11/12 my-6">
            <CardCarousel>
                <Icon icon=TablerIcon::TbLoader width="30px" height="30px" />
                <h3 class="text-xl md:text-2xl text-black! dark:text-white! mx-2">"What's New"</h3>
            </CardCarousel>
            <div class="my-4">/* spacer */</div>
            <CardCarousel>
                <Icon icon=TablerIcon::TbBuildingBroadcastTower width="30px" height="30px" />
                <h3 class="text-xl md:text-2xl text-black! dark:text-white! mx-2">"Recently Updated"</h3>
            </CardCarousel>
            <div class="my-4">/* spacer */</div>
            <NewsPanel />
            <GenreGrid />
        </div>
    }
}