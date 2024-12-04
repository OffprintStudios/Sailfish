use leptos::prelude::*;
use leptos_icons::*;
use icondata as TablerIcon;

#[component]
pub fn GenreGrid() -> impl IntoView {
    let mut genres: Vec<(&str, icondata::Icon)> = Vec::new();
    genres.push(("Action/Adventure", TablerIcon::TbSwords));
    genres.push(("Comedy", TablerIcon::TbMoodTongueWink));
    genres.push(("Dark", TablerIcon::TbHazeMoon));
    genres.push(("Drama", TablerIcon::TbMasksTheater));
    genres.push(("Erotica", TablerIcon::TbDoor));
    genres.push(("Fantasy", TablerIcon::TbWand));
    genres.push(("Horror", TablerIcon::TbGhost2));
    genres.push(("Mystery", TablerIcon::TbBrandRedhat));
    genres.push(("Romance", TablerIcon::TbHearts));
    genres.push(("Sad", TablerIcon::TbMoodSad2));
    genres.push(("Science Fiction", TablerIcon::TbUfo));
    genres.push(("Slice of Life", TablerIcon::TbHome));
    genres.push(("Speculative Fiction", TablerIcon::TbMeteor));
    genres.push(("Thriller", TablerIcon::TbSpy));
    genres.push(("Tragedy", TablerIcon::TbSkull));

    view! {
        <div>
            <div class="flex items-center mb-3 mx-4 md:mx-0">
                <Icon icon=TablerIcon::TbCube width="30px" height="30px" />
                <h3 class="text-xl md:text-2xl text-black dark:text-white mx-2">"Genres"</h3>
                <div class="flex-1">/* spacer */</div>
            </div>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-0 md:gap-2">
                <For
                    each=move || genres.clone().into_iter()
                    key=|genre| genre.0
                    children=move |genre| {
                        view! {
                            <div class="flex flex-col items-center justify-center overflow-hidden px-4 py-2 border odd:border-l-0 even:border-r-0 md:odd:border-l md:even:border-r md:rounded-xl bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur border-zinc-600/25 dark:border-zinc-300/25 h-[106px]" style="box-shadow: var(--dropshadow);">
                                <span class="relative top-0.5">
                                    <Icon icon=genre.1 width="36px" height="36px" />
                                </span>
                                <span class="text-center all-small-caps font-bold break-words text-lg leading-relaxed">{genre.0}</span>
                            </div>
                        }
                    }       
                />
            </div>
        </div>
    }
}