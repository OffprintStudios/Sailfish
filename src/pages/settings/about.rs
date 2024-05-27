use leptos::*;
use leptos_router::*;
use leptos_icons::*;
use icondata_ri as remixicon;

#[component]
pub fn AboutSettings() -> impl IntoView {
    view! {
        <div class="flex flex-col gap-4 p-6">
            <div>
                <h4 class="all-small-caps tracking-wide relative text-xl left-2">"Info"</h4>
                <div class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-xl">
                    <span class="mr-4"><Icon icon=remixicon::RiCodeSSlashDevelopmentLine width="24px" height="24px" /></span>
                    <span class="flex-1">"Version"</span>
                    <span class="text-zinc-400 dark:text-zinc-500">"v1.0.0-beta.10"</span>
                </div>
            </div>
            <div>
                <h4 class="all-small-caps tracking-wide relative text-xl left-2">"Docs"</h4>
                <A class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-t-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="terms-of-service">
                    <span class="mr-4"><Icon icon=remixicon::RiNewspaperDocumentLine width="24px" height="24px" /></span>
                    <span class="flex-1">"Terms of Service"</span>
                    <span class="text-zinc-400 dark:text-zinc-500"><Icon icon=remixicon::RiArrowRightSArrowsLine width="24px" height="24px" /></span>
                </A>
                <A class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="privacy-policy">
                    <span class="mr-4"><Icon icon=remixicon::RiLock2SystemLine width="24px" height="24px" /></span>
                    <span class="flex-1">"Privacy Policy"</span>
                    <span class="text-zinc-400 dark:text-zinc-500"><Icon icon=remixicon::RiArrowRightSArrowsLine width="24px" height="24px" /></span>
                </A>
                <A class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="constitution">
                    <span class="mr-4"><Icon icon=remixicon::RiFilePaper2DocumentLine width="24px" height="24px" /></span>
                    <span class="flex-1">"Offprint Constitution"</span>
                    <span class="text-zinc-400 dark:text-zinc-500"><Icon icon=remixicon::RiArrowRightSArrowsLine width="24px" height="24px" /></span>
                </A>
                <A class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="omnibus">
                    <span class="mr-4"><Icon icon=remixicon::RiArticleDocumentLine width="24px" height="24px" /></span>
                    <span class="flex-1">"Offprint Omnibus"</span>
                    <span class="text-zinc-400 dark:text-zinc-500"><Icon icon=remixicon::RiArrowRightSArrowsLine width="24px" height="24px" /></span>
                </A>
                <A class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-b-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition" href="what-is">
                    <span class="mr-4"><Icon icon=remixicon::RiQuestionSystemLine width="24px" height="24px" /></span>
                    <span class="flex-1">"What is Offprint?"</span>
                    <span class="text-zinc-400 dark:text-zinc-500"><Icon icon=remixicon::RiArrowRightSArrowsLine width="24px" height="24px" /></span>
                </A>
            </div>
            <div>
                <h4 class="all-small-caps tracking-wide relative text-xl left-2">"Funding"</h4>
                <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-t-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="https://www.patreon.com/offprintstudios">
                    <span class="mr-4"><Icon icon=remixicon::RiPatreonLogosFill width="24px" height="24px" /></span>
                    <span class="flex-1">"Patreon"</span>
                    <span class="text-zinc-400 dark:text-zinc-500"><Icon icon=remixicon::RiExternalLinkSystemLine width="24px" height="24px" /></span>
                </a>
                <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-b-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition" href="https://ko-fi.com/offprintstudios">
                    <span class="mr-4"><Icon icon=remixicon::RiCupMapLine width="24px" height="24px" /></span>
                    <span class="flex-1">"Ko-Fi"</span>
                    <span class="text-zinc-400 dark:text-zinc-500"><Icon icon=remixicon::RiExternalLinkSystemLine width="24px" height="24px" /></span>
                </a>
            </div>
            <div>
                <h4 class="all-small-caps tracking-wide relative text-xl left-2">"Connect"</h4>
                <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-t-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="https://github.com/OffprintStudios/Sailfish">
                    <span class="mr-4"><Icon icon=remixicon::RiGithubLogosFill width="24px" height="24px" /></span>
                    <span class="flex-1">"GitHub"</span>
                    <span class="text-zinc-400 dark:text-zinc-500"><Icon icon=remixicon::RiExternalLinkSystemLine width="24px" height="24px" /></span>
                </a>
                <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-b-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition" href="https://discord.gg/9cnSwfn">
                    <span class="mr-4"><Icon icon=remixicon::RiDiscordLogosFill width="24px" height="24px" /></span>
                    <span class="flex-1">"Discord"</span>
                    <span class="text-zinc-400 dark:text-zinc-500"><Icon icon=remixicon::RiExternalLinkSystemLine width="24px" height="24px" /></span>
                </a>
            </div>
        </div>
    }
}