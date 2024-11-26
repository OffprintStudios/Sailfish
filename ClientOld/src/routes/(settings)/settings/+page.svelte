<script lang="ts">
    import { IconBrandDiscord, IconBrandGithub, IconBrandPatreon, IconBuildingBank, IconChevronRight, IconCode, IconCoffee, IconExternalLink, IconHelp, IconLock, IconNews, IconTextDirectionRtl, IconWritingSign } from "@tabler/icons-svelte";
</script>

<div class="flex flex-col gap-4 p-6">
    <div>
        <h4 class="all-small-caps tracking-wide relative text-xl left-2">Info</h4>
        <div class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-xl">
            <span class="mr-4"><IconCode size="24px" /></span>
            <span class="flex-1">Version</span>
            <span class="text-zinc-400 dark:text-zinc-500">v1.0.0-beta.10</span>
        </div>
    </div>
    <div>
        <h4 class="all-small-caps tracking-wide relative text-xl left-2">Docs</h4>
        <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-t-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="/settings/terms-of-service">
            <span class="mr-4"><IconNews size="24px" /></span>
            <span class="flex-1">Terms of Service</span>
            <span class="text-zinc-400 dark:text-zinc-500"><IconChevronRight size="24px" /></span>
        </a>
        <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="/settings/privacy-policy">
            <span class="mr-4"><IconLock size="24px" /></span>
            <span class="flex-1">Privacy Policy</span>
            <span class="text-zinc-400 dark:text-zinc-500"><IconChevronRight size="20px" /></span>
        </a>
        <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="/settings/constitution">
            <span class="mr-4"><IconBuildingBank size="24px" /></span>
            <span class="flex-1">Offprint Constitution</span>
            <span class="text-zinc-400 dark:text-zinc-500"><IconChevronRight size="20px" /></span>
        </a>
        <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="/settings/omnibus">
            <span class="mr-4"><IconWritingSign size="24px" /></span>
            <span class="flex-1">Offprint Omnibus</span>
            <span class="text-zinc-400 dark:text-zinc-500"><IconChevronRight size="20px" /></span>
        </a>
        <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-b-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition" href="/settings/what-is">
            <span class="mr-4"><IconHelp size="24px" /></span>
            <span class="flex-1">What is Offprint?</span>
            <span class="text-zinc-400 dark:text-zinc-500"><IconChevronRight size="20px" /></span>
        </a>
    </div>
    <div>
        <h4 class="all-small-caps tracking-wide relative text-xl left-2">Funding</h4>
        <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-t-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="https://www.patreon.com/offprintstudios">
            <span class="mr-4"><IconBrandPatreon size="24px" /></span>
            <span class="flex-1">Patreon</span>
            <span class="text-zinc-400 dark:text-zinc-500"><IconExternalLink size="24px" /></span>
        </a>
        <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-b-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition" href="https://ko-fi.com/offprintstudios">
            <span class="mr-4"><IconCoffee size="24px" /></span>
            <span class="flex-1">Ko-Fi</span>
            <span class="text-zinc-400 dark:text-zinc-500"><IconExternalLink size="24px" /></span>
        </a>
    </div>
    <div>
        <h4 class="all-small-caps tracking-wide relative text-xl left-2">Connect</h4>
        <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-t-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition border-b border-zinc-600/25 dark:border-zinc-300/25" href="https://github.com/OffprintStudios/Sailfish">
            <span class="mr-4"><IconBrandGithub size="24px" /></span>
            <span class="flex-1">GitHub</span>
            <span class="text-zinc-400 dark:text-zinc-500"><IconExternalLink size="24px" /></span>
        </a>
        <a class="flex items-center bg-zinc-300/50 dark:bg-zinc-600/50 p-4 rounded-b-xl hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 transition" href="https://discord.gg/9cnSwfn">
            <span class="mr-4"><IconBrandDiscord size="24px" /></span>
            <span class="flex-1">Discord</span>
            <span class="text-zinc-400 dark:text-zinc-500"><IconExternalLink size="24px" /></span>
        </a>
    </div>
</div>

<style>
    a {
        @apply text-default hover:text-default;
    }
</style>