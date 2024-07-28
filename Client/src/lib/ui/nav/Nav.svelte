<script lang="ts">
    import SearchBar from "./SearchBar.svelte";
    import { IconSearch, IconLogin2, IconBooks, IconMailbox } from "@tabler/icons-svelte";
    import { auth } from "$lib/state/auth.state";
	import Guide from "./guide/Guide.svelte";
    import { page } from "$app/stores";
</script>

<div
    class="sticky top-0 w-full z-50 drop-shadow-2xl border-b border-white border-opacity-25 backdrop-blur-lg bg-accent shadow-small-shadow"
>
    <nav class="flex items-center max-w-[90rem] h-[65px] w-full md:w-11/12 pl-4 pr-2 md:px-0 mx-auto relative">
        <div class="flex items-center w-1/3 text-white">
            <a href="/"><h3 class="text-2xl font-bold tracking-tighter text-white">Offprint</h3></a>
            <a
                class="hidden md:block relative top-0.5 text-white hover:text-white ml-4 all-small-caps text-lg firefox:text-base border-b-2 border-transparent hover:border-zinc-300/75 [&[aria-current=page]]:border-zinc-300/75 transition font-semibold font-header"
                href="/explore"
                aria-current={$page.url.pathname.startsWith('/explore') ? 'page' : undefined}
            >
                Explore
            </a>
            <a
                class="hidden md:block relative top-0.5 text-white hover:text-white ml-4 all-small-caps text-lg firefox:text-base border-b-2 border-transparent hover:border-zinc-300/75 [&[aria-current=page]]:border-zinc-300/75 transition font-semibold font-header"
                href="/social"
                aria-current={$page.url.pathname.startsWith('/social') ? 'page' : undefined}
            >
                Social
            </a>
        </div>
        <div class="w-1/3">
            <SearchBar />
        </div>
        <div class="w-1/3 flex items-center relative" style="font-family: var(--header-text);">
            <div class="flex-1"></div>
            {#if $auth.currProfile}
                <a
                    class="flex items-center text-white px-3 py-2 firefox:text-sm rounded-xl transition hover:bg-zinc-300/25 hover:backdrop-blur"
                    href="/library"
                >
                    <span class="relative"><IconBooks size="24px" /></span>
                </a>
                <a
                    class="flex items-center text-white px-3 py-2 firefox:text-sm rounded-xl transition hover:bg-zinc-300/25 hover:backdrop-blur"
                    href="/inbox"
                >
                    <span class="relative"><IconMailbox size="24px" /></span>
                </a>
                <Guide />
            {:else}
                <a
                    class="flex lg:hidden items-center text-white px-3 py-2 firefox:text-sm rounded-xl transition hover:bg-zinc-300/25 hover:backdrop-blur"
                    href="/search"
                >
                    <span class="relative"><IconSearch size="20px" /></span>
                </a>
                <div class="mx-0.5"></div>
                <a
                    class="flex items-center text-white px-3 py-2 firefox:text-sm rounded-xl transition hover:bg-zinc-300/25 hover:backdrop-blur"
                    href="/log-in"
                >
                    <span class="relative"><IconLogin2 size="20px" /></span>
                    <span class="hidden md:block all-small-caps font-bold tracking-wider ml-1.5">Log In</span>
                </a>
            {/if}
        </div>
    </nav>
</div>