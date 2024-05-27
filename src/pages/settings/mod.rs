mod about;
mod localization;
mod filters;
mod appearance;
mod what_is;
mod terms_of_service;
mod privacy_policy;
mod constitution;
mod omnibus;

pub use about::AboutSettings;
pub use terms_of_service::TermsOfService;
pub use privacy_policy::PrivacyPolicy;
pub use constitution::Constitution;
pub use omnibus::Omnibus;
pub use what_is::WhatIs;
pub use localization::LocalizationSettings;
pub use filters::FiltersSettings;
pub use appearance::AppearanceSettings;

use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;
use crate::ui::util::{MetaTags, MetaTagOptions};

#[component(transparent)]
pub fn SettingsRoutes() -> impl IntoView {
    view! {
        <Route path="settings" view=SettingsLayout>
            <Route path="" view=SettingsPage />
            <Route path="about" view=Outlet>
                <Route path="" view=AboutSettings />
                <Route path="terms-of-service" view=TermsOfService />
                <Route path="privacy-policy" view=PrivacyPolicy />
                <Route path="constitution" view=Constitution />
                <Route path="omnibus" view=Omnibus />
                <Route path="what-is" view=WhatIs />
            </Route>
            <Route path="localization" view=LocalizationSettings />
            <Route path="filters" view=FiltersSettings />
            <Route path="appearance" view=AppearanceSettings />
        </Route>
    }
}

#[component]
pub fn SettingsPage() -> impl IntoView {
    view! {
        <div class="w-full h-full flex flex-col items-center justify-center">
            <div class="empty">
                <h3>"Select a Page"</h3>
                <p>"They're all on the left, if you couldn't tell."</p>
            </div>
        </div>
    }
}

#[component]
pub fn SettingsLayout() -> impl IntoView {
    let meta_options = MetaTagOptions {
        url: "https://offprint.cafe/settings".to_string(),
        title: "Settings — Offprint".to_string(),
        author_url: None,
        description: "Make Offprint Your Own".to_string(),
        image_url: "/images/beatriz.png".to_string(),
    };
    
    view! {
        <MetaTags options=meta_options />
        
        <div class="flex flex-col items-center justify-center w-full h-[100svh] bg-cover bg-center relative z-0" style="background-image: url('/images/alchemy.jpg')">
            <div class="absolute top-4 left-4 z-50">
                <A href="/">
                    <span><Icon icon=remixicon::RiCloseSystemLine width="32px" height="32px" style="color: rgb(228 228 231 / 0.75);" /></span>
                </A>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-4 w-full mx-auto max-w-6xl h-[100svh] py-6 md:py-0 md:h-[75svh] relative bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur border-b md:border border-zinc-600/25 dark:border-zinc-300/25 md:rounded-xl overflow-hidden">
                <div class="flex flex-col bg-zinc-300/50 dark:bg-zinc-600/50 font-header overflow-y-scroll border-r border-zinc-600/25 dark:border-zinc-300/25 col-span-1">
                    <div class="p-4">
                        <h3 class="text-xl all-small-caps relative left-3.5 tracking-wide">"General"</h3>
                        <A
                            class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                            href="about"
                        >
                            <span class="relative mr-2">
                                <Icon icon=remixicon::RiInformationSystemLine width="24px" height="24px" />
                            </span>
                            <span class="flex-1 relative top-0.5">"About"</span>
                            <span class="relative text-zinc-400 dark:text-zinc-500">
                                <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                            </span>
                        </A>
                        <A
                            class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                            href="localization"
                        >
                            <span class="relative mr-2">
                                <Icon icon=remixicon::RiEarthMapLine width="24px" height="24px" />
                            </span>
                            <span class="flex-1 relative top-0.5">"Localization"</span>
                            <span class="relative text-zinc-400 dark:text-zinc-500">
                                <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                            </span>
                        </A>
                        <A
                            class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                            href="filters"
                        >
                            <span class="relative mr-2">
                                <Icon icon=remixicon::RiFilterSystemLine width="24px" height="24px" />
                            </span>
                            <span class="flex-1 relative top-0.5">"Filters"</span>
                            <span class="relative text-zinc-400 dark:text-zinc-500">
                                <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                            </span>
                        </A>
                        <A
                            class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                            href="appearance"
                        >
                            <span class="relative mr-2">
                                <Icon icon=remixicon::RiPaletteDesignLine width="24px" height="24px" />
                            </span>
                            <span class="flex-1 relative top-0.5">"Appearance"</span>
                            <span class="relative text-zinc-400 dark:text-zinc-500">
                                <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                            </span>
                        </A>
                        <div class="my-2" />
                        <h3 class="text-xl all-small-caps relative left-3.5 tracking-wide">"Account"</h3>
                        <A
                            class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                            href="account-info"
                        >
                            <span class="relative mr-2">
                                <Icon icon=remixicon::RiUserSettingsUserFacesLine width="24px" height="24px" />
                            </span>
                            <span class="flex-1 relative top-0.5">"Account Info"</span>
                            <span class="relative text-zinc-400 dark:text-zinc-500">
                                <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                            </span>
                        </A>
                        <A
                            class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                            href="sessions"
                        >
                            <span class="relative mr-2">
                                <Icon icon=remixicon::RiWindow2BusinessLine width="24px" height="24px" />
                            </span>
                            <span class="flex-1 relative top-0.5">"Sessions"</span>
                            <span class="relative text-zinc-400 dark:text-zinc-500">
                                <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                            </span>
                        </A>
                        <A
                            class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                            href="security-privacy"
                        >
                            <span class="relative mr-2">
                                <Icon icon=remixicon::RiShieldUserSystemLine width="24px" height="24px" />
                            </span>
                            <span class="flex-1 relative top-0.5">"Security & Privacy"</span>
                            <span class="relative text-zinc-400 dark:text-zinc-500">
                                <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                            </span>
                        </A>
                        <A
                            class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                            href="connections"
                        >
                            <span class="relative mr-2">
                                <Icon icon=remixicon::RiLinksBusinessLine width="24px" height="24px" />
                            </span>
                            <span class="flex-1 relative top-0.5">"Connections"</span>
                            <span class="relative text-zinc-400 dark:text-zinc-500">
                                <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                            </span>
                        </A>
                        <div class="my-2" />
                        <h3 class="text-xl all-small-caps relative left-3.5 tracking-wide">"Profile"</h3>
                        <A
                            class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                            href="profiles"
                        >
                            <span class="relative mr-2">
                                <Icon icon=remixicon::RiUserSmileUserFacesLine width="24px" height="24px" />
                            </span>
                            <span class="flex-1 relative top-0.5">"Profiles"</span>
                            <span class="relative text-zinc-400 dark:text-zinc-500">
                                <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                            </span>
                        </A>
                        <A
                            class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                            href="notifications"
                        >
                            <span class="relative mr-2">
                                <Icon icon=remixicon::RiNotificationBadgeSystemLine width="24px" height="24px" />
                            </span>
                            <span class="flex-1 relative top-0.5">"Notifications"</span>
                            <span class="relative text-zinc-400 dark:text-zinc-500">
                                <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                            </span>
                        </A>
                        <A
                            class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                            href="social"
                        >
                            <span class="relative mr-2">
                                <Icon icon=remixicon::RiGroup2UserFacesLine width="24px" height="24px" />
                            </span>
                            <span class="flex-1 relative top-0.5">"Social"</span>
                            <span class="relative text-zinc-400 dark:text-zinc-500">
                                <Icon icon=remixicon::RiArrowRightSArrowsLine width="20px" height="20px" />
                            </span>
                        </A>
                    </div>
                </div>
                <div class="col-span-3 overflow-y-auto">
                    <Outlet />
                </div>
            </div>
        </div>
    }
}