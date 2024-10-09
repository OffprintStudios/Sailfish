<script lang="ts">
	import type { LayoutServerData } from "./$types";
    import { Metatags, LinkBlock, Button } from "$lib/ui/util";
    import { slugify, abbreviate, pluralize, localeDate } from "$lib/util/functions";
    import { auth } from "$lib/state/auth.state";
	import { IconAdjustments, IconBookmarks, IconBooks, IconCake, IconChevronDown, IconChevronUp, IconCoffee, IconDotsVertical, IconFlag3, IconHome, IconMailFast, IconUserPlus } from "@tabler/icons-svelte";
    import { slide } from "svelte/transition";
    import { page } from "$app/stores";

    export let data: LayoutServerData;

    let isOptionsMenuOpen = false;
</script>

<Metatags
    title="{data.profile.username}'s Profile — Offprint"
    desc="{data.profile.bio}"
    username="{data.profile.username}"
    url="/profile/{data.profile.id}/{slugify(data.profile.username)}"
    image="{data.profile.avatar}"
/>

<div class="w-full">
    <div class="relative w-full h-[10rem] md:h-[20rem] bg-accent-dark">
        {#if data.profile.bannerArt}
            <img src={data.profile.bannerArt} class="object-cover w-full h-full" alt="{data.profile.username}'s Banner Art" />
        {/if}
    </div>

    <!--Mobile header-->
    <div class="flex items-end relative z-10 px-4 md:hidden bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur-lg max-h-[62.5px]">
        <div class="w-[125px] h-[125px] rounded-full overflow-hidden border-4 border-zinc-300 dark:border-zinc-600">
            <img src={data.profile.avatar} class="w-full h-full object-cover" alt="{data.profile.username}'s Avatar" />
        </div>
        <div class="flex-1"><!--spacer--></div>
        <div class="flex items-center bg-zinc-200 dark:bg-zinc-600 p-1 rounded-xl">
            {#if $auth.currProfile && $auth.currProfile.id === data.profile.id}
                <LinkBlock id="settings-button-mobile" title="Settings" href="/profile/{data.profile.id}/{slugify(data.profile.username)}/settings">
                    <span class="link-icon no-text"><IconAdjustments size="18px" /></span>
                </LinkBlock>
            {:else}
                <Button id="follow-button-mobile" title="Follow {data.profile.username}">
                    <span class="button-icon no-text"><IconUserPlus size="18px" /></span>
                </Button>
                <div class="mx-0.5"><!--spacer--></div>
                <Button id="more-options-button-mobile" title="More Options">
                    <span class="button-icon no-text"><IconDotsVertical size="18px" /></span>
                </Button>
            {/if}
        </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-4 md:gap-4 max-w-7xl md:w-11/12 mx-auto">
        <div class="flex flex-col bg-zinc-200/50 dark:bg-zinc-700/50 md:h-fit md:rounded-xl px-4 pt-2 md:py-4 relative md:bottom-24 col-span-1 backdrop-blur-lg border-b md:border border-zinc-600/25 dark:border-zinc-300/25" style="box-shadow: var(--dropshadow);">
            <div class="self-center hidden md:block max-w-[260px] max-h-[260px] rounded-full overflow-hidden border-4 border-zinc-300 dark:border-zinc-600 mb-4">
                <img src="{data.profile.avatar}" class="w-full h-full object-cover" alt="{data.profile.username}'s Avatar">
            </div>
            <h1 class="text-4xl">{data.profile.username}</h1>
            <div class="my-1"><!--<RoleBadge roles={data.roles} size="large" />--></div>
            <div class="flex items-center text-zinc-500 dark:text-zinc-400 text-xs md:text-sm">
                <a href="/profile/{data.profile.id}/{slugify(data.profile.username)}/followers" class="text-zinc-500 dark:text-zinc-400 hover:underline">
                    {abbreviate(data.profile.followers)} follower{pluralize(data.profile.followers)}
                </a>
                <span class="mx-1">•</span>
                <a href="/profile/{data.profile.id}/{slugify(data.profile.username)}/following" class="text-zinc-500 dark:text-zinc-400 hover:underline">
                    {abbreviate(data.profile.following)} following
                </a>
                <span class="flex-1"><!--spacer--></span>
                <span class="block md:hidden">
                    Joined {localeDate(data.profile.createdAt, "mediumDate")}
                </span>
            </div>
            <div class="my-2"><!--spacer--></div>
            <span class="text-sm">{data.profile.bio}</span>
            <div class="hidden md:block my-2"><!--spacer--></div>
            {#if $auth.currProfile && $auth.currProfile.id === data.profile.id}
                <div class="hidden md:flex items-center w-full bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur-sm rounded-xl overflow-hidden">
                    <a class="card-button w-full justify-center border-r-0" id="settings-button" title="Profile Settings" href="/settings/profiles">
                        <span class="button-icon mr-2"><IconAdjustments /></span>
                        <span class="button-text">Settings</span>
                    </a>
                </div>
            {:else}
                <div class="hidden md:flex items-center w-full bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur-sm rounded-xl overflow-hidden">
                    <button class="card-button big" id="follow-button" title="Follow {data.profile.username}">
                        <span class="button-icon"><IconUserPlus /></span>
                        <span class="button-text">Follow</span>
                    </button>
                    <button class="card-button small" id="more-options-button" title="More Options" on:click={() => isOptionsMenuOpen = !isOptionsMenuOpen}>
                        {#if isOptionsMenuOpen}
                            <span class="button-icon no-text"><IconChevronUp /></span>
                        {:else}
                            <span class="button-icon no-text"><IconChevronDown /></span>
                        {/if}
                    </button>
                </div>
                {#if isOptionsMenuOpen}
                    <div class="mt-2 rounded-xl overflow-hidden bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur-sm" transition:slide>
                        <button class="card-button full top" id="send-message-button" title="Send a message to {data.profile.username}">
                            <span class="button-icon"><IconMailFast /></span>
                            <span class="button-text">Send Message</span>
                        </button>
                        <button class="card-button full" id="report-user-button" title="Report {data.profile.username}">
                            <span class="button-icon"><IconFlag3 /></span>
                            <span class="button-text">Report</span>
                        </button>
                    </div>
                {/if}
            {/if}
            <div class="hidden md:block my-2"><!--spacer--></div>
            <div class="md:flex items-center text-sm hidden">
                <span class="mr-2 relative"><IconCake size="22px" /></span>
                <span>Joined {localeDate(data.profile.createdAt, "mediumDate")}</span>
            </div>
            <div class="flex md:flex-col items-center md:items-baseline mt-4 md:mt-0">
                {#each data.profile.links as link}
                    <!--SocialLinkBadge-->
                {/each}
            </div>

            <!--mobile profile nav-->
            <div class="md:hidden my-1"><!--spacer--></div>
            <div class="flex md:hidden items-center justify-center w-full">
                <a class="nav-link-mobile" class:active={$page.url.pathname === `/profile/${data.profile.id}/${slugify(data.profile.username)}`} href="/profile/{data.profile.id}/{slugify(data.profile.username)}">
                    <span>Home</span>
                </a>
                <a class="nav-link-mobile" class:active={$page.url.pathname.includes("/works")} href="/profile/{data.profile.id}/{slugify(data.profile.username)}/works">
                    <span>Works</span>
                </a>
                <a class="nav-link-mobile" class:active={$page.url.pathname.includes("/blogs")} href="/profile/{data.profile.id}/{slugify(data.profile.username)}/blogs">
                    <span>Blogs</span>
                </a>
                <a class="nav-link-mobile" class:active={$page.url.pathname.includes("/shelves")} href="/profile/{data.profile.id}/{slugify(data.profile.username)}/shelves">
                    <span>Shelves</span>
                </a>
            </div>
        </div>
        <div class="mb-6 md:my-6 col-span-3">
            <div
                class="hidden md:flex items-center justify-center w-full py-2 bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur-lg rounded-xl border border-zinc-600/25 dark:border-zinc-300/25 transition"
                class:rounded-b-none={$page.url.pathname.includes("/works") || $page.url.pathname.includes("/blogs")}
                class:border-b-0={$page.url.pathname.includes("/works") || $page.url.pathname.includes("/blogs")}
                style="box-shadow: var(--dropshadow);"
            >
                <a class="nav-link" class:active={$page.url.pathname === `/profile/${data.profile.id}/${slugify(data.profile.username)}`} href="/profile/{data.profile.id}/{slugify(data.profile.username)}">
                    <span class="nav-link-icon"><IconHome size="20px" /></span>
                    <span>Home</span>
                </a>
                <a class="nav-link" class:active={$page.url.pathname.includes("/works")} href="/profile/{data.profile.id}/{slugify(data.profile.username)}/works">
                    <span class="nav-link-icon"><IconBooks size="20" /></span>
                    <span>0 Works</span>
                </a>
                <a class="nav-link" class:active={$page.url.pathname.includes("/blogs")} href="/profile/{data.profile.id}/{slugify(data.profile.username)}/blogs">
                    <span class="nav-link-icon"><IconCoffee size="20px" /></span>
                    <span>0 Blogs</span>
                </a>
                <a class="nav-link" class:active={$page.url.pathname.includes("/shelves")} href="/profile/{data.profile.id}/{slugify(data.profile.username)}/shelves">
                    <span class="nav-link-icon"><IconBookmarks size="20" /></span>
                    <span>Shelves</span>
                </a>
            </div>
            <div class="w-full mx-auto">
                <slot />
            </div>
        </div>
    </div>
</div>

<style>
    a.nav-link {
        @apply flex items-center justify-center text-default hover:text-default px-6 py-3 mx-1 rounded-xl all-small-caps text-lg font-bold tracking-wide transition;
    }

    a.nav-link.active, a.nav-link:hover {
        @apply bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur-sm;
    }

    a.nav-link > span.nav-link-icon {
        @apply relative mr-2;
    }

    a.nav-link-mobile {
        @apply w-1/4 text-center py-2 mx-0.5 all-small-caps text-lg font-bold tracking-wide border-b-2 border-transparent;
        color: var(--text-color);
    }

    a.nav-link-mobile.active {
        @apply border-zinc-700 dark:border-zinc-300;
    }

    button.card-button, a.card-button {
        @apply flex items-center text-default hover:text-default py-2 px-3.5 all-small-caps font-bold text-lg tracking-wide transition;
    }

    button.card-button:hover, a.card-button:hover {
        @apply bg-zinc-400/50 dark:bg-zinc-500/25;
    }

    button.card-button.big {
        @apply w-5/6 justify-center border-r border-zinc-400 dark:border-zinc-500;
    }

    button.card-button.small {
        @apply w-1/6 h-full;
    }

    button.card-button.full {
        @apply w-full first:border-r-0 text-left px-4;
    }

    button.card-button.top {
        @apply border-b border-zinc-400 dark:border-zinc-500;
    }

    button.card-button > span.button-icon {
        @apply mr-3 relative;
    }
</style>