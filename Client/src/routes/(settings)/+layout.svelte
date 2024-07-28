<script lang="ts">
    import { IconX, IconChevronRight, IconInfoCircle, IconWorld, IconFilter, IconPalette, IconUserCog, IconAppWindow, IconShield, IconCirclesRelation, IconMoodWink, IconNotification, IconSocial } from "@tabler/icons-svelte";
    import { Metatags } from "$lib/ui/util";
    import { app } from "$lib/state/app.state";
	import { onMount } from "svelte";
	import { Brightness, Theme } from "$lib/models/util";

    onMount(() => {
        const themes = Object.keys(Theme);
        const modes = Object.keys(Brightness);

        document.body.classList.remove(...themes);
        document.body.classList.remove(...modes);

        /* Dark Mode */
        if ($app.brightness !== Brightness.System) {
            document.body.classList.add($app.brightness);
        } else {
            if (document.defaultView!.matchMedia('(prefers-color-scheme: dark)').matches) {
                document.body.classList.add(Brightness.Dark);
            } else {
                document.body.classList.add(Brightness.Light);
            }
        }

        /* Accent Color */
        document.body.classList.add($app.theme);
        const themeColor = document.querySelector("meta[name='theme-color']");
        const accentColor = getComputedStyle(document.body).getPropertyValue("--accent");
        themeColor?.setAttribute("content", `rgba(${accentColor})`);

        /* Pattern */
        // document.documentElement.style.setProperty("--pattern", $app.pattern);
    });
</script>

<Metatags
    title="Settings — Offprint"
    desc="Make Offprint Your Own"
    url="https://offprint.cafe/settings/about"
/>
        
<div class="flex flex-col items-center justify-center w-full h-[100svh] bg-cover bg-center relative z-0" style="background-image: url('/images/alchemy.jpg')">
    <div class="absolute top-4 left-4 z-50">
        <a href="/">
            <span><IconX size="32px" style="color: rgb(228 228 231 / 0.75);" /></span>
        </a>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-4 w-full mx-auto max-w-6xl h-[100svh] py-6 md:py-0 md:h-[75svh] relative bg-zinc-200/75 dark:bg-zinc-700/75 backdrop-blur border-b md:border border-zinc-600/25 dark:border-zinc-300/25 md:rounded-xl overflow-hidden">
        <div class="flex flex-col bg-zinc-300/50 dark:bg-zinc-600/50 font-header overflow-y-scroll border-r border-zinc-600/25 dark:border-zinc-300/25 col-span-1">
            <div class="p-4">
                <h3 class="text-xl all-small-caps relative left-3.5 tracking-wide">General</h3>
                <a
                    class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                    href="/settings"
                >
                    <span class="relative mr-2">
                        <IconInfoCircle size="24px" />
                    </span>
                    <span class="flex-1 relative top-0.5">About</span>
                    <span class="relative text-zinc-400 dark:text-zinc-500">
                        <IconChevronRight size="20px" />
                    </span>
                </a>
                <a
                    class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                    href="localization"
                >
                    <span class="relative mr-2">
                        <IconWorld size="24px" />
                    </span>
                    <span class="flex-1 relative top-0.5">Localization</span>
                    <span class="relative text-zinc-400 dark:text-zinc-500">
                        <IconChevronRight size="20px" />
                    </span>
                </a>
                <a
                    class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                    href="filters"
                >
                    <span class="relative mr-2">
                        <IconFilter size="24px" />
                    </span>
                    <span class="flex-1 relative top-0.5">Filters</span>
                    <span class="relative text-zinc-400 dark:text-zinc-500">
                        <IconChevronRight size="20px" />
                    </span>
                </a>
                <a
                    class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                    href="appearance"
                >
                    <span class="relative mr-2">
                        <IconPalette size="24px" />
                    </span>
                    <span class="flex-1 relative top-0.5">Appearance</span>
                    <span class="relative text-zinc-400 dark:text-zinc-500">
                        <IconChevronRight size="20px" />
                    </span>
                </a>
                <div class="my-2" />
                <h3 class="text-xl all-small-caps relative left-3.5 tracking-wide">Account</h3>
                <a
                    class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                    href="account-info"
                >
                    <span class="relative mr-2">
                        <IconUserCog size="24px" />
                    </span>
                    <span class="flex-1 relative top-0.5">Account Info</span>
                    <span class="relative text-zinc-400 dark:text-zinc-500">
                        <IconChevronRight size="20px" />
                    </span>
                </a>
                <a
                    class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                    href="sessions"
                >
                    <span class="relative mr-2">
                        <IconAppWindow size="24px" />
                    </span>
                    <span class="flex-1 relative top-0.5">Sessions</span>
                    <span class="relative text-zinc-400 dark:text-zinc-500">
                        <IconChevronRight size="20px" />
                    </span>
                </a>
                <a
                    class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                    href="security-privacy"
                >
                    <span class="relative mr-2">
                        <IconShield size="24px" />
                    </span>
                    <span class="flex-1 relative top-0.5">Security & Privacy</span>
                    <span class="relative text-zinc-400 dark:text-zinc-500">
                        <IconChevronRight size="20px" />
                    </span>
                </a>
                <a
                    class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                    href="connections"
                >
                    <span class="relative mr-2">
                        <IconCirclesRelation size="24px" />
                    </span>
                    <span class="flex-1 relative top-0.5">Connections</span>
                    <span class="relative text-zinc-400 dark:text-zinc-500">
                        <IconChevronRight size="20px" />
                    </span>
                </a>
                <div class="my-2" />
                <h3 class="text-xl all-small-caps relative left-3.5 tracking-wide">Profile</h3>
                <a
                    class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                    href="profiles"
                >
                    <span class="relative mr-2">
                        <IconMoodWink size="24px" />
                    </span>
                    <span class="flex-1 relative top-0.5">Profiles</span>
                    <span class="relative text-zinc-400 dark:text-zinc-500">
                        <IconChevronRight size="20px" />
                    </span>
                </a>
                <a
                    class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                    href="notifications"
                >
                    <span class="relative mr-2">
                        <IconNotification size="24px" />
                    </span>
                    <span class="flex-1 relative top-0.5">Notifications</span>
                    <span class="relative text-zinc-400 dark:text-zinc-500">
                        <IconChevronRight size="20px" />
                    </span>
                </a>
                <a
                    class="flex items-center px-4 py-3 transition hover:bg-zinc-400/50 dark:hover:bg-zinc-500/50 rounded-xl [&[aria-current=page]]:bg-accent [&[aria-current=page]]:text-white"
                    href="social"
                >
                    <span class="relative mr-2">
                        <IconSocial size="24px" />
                    </span>
                    <span class="flex-1 relative top-0.5">Social</span>
                    <span class="relative text-zinc-400 dark:text-zinc-500">
                        <IconChevronRight size="20px" />
                    </span>
                </a>
            </div>
        </div>
        <div class="col-span-3 overflow-y-auto">
            <slot />
        </div>
    </div>
</div>

<style>
    a {
        @apply text-default hover:text-default;
    }
</style>