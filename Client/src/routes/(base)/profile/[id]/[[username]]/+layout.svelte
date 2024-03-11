<script lang="ts">
    import type { PageData } from "./$types";
    import { Button } from "$lib/ui/util";
    import { page } from "$app/stores";
	import { RiAlarmWarningLine, RiArrowDownSLine, RiArrowUpSLine, RiCake2Line, RiCupLine, RiHome6Line, RiMore2Fill, RiSendPlaneLine, RiUserFollowLine } from "svelte-remixicon";
	import { abbreviate, localeDate, pluralize, slugify } from "$lib/util/functions";
    import { BookCopy, LibrarySquare } from "lucide-svelte";
	import RoleBadge from "$lib/ui/util/RoleBadge.svelte";
	import { slide } from "svelte/transition";

    export let data: PageData;

    let isOptionsMenuOpen = false;
</script>

<svelte:head>
	<title>{data.username}'s Profile &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{data.username}'s Profile" />
	<meta name="description" content={data.bio ?? "Just another face in the crowd"} />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="profile" />
	<meta property="profile:username" content={data.username} />
	<meta
		property="og:url"
		content="https://offprint.cafe/profile/{data.id}/{slugify(data.username)}"
	/>
	<meta property="og:title" content="{data.username}'s Profile" />
	<meta property="og:description" content={data.bio ?? "Just another face in the crowd"} />
	<meta property="og:image" content={data.avatar} />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary" />
	<meta
		property="twitter:url"
		content="https://offprint.cafe/profile/{data.id}/{slugify(data.username)}"
	/>
	<meta property="twitter:title" content="{data.username}'s Profile" />
	<meta property="twitter:description" content={data.bio ?? "Just another name in the crowd"} />
	<meta property="twitter:image" content={data.avatar} />
</svelte:head>

<div class="w-full">
    <div class="relative w-full h-[10rem] md:h-[20rem]" style="background: rgb(var(--accent-dark));">
        {#if data.bannerArt}
            <img src={data.bannerArt} class="object-cover w-full h-full" alt="{data.username}'s Banner Art" />
        {/if}
    </div>

    <!--Mobile header-->
    <div class="flex items-end relative z-10 px-4 md:hidden bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur-lg max-h-[62.5px]">
        <div class="w-[125px] h-[125px] rounded-full overflow-hidden border-4 border-zinc-300 dark:border-zinc-600">
            <img src={data.avatar} class="w-full h-full object-cover" alt="{data.username}'s Avatar" />
        </div>
        <div class="flex-1"><!--spacer--></div>
        <div class="flex items-center bg-zinc-200 dark:bg-zinc-600 p-1 rounded-xl">
            <Button id="follow-button-mobile" title="Follow {data.username}">
                <span class="button-icon no-text"><RiUserFollowLine size="18px" /></span>
            </Button>
            <div class="mx-0.5"><!--spacer--></div>
            <Button id="more-options-button-mobile" title="More Options">
                <span class="button-icon no-text"><RiMore2Fill size="18px" /></span>
            </Button>
        </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-4 md:gap-4 max-w-7xl md:w-11/12 mx-auto">
        <div class="flex flex-col bg-zinc-200/50 dark:bg-zinc-700/50 md:rounded-xl px-4 pt-2 md:py-4 relative md:bottom-24 col-span-1 backdrop-blur-lg border-b md:border border-zinc-600/25 dark:border-zinc-300/25" style="box-shadow: var(--dropshadow);">
            <div class="self-center hidden md:block max-w-[260px] max-h-[260px] rounded-full overflow-hidden border-4 border-zinc-300 dark:border-zinc-600 mb-4">
                <img src="{data.avatar}" class="w-full h-full object-cover" alt="{data.username}'s Avatar">
            </div>
            <h1 class="text-4xl">{data.username}</h1>
            <div class="my-1"><RoleBadge roles={data.roles} size="large" /></div>
            <div class="flex items-center text-zinc-500 dark:text-zinc-400 text-xs md:text-sm">
                <a href="/profile/{data.id}/{slugify(data.username)}/followers">
                    {abbreviate(data.followers)} follower{pluralize(data.followers)}
                </a>
                <span class="mx-1">•</span>
                <a href="/profile/{data.id}/{slugify(data.username)}/following">
                    {abbreviate(data.following)} following
                </a>
                <span class="flex-1"><!--spacer--></span>
                <span class="block md:hidden">
                    Joined {localeDate(data.createdAt, "mediumDate")}
                </span>
            </div>
            <div class="my-2"><!--spacer--></div>
            <span class="text-sm">{data.bio}</span>
            <div class="hidden md:block my-2"><!--spacer--></div>
            <div class="hidden md:flex items-center w-full bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur-sm rounded-xl overflow-hidden">
                <button class="card-button big" id="follow-button" title="Follow {data.username}">
                    <span class="button-icon"><RiUserFollowLine /></span>
                    <span class="button-text">Follow</span>
                </button>
                <button class="card-button small" id="more-options-button" title="More Options" on:click={() => isOptionsMenuOpen = !isOptionsMenuOpen}>
                    {#if isOptionsMenuOpen}
                        <span class="button-icon no-text"><RiArrowUpSLine /></span>
                    {:else}
                        <span class="button-icon no-text"><RiArrowDownSLine /></span>
                    {/if}
                </button>
            </div>
            {#if isOptionsMenuOpen}
                <div class="mt-2 rounded-xl overflow-hidden bg-zinc-300/50 dark:bg-zinc-600/50 backdrop-blur-sm" transition:slide>
                    <button class="card-button full top" id="send-message-button" title="Send a message to {data.username}">
                        <span class="button-icon"><RiSendPlaneLine /></span>
                        <span class="button-text">Send Message</span>
                    </button>
                    <button class="card-button full" id="report-user-button" title="Report {data.username}">
                        <span class="button-icon"><RiAlarmWarningLine /></span>
                        <span class="button-text">Report</span>
                    </button>
                </div>
            {/if}
            <div class="hidden md:block my-2"><!--spacer--></div>
            <div class="md:flex items-center text-sm hidden">
                <span class="mr-2 relative top-0.5"><RiCake2Line size="22px" /></span>
                <span>Joined {localeDate(data.createdAt, "mediumDate")}</span>
            </div>
            <div class="flex md:flex-col items-center md:items-baseline mt-4 md:mt-0">
                {#each data.links as link}
                    <!--SocialLinkBadge-->
                {/each}
            </div>

            <!--mobile profile nav-->
            <div class="md:hidden my-1"><!--spacer--></div>
            <div class="flex md:hidden items-center justify-center w-full">
                <a class="nav-link-mobile" class:active={$page.url.pathname === `/profile/${data.id}/${slugify(data.username)}`} href="/profile/{data.id}/{slugify(data.username)}">
                    <span>Home</span>
                </a>
                <a class="nav-link-mobile" class:active={$page.url.pathname.includes("/works")} href="/profile/{data.id}/{slugify(data.username)}/works">
                    <span>Works</span>
                </a>
                <a class="nav-link-mobile" class:active={$page.url.pathname.includes("/blogs")} href="/profile/{data.id}/{slugify(data.username)}/blogs">
                    <span>Blogs</span>
                </a>
                <a class="nav-link-mobile" class:active={$page.url.pathname.includes("/shelves")} href="/profile/{data.id}/{slugify(data.username)}/shelves">
                    <span>Shelves</span>
                </a>
            </div>
        </div>
        <div class="my-6 col-span-3">
            <div class="hidden md:flex items-center justify-center w-full md:pb-2 mb-4 border-b border-zinc-300/50 dark:border-zinc-600/50">
                <a class="nav-link" class:active={$page.url.pathname === `/profile/${data.id}/${slugify(data.username)}`} href="/profile/{data.id}/{slugify(data.username)}">
                    <span class="nav-link-icon"><RiHome6Line size="20px" /></span>
                    <span>Home</span>
                </a>
                <a class="nav-link" class:active={$page.url.pathname.includes("/works")} href="/profile/{data.id}/{slugify(data.username)}/works">
                    <span class="nav-link-icon"><BookCopy size="20" /></span>
                    <span>0 Works</span>
                </a>
                <a class="nav-link" class:active={$page.url.pathname.includes("/blogs")} href="/profile/{data.id}/{slugify(data.username)}/blogs">
                    <span class="nav-link-icon"><RiCupLine size="20px" /></span>
                    <span>0 Blogs</span>
                </a>
                <a class="nav-link" class:active={$page.url.pathname.includes("/shelves")} href="/profile/{data.id}/{slugify(data.username)}/shelves">
                    <span class="nav-link-icon"><LibrarySquare size="20" /></span>
                    <span>Shelves</span>
                </a>
            </div>
            <div class="w-11/12 mx-auto md:w-full">
                <slot />
            </div>
        </div>
    </div>
</div>

<style lang="scss">
    a.nav-link {
        @apply flex items-center justify-center px-6 py-3 mx-1 rounded-xl all-small-caps text-lg font-bold tracking-wide transition;
    }

    a.nav-link.active, a.nav-link:hover {
        @apply bg-zinc-300/50 dark:bg-zinc-700/50;
    }

    a.nav-link > span.nav-link-icon {
        @apply relative mr-2;
    }

    a.nav-link-mobile {
        @apply w-1/4 text-center py-2 mx-0.5 all-small-caps text-lg font-bold tracking-wide border-b-2 border-transparent;
    }

    a.nav-link-mobile.active {
        @apply border-zinc-700 dark:border-zinc-300;
    }

    button.card-button {
        @apply flex items-center py-2 px-3.5 all-small-caps font-bold text-lg tracking-wide first:border-r border-zinc-400 dark:border-zinc-500 transition;
    }

    button.card-button:hover {
        @apply bg-zinc-400/50 dark:bg-zinc-500/25;
    }

    button.card-button.big {
        @apply w-5/6 justify-center;
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
