mod followers;
mod following;
mod works;
mod blogs;
mod home;

use home::ProfileHomePage;

use leptos::prelude::*;
use leptos::server_fn::codec::GetUrl;
use leptos_router::components::{ParentRoute, A, Outlet, Route};
use leptos_router::{path, MatchNestedRoutes, SsrMode, hooks::use_params_map, hooks::use_url};
use leptos::either::Either;
use leptos_icons::*;
use icondata as TablerIcon;
use serde::{Serialize, Deserialize};
use crate::errors::{AppError, ErrorTemplate};
use crate::models::accounts::Profile;
use crate::store::auth_store::AuthStore;
use crate::util::functions::{abbreviate, pluralize};
use crate::ui::misc::{MetaTags, Button, ButtonKind, LinkBlock, RoleBadge};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProfileInfo {
    profile: Profile
}

#[component(transparent)]
pub fn ProfileRoutes() -> impl MatchNestedRoutes + Clone {
    view! {
        <ParentRoute path=path!("/profile/:id/:username") view=ProfileLayout ssr=SsrMode::PartiallyBlocked>
            <Route path=path!("") view=ProfileHomePage />
        </ParentRoute>
    }
    .into_inner()
}

#[server(prefix = "/api", endpoint = "profile", input = GetUrl)]
pub async fn load_profile(id: String) -> Result<ProfileInfo, ServerFnError<AppError>> {
    use crate::state::AppState;

    let state = expect_context::<AppState>();
    let profile = Profile::fetch_one(id, &state.db).await?;

    Ok(ProfileInfo { profile })
}

#[component]
pub fn ProfileLayout() -> impl IntoView {
    let params = use_params_map();
    let id = move || params().get("id").unwrap();
    let profile = Resource::new_blocking(id, |profile_id| async move { load_profile(profile_id).await });
    let (auth, _, _) = leptos_use::storage::use_local_storage::<AuthStore, codee::string::JsonSerdeCodec>("auth");
    let url = use_url();

    view! {
        <ErrorBoundary fallback=move |errors| view! { <ErrorTemplate errors /> }.into_view()>
            <Suspense>
                {move || Suspend::new(async move {
                    profile.await.map(|page_info| {
                        view! {
                            <MetaTags
                                url=format!("https://offprint.cafe/profile/{}/{}", &page_info.profile.id, slug::slugify(&page_info.profile.username))
                                title=format!("{}'s Profile — Offprint", &page_info.profile.username)
                                description=&page_info.profile.bio
                                image_url=&page_info.profile.avatar
                            />
                            
                            <div class="w-full">
                                <div class="relative w-full h-[10rem] md:h-[20rem] bg-accent-dark">
                                    {if let Some(banner_art) = page_info.clone().profile.banner_art {
                                        Either::Left(view! {
                                            <img src=banner_art class="object-cover w-full h-full" alt=format!("{}'s banner", &page_info.profile.username) />
                                        })
                                    } else {
                                        Either::Right(view! {
                                            <span></span>
                                        })
                                    }}
                                </div>
                            </div>

                            // Mobile header
                            <div class="flex items-end relative z-10 px-4 md:hidden bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur-lg max-h-[62.5px]">
                                <div class="w-[125px] h-[125px] rounded-full overflow-hidden border-4 border-zinc-300 dark:border-zinc-600">
                                    <img src=page_info.profile.avatar.clone() class="w-full h-full object-cover" alt=format!("{}'s avatar", &page_info.profile.username) />
                                </div>
                                <div class="flex-1"></div>
                                <div class="flex items-center bg-zinc-200 dark:bg-zinc-600 p-1 rounded-xl">
                                    {if auth().current_profile.is_some_and(|c| c.id == page_info.profile.id) {
                                        Either::Left(view! {
                                            <LinkBlock
                                                id="profile-settings-button"
                                                title="Profile Settings"
                                                href=format!("/profile/{}/{}/settings", &page_info.profile.id, slug::slugify(&page_info.profile.username))
                                            >
                                                <span class="button-icon no-text"><Icon icon=TablerIcon::TbSettings width="18px" height="18px" /></span>
                                            </LinkBlock>
                                        })
                                    } else {
                                        Either::Right(view! {
                                            <Button
                                                id="follow-profile-button"
                                                title=format!("Follow {}", &page_info.profile.username)
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
                                        })
                                    }}
                                </div>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-4 md:gap-4 max-w-7xl md:w-11/12 mx-auto">
                                <div class="flex flex-col bg-zinc-200/50 dark:bg-zinc-700/50 md:h-fit md:rounded-xl px-4 pt-2 md:py-4 relative md:bottom-24 col-span-1 backdrop-blur-lg border-b md:border border-zinc-600/25 dark:border-zinc-300/25" style="box-shadow: var(--dropshadow);">
                                    <div class="self-center hidden md:block max-w-[260px] max-h-[260px] rounded-full overflow-hidden border-4 border-zinc-300 dark:border-zinc-600 mb-4">
                                        <img src=page_info.profile.avatar.clone() class="w-full h-full object-cover" alt=format!("{}'s avatar", &page_info.profile.username) />
                                    </div>
                                    <h1 class="text-4xl">{page_info.profile.username.clone()}</h1>
                                    <div class="my-1"><RoleBadge roles=page_info.profile.roles.clone() /></div>
                                    <div class="flex items-center text-zinc-500 dark:text-zinc-400 text-xs md:text-sm">
                                        <A href=format!("/profile/{}/{}/followers", &page_info.profile.id, slug::slugify(&page_info.profile.username))>
                                            {format!("{} follower{}", abbreviate(page_info.profile.followers), pluralize(page_info.profile.followers))}
                                        </A>
                                        <span class="mx-1">"•"</span>
                                        <A href=format!("/profile/{}/{}/following", &page_info.profile.id, slug::slugify(&page_info.profile.username))>
                                            {format!("{} following", abbreviate(page_info.profile.following))}
                                        </A>
                                        <span class="flex-1"></span>
                                        <span class="block md:hidden">
                                            // TODO: add proper localized date display
                                            {format!("Joined {}", "Jan 7, 2025")}
                                        </span>
                                    </div>
                                    <div class="my-2"></div>
                                    <span class="text-sm">{page_info.profile.bio.to_string()}</span>
                                    <div class="hidden md:block my-2"></div>
                                    {if auth().current_profile.is_some_and(|c| c.id == page_info.profile.id) {
                                        Either::Left(view! {
                                            <div class="hidden md:flex items-center w-full bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur-sm rounded-xl overflow-hidden">
                                                <A href=format!("/settings/profiles") attr:class="flex items-center justify-center py-2 px-3.5 all-small-caps font-bold text-lg tracking-wide transition w-full">
                                                    <span><Icon icon=TablerIcon::TbSettings /></span>
                                                    <span>"Settings"</span>
                                                </A>
                                            </div>
                                        })
                                    } else {
                                        Either::Right(view! {
                                            <div class="hidden md:flex items-center w-full">
                                                <Button
                                                    id="follow-button"
                                                    title=format!("Follow {}", &page_info.profile.username)
                                                    full_width=true
                                                    kind=ButtonKind::Primary
                                                >
                                                    <span class="button-icon"><Icon icon=TablerIcon::TbUserHeart /></span>
                                                    <span class="button-text">"Follow"</span>
                                                </Button>
                                                <div class="mx-0.5"></div>
                                                <Button
                                                    id="message-button"
                                                    title=format!("Message {}", &page_info.profile.username)
                                                >
                                                    <span class="button-icon no-text"><Icon icon=TablerIcon::TbMailShare /></span>
                                                </Button>
                                                <div class="mx-0.5"></div>
                                                <Button
                                                    id="report-button"
                                                    title=format!("Report {}", &page_info.profile.username)
                                                >
                                                    <span class="button-icon no-text"><Icon icon=TablerIcon::TbMessageReport /></span>
                                                </Button>
                                            </div>
                                        })
                                    }}
                                    <div class="hidden md:block my-2"></div>
                                    <div class="hidden md:flex items-center text-sm">
                                        <span class="mr-2 relative top-0.5"><Icon icon=TablerIcon::TbCake width="22px" height="22px" /></span>
                                        <span>{format!("Joined {}", "Jan 7, 2025")}</span>
                                    </div>
                                    <div class="flex md:flex-col items-center md:items-baseline mt-4 md:mt-0">
                                        // TODO: links
                                    </div>

                                    // Mobile Nav
                                    <div class="md:hidden my-1"></div>
                                    <div class="flex md:hidden items-center justify-center w-full">
                                        <A
                                            href=format!("/profile/{}/{}", &page_info.profile.id, slug::slugify(&page_info.profile.username))
                                            attr:class="w-1/4 text-center py-2 mx-0.5 all-small-caps text-lg font-bold tracking-wide border-b-2 border-transparent transition [&[aria-current=page]]:border-zinc-700 dark:[&[aria-current=page]]:border-zinc-300"
                                        >
                                            <span>"Home"</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/works", &page_info.profile.id, slug::slugify(&page_info.profile.username))
                                            attr:class="w-1/4 text-center py-2 mx-0.5 all-small-caps text-lg font-bold tracking-wide border-b-2 border-transparent transition [&[aria-current=page]]:border-zinc-700 dark:[&[aria-current=page]]:border-zinc-300"
                                        >
                                            <span>"Works"</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/blogs", &page_info.profile.id, slug::slugify(&page_info.profile.username))
                                            attr:class="w-1/4 text-center py-2 mx-0.5 all-small-caps text-lg font-bold tracking-wide border-b-2 border-transparent transition [&[aria-current=page]]:border-zinc-700 dark:[&[aria-current=page]]:border-zinc-300"
                                        >
                                            <span>"Blogs"</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/shelves", &page_info.profile.id, slug::slugify(&page_info.profile.username))
                                            attr:class="w-1/4 text-center py-2 mx-0.5 all-small-caps text-lg font-bold tracking-wide border-b-2 border-transparent transition [&[aria-current=page]]:border-zinc-700 dark:[&[aria-current=page]]:border-zinc-300"
                                        >
                                            <span>"Shelves"</span>
                                        </A>
                                    </div>
                                </div>
                                <div class="mb-6 md:my-6 col-span-3">
                                    <div 
                                        class="hidden md:flex items-center justify-center w-full py-2 bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur-lg rounded-xl border border-zinc-600/25 dark:border-zinc-300/25 transition"
                                        class:rounded-b-none=move || { url().path().contains("/works") || url().path().contains("/blogs") }
                                        class:border-b-0=move || { url().path().contains("/works") || url().path().contains("/blogs") }
                                    >
                                        <A
                                            href=format!("/profile/{}/{}", &page_info.profile.id, slug::slugify(&page_info.profile.username))
                                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps text-lg font-bold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                                        >
                                            <span class="relative mr-2"><Icon icon=TablerIcon::TbHome width="20px" height="20px" /></span>
                                            <span>"Home"</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/works", &page_info.profile.id, slug::slugify(&page_info.profile.username))
                                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps text-lg font-bold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                                        >
                                            <span class="relative mr-2"><Icon icon=TablerIcon::TbFeather width="20px" height="20px" /></span>
                                            <span>{format!("{} Work{}", abbreviate(page_info.profile.works), pluralize(page_info.profile.works))}</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/blogs", &page_info.profile.id, slug::slugify(&page_info.profile.username))
                                            attr:class="flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps text-lg font-bold tracking-wide transition [&[aria-current=page]]:bg-zinc-300/50 dark:[&[aria-current=page]]:bg-zinc-600/50 [&[aria-current=page]]:backdrop-blur-sm hover:bg-zinc-300/50 dark:hover:bg-zinc-600/50 hover:backdrop-blur-sm"
                                        >
                                            <span class="relative mr-2"><Icon icon=TablerIcon::TbCoffee width="20px" height="20px" /></span>
                                            <span>{format!("{} Blog{}", abbreviate(page_info.profile.blogs), pluralize(page_info.profile.blogs))}</span>
                                        </A>
                                        <A
                                            href=format!("/profile/{}/{}/shelves", &page_info.profile.id, slug::slugify(&page_info.profile.username))
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