use leptos::*;
use leptos_icons::*;
use icondata_core;
use icondata_ri as remixicon;

#[component]
pub fn GenreGrid() -> impl IntoView {
    let mut genres: Vec<(&str, &icondata_core::IconData)> = Vec::new();
    genres.push(("Action/Adventure", remixicon::RiSwordOthersLine));
    genres.push(("Comedy", remixicon::RiEmotionLaughUserFacesLine));
    genres.push(("Dark", remixicon::RiMoonFoggyWeatherLine));
    genres.push(("Drama", remixicon::RiFilePaper2DocumentLine));
    genres.push(("Erotica", remixicon::RiDoorClosedOthersLine));
    genres.push(("Fantasy", remixicon::RiMagicDesignLine));
    genres.push(("Horror", remixicon::RiGhost2UserFacesLine));
    genres.push(("Mystery", remixicon::RiSearch2SystemLine));
    genres.push(("Romance", remixicon::RiHeartsHealthMedicalLine));
    genres.push(("Sad", remixicon::RiEmotionSadUserFacesLine));
    genres.push(("Science Fiction", remixicon::RiAliensUserFacesLine));
    genres.push(("Slice of Life", remixicon::RiHome3BuildingsLine));
    genres.push(("Speculative Fiction", remixicon::RiMeteorWeatherLine));
    genres.push(("Thriller", remixicon::RiSpyUserFacesLine));
    genres.push(("Tragedy", remixicon::RiSkullUserFacesLine));
    
    view! {
        <div>
            <div class="flex items-center mb-3 mx-4 md:mx-0">
                <Icon icon=remixicon::RiBox2OthersLine width="30px" height="30px" />
                <h3 class="text-2xl text-black dark:text-white mx-2">"Genres"</h3>
                <div class="flex-1">/* spacer */</div>
            </div>
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-0 md:gap-2">
                {genres.into_iter().map(|val| view! { 
                    <div class="flex flex-col items-center justify-center overflow-hidden px-4 py-2 border odd:border-l-0 even:border-r-0 md:odd:border-l md:even:border-r md:rounded-xl bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur border-zinc-600/25 dark:border-zinc-300/25 h-[106px]" style="box-shadow: var(--dropshadow);">
                        <span class="relative top-0.5">
                            <Icon icon=val.1 width="36px" height="36px" />
                        </span>
                        <span class="text-center all-small-caps font-bold break-words text-lg leading-relaxed">{val.0}</span>
                    </div>
                }).collect::<Vec<_>>()}
            </div>
        </div>
    }
}