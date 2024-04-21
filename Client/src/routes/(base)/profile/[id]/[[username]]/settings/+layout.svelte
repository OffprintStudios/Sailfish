<script lang="ts">
	import { RiArrowRightSLine, RiGroup2Line, RiIdCardLine } from "svelte-remixicon";
	import type { PageData } from "./$types";
	import { slugify } from "$lib/util/functions";
	import { BellDot, BookType } from "lucide-svelte";
    import { page } from "$app/stores";

    export let data: PageData;
</script>

<div class="bg-zinc-200/50 dark:bg-zinc-700/50 backdrop-blur md:rounded-xl border-y md:border border-zinc-600/25 dark:border-zinc-300/25 overflow-hidden my-6" style="box-shadow: var(--dropshadow);">
    <div class="p-4 md:border-b border-zinc-600/50 dark:border-zinc-300/50">
        <h1 class="text-3xl">Settings</h1>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-4 h-full">
        <div class="flex md:flex-col overflow-x-scroll col-span-1 h-full md:bg-zinc-300/25 md:dark:bg-zinc-600/25 backdrop-blur-sm border-b md:border-b-0 md:border-r border-zinc-600/25 dark:border-zinc-300/25">
            <a class="settings-nav" class:active={$page.url.pathname === `/profile/${data.id}/${slugify(data.username)}/settings`} href="/profile/{data.id}/{slugify(data.username)}/settings">
                <RiIdCardLine size="24px" />
                <span class="nav-name">Info</span>
                <span class="hidden md:block"><RiArrowRightSLine /></span>
            </a>
            <a class="settings-nav" class:active={$page.url.pathname.includes("/publishing")} href="/profile/{data.id}/{slugify(data.username)}/settings/publishing">
                <BookType size="24" />
                <span class="nav-name">Publishing</span>
                <span class="hidden md:block"><RiArrowRightSLine /></span>
            </a>
            <a class="settings-nav" class:active={$page.url.pathname.includes("/notifications")} href="/profile/{data.id}/{slugify(data.username)}/settings/notifications">
                <BellDot size="24" />
                <span class="nav-name">Notifications</span>
                <span class="hidden md:block"><RiArrowRightSLine /></span>
            </a>
            <a class="settings-nav" class:active={$page.url.pathname.includes("/social")} href="/profile/{data.id}/{slugify(data.username)}/settings/social">
                <RiGroup2Line size="24px" />
                <span class="nav-name">Social</span>
                <span class="hidden md:block"><RiArrowRightSLine /></span>
            </a>
        </div>
        <div class="col-span-3 p-4">
            <slot />
        </div>
    </div>
</div>

<style lang="scss">
    a.settings-nav {
        @apply w-full px-4 md:px-2 py-3 flex items-center md:text-lg transition;
        font-family: var(--header-text);

        & > span.nav-name {
            @apply flex-1 relative top-0.5 ml-2;
        }

        &.active {
            @apply text-white;
            background: rgb(var(--accent));
        }

        &:hover {
            @apply text-white;
            background: rgba(var(--accent), 0.5);
        }
    }
</style>
