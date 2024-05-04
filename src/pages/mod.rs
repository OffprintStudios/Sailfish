use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use crate::ui::nav::{Navbar, Footer};
use crate::ui::content::{Jumbotron, CardCarousel, NewsPanel, GenreGrid};

pub mod explore;
pub mod auth;
pub mod docs;

#[component]
pub fn HomeLayout() -> impl IntoView {
    view! {
        <Navbar />
        <Outlet />
        <Footer />
    }
}

#[component]
pub fn HomePage() -> impl IntoView {
    view! {
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
    }
}