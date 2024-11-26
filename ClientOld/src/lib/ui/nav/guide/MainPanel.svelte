<script lang="ts">
    import { IconFeather, IconCoffee, IconEyeHeart, IconBookUpload, IconLink, IconUsersGroup, IconArrowsDoubleNeSw, IconAdjustments, IconLogout2, IconChevronRight } from "@tabler/icons-svelte";
    import { auth } from "$lib/state/auth.state";
    import { slugify } from "$lib/util/functions";
	import { createEventDispatcher } from "svelte";

    const dispatch = createEventDispatcher();
</script>

<div class="flex flex-col w-full overflow-hidden rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25">
    <div class="h-[75px] overflow-hidden w-full relative bg-accent">
        {#if $auth.currProfile?.bannerArt}
            <img src={$auth.currProfile?.bannerArt} class="h-full w-full object-cover" alt="profile avatar" />
        {/if}
    </div>
    <div class="w-full flex items-center p-2">
        <div class="mr-2 w-[60px] h-[60px] overflow-hidden rounded-full border-2 border-white">
            <img src={$auth.currProfile?.avatar} class="w-full h-full object-cover" alt="avatar" />
        </div>
        <div class="flex flex-1 flex-col">
            <h1 class="max-w-[270px] truncate text-2xl">
                <a class="hover:underline" href="/profile/{$auth.currProfile?.id}/{slugify($auth.currProfile?.username)}">
                    {$auth.currProfile?.username}
                </a>
            </h1>
            <!--TODO: add role badges-->
        </div>
    </div>
    <div class="all-small-caps flex w-full border-t border-zinc-400 text-lg font-bold dark:border-zinc-500 font-header">
        <a
            class="flex h-[65px] w-1/3 flex-col text-default hover:text-default hover:no-underline items-center justify-center pt-0.5 transition hover:bg-zinc-300 hover:dark:bg-zinc-600"
            href="/profile/{$auth.currProfile?.id}/{slugify($auth.currProfile?.username)}/works"
        >
            <div class="flex items-center relative top-2">
                <span class="relative -top-1"><IconFeather size="18px" /></span>
                <span class="relative -top-1 ml-1 text-xl">0</span>
            </div>
            <span class="relative -top-1">Works</span>
        </a>
        <a
            class="flex h-[65px] w-1/3 flex-col items-center justify-center text-default hover:text-default hover:no-underline border-l border-r border-zinc-400 pt-0.5 transition hover:bg-zinc-300 dark:border-zinc-500 hover:dark:bg-zinc-600"
            href="/profile/{$auth.currProfile?.id}/{slugify($auth.currProfile?.username)}/blogs"
        >
            <div class="flex items-center relative top-2">
                <span class="relative -top-1"><IconCoffee size="18px" /></span>
                <span class="relative -top-1 ml-1 text-xl">0</span>
            </div>
            <span class="relative -top-1.5">Blogs</span>
        </a>
        <a
            class="flex h-[65px] w-1/3 flex-col items-center justify-center text-default hover:text-default hover:no-underline pt-0.5 transition hover:bg-zinc-300 hover:dark:bg-zinc-600"
            href="/profile/{$auth.currProfile?.id}/{slugify($auth.currProfile?.username)}/followers"
        >
            <div class="flex items-center relative top-2">
                <span class="relative -top-1"><IconEyeHeart size="18px" /></span>
                <span class="relative -top-1 ml-1 text-xl">0</span>
            </div>
            <span class="relative -top-1.5">Follows</span>
        </a>
    </div>
</div>
<div class="my-2" />
<div
    class="flex w-full flex-col overflow-hidden rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25"
>
    <a
        class="flex items-center border-b border-zinc-400 text-default hover:text-default hover:no-underline px-4 py-3 transition hover:bg-zinc-300/75 dark:border-zinc-500 dark:hover:bg-zinc-600/75"
        href="/profile/{$auth.currProfile?.id}/{slugify($auth.currProfile?.username)}/works/new"
    >
        <span class="relative mr-2">
            <IconBookUpload size="24px" />
        </span>
        <span class="flex-1 relative top-0.5">Create a New Work</span>
        <span class="relative text-zinc-400 dark:text-zinc-500">
            <IconLink size="20px" />
        </span>
    </a>
    <a
        class="flex items-center text-default hover:text-default hover:no-underline px-4 py-3 transition hover:bg-zinc-300/75 dark:hover:bg-zinc-600/75"
        href="/profile/{$auth.currProfile?.id}/{slugify($auth.currProfile?.username)}/blogs/new"
    >
        <span class="relative mr-2">
            <IconCoffee size="24px" />
        </span>
        <span class="flex-1 relative top-0.5">Create a New Blog</span>
        <span class="relative text-zinc-400 dark:text-zinc-500">
            <IconLink size="20px" />
        </span>
    </a>
</div>
<div class="my-2" />
<div
    class="flex w-full flex-col overflow-hidden rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25"
>
    <a
        class="flex items-center px-4 py-3 text-default hover:text-default hover:no-underline transition hover:bg-zinc-300/75 dark:hover:bg-zinc-600/75"
        href="/switch-profile"
    >
        <span class="relative mr-2">
            <IconUsersGroup size="24px" />
        </span>
        <span class="flex-1 relative top-0.5">Switch Profile</span>
        <span class="relative text-zinc-400 dark:text-zinc-500">
            <IconArrowsDoubleNeSw size="20px" />
        </span>
    </a>
</div>
<div class="my-2" />
<div
    class="flex w-full flex-col overflow-hidden rounded-xl bg-zinc-400/25 dark:bg-zinc-500/25"
>
    <a
        class="flex items-center px-4 py-3 transition text-default hover:text-default hover:no-underline hover:bg-zinc-300/75 dark:hover:bg-zinc-600/75 border-b border-zinc-400 dark:border-zinc-500"
        href="/settings"
    >
        <span class="relative mr-2">
            <IconAdjustments size="24px" />
        </span>
        <span class="flex-1 relative top-0.5">Settings</span>
        <span class="relative text-zinc-400 dark:text-zinc-500">
            <IconLink size="20px" />
        </span>
    </a>
    <button
        class="flex items-center px-4 py-3 transition hover:bg-zinc-300/75 dark:hover:bg-zinc-600/75"
        on:click={() => dispatch('logout')}
    >
        <span class="relative mr-2">
            <IconLogout2 size="24px" />
        </span>
        <span class="flex-1 text-left relative top-0.5">Log Out</span>
        <span class="relative text-zinc-400 dark:text-zinc-500">
            <IconChevronRight width="20px" height="20px" />
        </span>
    </button>
</div>