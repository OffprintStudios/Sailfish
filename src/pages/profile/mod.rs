mod home;
mod works;
mod blogs;
mod single_blog;
mod shelves;
mod followers;
mod following;

use home::ProfileHomePage;
use works::ProfileWorksPage;
use blogs::ProfileBlogsPage;
use shelves::ProfileShelvesPage;
use followers::ProfileFollowersPage;
use following::ProfileFollowingPage;

use leptos::prelude::*;
use leptos::server_fn::codec::GetUrl;
use leptos_router::components::{ParentRoute, A, Outlet, Route};
use leptos_router::{path, MatchNestedRoutes, SsrMode, hooks::use_params_map, hooks::use_url};
use leptos_use::storage::use_local_storage;
use codee::string::JsonSerdeCodec;
use leptos_icons::*;
use icondata as TablerIcon;
use chrono::{DateTime, Local};
use crate::errors::{AppError, ErrorTemplate};
use crate::models::accounts::ProfileObject;
use crate::store::auth_store::AuthStore;
use crate::util::functions::{abbreviate, pluralize};
use crate::ui::misc::{MetaTags, Button, LinkBlock, RoleBadge};

#[component(transparent)]
pub fn ProfileRoutes() -> impl MatchNestedRoutes + Clone {
    view! {
        <ParentRoute path=path!("/profile/:id/:username") view=ProfileLayout ssr=SsrMode::PartiallyBlocked>
            <Route path=path!("works") view=ProfileWorksPage />
            <Route path=path!("blogs") view=ProfileBlogsPage />
            <Route path=path!("shelves") view=ProfileShelvesPage />
            <Route path=path!("followers") view=ProfileFollowersPage />
            <Route path=path!("following") view=ProfileFollowingPage />
            <Route path=path!("") view=ProfileHomePage />
        </ParentRoute>
    }.into_inner()
}

#[server(prefix = "/api", endpoint = "profile", input = GetUrl)]
pub async fn load_profile(id: String) -> Result<ProfileObject, AppError> {
    use crate::state::AppState;
    use crate::models::accounts::Profile;

    let state = expect_context::<AppState>();
    Ok(Profile::fetch_one(id, &state.db).await?.to_object(&state.db).await)
}

#[component]
pub fn ProfileLayout() -> impl IntoView {
    let params = use_params_map();
    let id = move || params().get("id").unwrap();
    let profile = Resource::new_blocking(id, |profile_id| async move { load_profile(profile_id).await });
    let (auth, _, _) = use_local_storage::<AuthStore, JsonSerdeCodec>("auth");
    let url = use_url();

    view! {
        <ErrorBoundary fallback=move |errors| view! { <ErrorTemplate errors /> }.into_view()>
            <Suspense>
                {move || Suspend::new(async move {
                    profile.await.map(|profile| {
                        let profile = Signal::derive(move || profile.clone());
                        let (is_author, set_is_author) = signal(false);

                        Effect::new(move |_| {
                            if auth().current_profile.is_some_and(|p| p.id == profile().id) {
                                set_is_author(true);
                            } else {
                                set_is_author(false);
                            }
                        });

                        view! {
                            <MetaTags
                                url=format!("https://offprint.cafe/profile/{}/{}", profile().id, slug::slugify(profile().username))
                                title=format!("{}'s Profile — Offprint", profile().username)
                                description=profile().bio
                                image_url=profile().avatar
                            />
                            
                            <div class="w-full">
                                <div class="relative w-full h-[10rem] md:h-[20rem] bg-accent-dark">
                                    <Show
                                        when=move || profile().banner_art.is_some()
                                    >
                                        <img src=profile().banner_art.unwrap() class="object-cover w-full h-full" alt=format!("{}'s banner", profile().username) />
                                    </Show>
                                </div>
                            </div>

                            // Mobile header
                            <div class="flex items-end relative z-10 px-4 md:hidden bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur-lg max-h-[62.5px]">
                                <div class="w-[125px] h-[125px] rounded-full overflow-hidden border-4 border-zinc-300 dark:border-zinc-600">
                                    <img src=profile().avatar class="w-full h-full object-cover" alt=format!("{}'s avatar", profile().username) />
                                </div>
                                <div class="flex-1"></div>
                                <div class="flex items-center bg-zinc-200 dark:bg-zinc-600 p-1 rounded-xl">
                                    <Show
                                        when=move || is_author()
                                        fallback=move || view! {
                                            <Button
                                                id="follow-profile-button"
                                                title=format!("Follow {}", profile().username)
                                            >
                                                <span class="button-icon no-text"><Icon icon=TablerIcon::TbUserHeart width="18px" height="18px" /></span>
                                            </Button>
                                            <div class="mx-0.5"></div>
                                            <Button
                                                id="more-options-button"
                                                title="More Options"
                                            >
                                                <span class="button-icon no-text"><Icon icon=TablerIcon::TbDotsVertical width="18px" height="18px" /></span>
                                            </Button>
                                        }
                                    >
                                        <LinkBlock
                                            id="profile-settings-button"
                                            title="Profile Settings"
                                            href=format!("/profile/{}/{}/settings", profile().id, slug::slugify(profile().username))
                                        >
                                            <span class="button-icon no-text"><Icon icon=TablerIcon::TbSettings width="18px" height="18px" /></span>
                                        </LinkBlock>
                                    </Show>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-4 md:gap-4 max-w-7xl md:w-11/12 mx-auto">
                                <div class="flex flex-col bg-zinc-200/50 dark:bg-zinc-700/50 md:h-fit md:rounded-xl px-4 pt-2 md:py-4 relative md:bottom-24 col-span-1 backdrop-blur-lg border-b md:border border-zinc-600/25 dark:border-zinc-300/25" style="box-shadow: var(--dropshadow);">
                                    <div class="self-center hidden md:block max-w-[260px] max-h-[260px] rounded-full overflow-hidden border-4 border-zinc-300 dark:border-zinc-600 mb-4">
                                        <img src=profile().avatar class="w-full h-full object-cover" alt=format!("{}'s avatar", profile().username) />
                                    </div>
                                    <h1 class="text-4xl">{profile().username}</h1>
                                    <div class="my-1"><RoleBadge roles=profile().roles /></div>
                                    <div class="flex items-center text-zinc-500 dark:text-zinc-400 text-xs md:text-sm">
                                        <A href=format!("/profile/{}/{}/followers", profile().id, slug::slugify(profile().username))>
                                            {format!("{} follower{}", abbreviate(profile().followers), pluralize(profile().followers))}
                                        </A>
                                        <span class="mx-1">"•"</span>
                                        <A href=format!("/profile/{}/{}/following", profile().id, slug::slugify(profile().username))>
                                            {format!("{} following", abbreviate(profile().following))}
                                        </A>
                                        <span class="flex-1"></span>
                                        <span class="block md:hidden">
                                            {move || {
                                                let local: DateTime<Local> = DateTime::from(profile().created_at);
                                                format!("Joined {}", local.format("%B %e, %Y"))
                                            }}
                                        </span>
                                    </div>
                                    <div class="my-2"></div>
                                    <span class="text-sm">{profile().bio}</span>
                                    <div class="hidden md:block my-2"></div>
                                    <Show
                                        when=move || is_author()
                                        fallback=move || view! {
                                            <div class="hidden md:flex items-center w-full">
                                                <Button
                                                    id="follow-button"
                                                    title=format!("Follow {}", profile().username)
                                                    full_width=true
                                                    primary=true
                                                >
                                                    <span class="button-icon"><Icon icon=TablerIcon::TbUserHeart /></span>
                                                    <span class="button-text">"Follow"</span>
                                                </Button>
                                                <div class="mx-0.5"></div>
                                                <Button
                                                    id="message-button"
                                                    title=format!("Message {}", profile().username)
                                                >
                                                    <span class="button-icon no-text"><Icon icon=TablerIcon::TbMailShare /></span>
                                                </Button>
                                                <div class="mx-0.5"></div>
                                                <Button
                                                    id="report-button"
                                                    title=format!("Report {}", profile().username)
                                                >
                                                    <span class="button-icon no-text"><Icon icon=TablerIcon::TbMessageReport /></span>
                                                </Button>
                                            </div>
                                        }
                                    >
                                        <div class="hidden md:flex items-center w-full bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur-sm rounded-xl overflow-hidden">
                                            <LinkBlock
                                                id="profile-settings-link"
                                                title="Profile Settings"
                                                href="/settings/profiles"
                                                full_width=true
                                            >
                                                <span class="button-icon"><Icon icon=TablerIcon::TbSettings /></span>
                                                <span class="button-text">"Settings"</span>
                                            </LinkBlock>
                                        </div>
                                    </Show>
                                    <div class="hidden md:block my-2"></div>
                                    <div class="hidden md:flex items-center text-sm">
                                        <span class="mr-2 relative top-0.5"><Icon icon=TablerIcon::TbCake width="22px" height="22px" /></span>
                                        <span>
                                            {move || {
                                                let local: DateTime<Local> = DateTime::from(profile().created_at);
                                                format!("Joined {}", local.format("%B %e, %Y"))
                                            }}
                                        </span>
                                    </div>
                                    <div class="flex md:flex-col items-center md:items-baseline mt-4 md:mt-0">
                                        // TODO: links
                                    </div>

                                    // Mobile Nav
                                    <div class="md:hidden my-1"></div>
                                    <div class="flex md:hidden items-center justify-center w-full">
                                        <A
                                            href=format!("/profile/{}/{}", profile().id, slug::slugify(profile().username))
                                            attr:class="w-1/4 text-center py-2 mx-0.5 all-small-caps text-lg font-bold tracking-wide border-b-2 border-transparent transition [&[aria-current=page]]:border-zinc-700 dark:[&[aria-current=page]]:border-zinc-300"
                                        >
                                            <span>"Home"</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/works", profile().id, slug::slugify(profile().username))
                                            attr:class="w-1/4 text-center py-2 mx-0.5 all-small-caps text-lg font-bold tracking-wide border-b-2 border-transparent transition [&[aria-current=page]]:border-zinc-700 dark:[&[aria-current=page]]:border-zinc-300"
                                        >
                                            <span>"Works"</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/blogs", profile().id, slug::slugify(profile().username))
                                            attr:class="w-1/4 text-center py-2 mx-0.5 all-small-caps text-lg font-bold tracking-wide border-b-2 border-transparent transition [&[aria-current=page]]:border-zinc-700 dark:[&[aria-current=page]]:border-zinc-300"
                                        >
                                            <span>"Blogs"</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/shelves", profile().id, slug::slugify(profile().username))
                                            attr:class="w-1/4 text-center py-2 mx-0.5 all-small-caps text-lg font-bold tracking-wide border-b-2 border-transparent transition [&[aria-current=page]]:border-zinc-700 dark:[&[aria-current=page]]:border-zinc-300"
                                        >
                                            <span>"Shelves"</span>
                                        </A>
                                    </div>
                                </div>
                                <div class="mb-6 md:my-6 col-span-3">
                                    <div 
                                        class="hidden md:flex items-center justify-center w-full py-2 bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur-lg rounded-xl border border-zinc-600/25 dark:border-zinc-300/25 transition"
                                        class:no-bottom-border=move || { url().path().contains("/works") || url().path().contains("/blogs") }
                                        style="box-shadow: var(--dropshadow);"
                                    >
                                        <A
                                            href=format!("/profile/{}/{}", profile().id, slug::slugify(profile().username))
                                            exact=true
                                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps text-lg font-bold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                                        >
                                            <span class="relative mr-2"><Icon icon=TablerIcon::TbHome width="20px" height="20px" /></span>
                                            <span>"Home"</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/works", profile().id, slug::slugify(profile().username))
                                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps text-lg font-bold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                                        >
                                            <span class="relative mr-2"><Icon icon=TablerIcon::TbFeather width="20px" height="20px" /></span>
                                            <span>{format!("{} Work{}", abbreviate(profile().works), pluralize(profile().works))}</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/blogs", profile().id, slug::slugify(profile().username))
                                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps text-lg font-bold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                                        >
                                            <span class="relative mr-2"><Icon icon=TablerIcon::TbCoffee width="20px" height="20px" /></span>
                                            <span>{format!("{} Blog{}", abbreviate(profile().blogs), pluralize(profile().blogs))}</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/shelves", profile().id, slug::slugify(profile().username))
                                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps text-lg font-bold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                                        >
                                            <span class="relative mr-2"><Icon icon=TablerIcon::TbBooks width="20px" height="20px" /></span>
                                            <span>"Shelves"</span>
                                        </A>
                                    </div>
                                    <div class="w-full mx-auto">
                                        <Outlet />
                                    </div>
                                </div>
                            </div>
                        }
                    })
                })} 
            </Suspense>
        </ErrorBoundary>
    }

}