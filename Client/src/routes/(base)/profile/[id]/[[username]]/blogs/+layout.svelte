<script lang="ts">
    import type { PageData } from "./$types";
    import { slugify } from "$lib/util/functions";
    import { Button } from "$lib/ui/util";
    import { auth } from "$lib/state/auth.state";
	import { RiAddLine, RiArrowLeftSLine, RiFilter2Line, RiSearchEyeLine } from "svelte-remixicon";
	import LinkBlock from "$lib/ui/util/LinkBlock.svelte";
	import { page } from "$app/stores";

    export let data: PageData;
</script>

<svelte:head>
	<title>{data.username}'s Blogs &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{data.username}'s Blogs" />
	<meta name="description" content={data.bio ?? "Just another face in the crowd"} />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="profile" />
	<meta property="profile:username" content={data.username} />
	<meta
		property="og:url"
		content="https://offprint.cafe/profile/{data.id}/{slugify(data.username)}/blogs"
	/>
	<meta property="og:title" content="{data.username}'s Blogs" />
	<meta property="og:description" content={data.bio ?? "Just another face in the crowd"} />
	<meta property="og:image" content={data.avatar} />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary" />
	<meta
		property="twitter:url"
		content="https://offprint.cafe/profile/{data.id}/{slugify(data.username)}/blogs"
	/>
	<meta property="twitter:title" content="{data.username}'s Blogs" />
	<meta property="twitter:description" content={data.bio ?? "Just another name in the crowd"} />
	<meta property="twitter:image" content={data.avatar} />
</svelte:head>

<div class="flex items-center h-[58px] bg-zinc-200/50 p-2 dark:bg-zinc-700/50 backdrop-blur-lg rounded-b-xl border border-zinc-600/25 dark:border-zinc-300/25" style="box-shadow: var(--dropshadow);">
    {#if $page.url.pathname === `/profile/${data.id}/${slugify(data.username)}/blogs`}
        <div class="flex items-center rounded-xl overflow-hidden max-w-[255px] h-[40px] bg-zinc-200 dark:bg-zinc-700">
            <input
                id="blog-search"
                title="Search Blogs"
                type="text"
                placeholder="Search..."
                class="bg-zinc-300/25 dark:bg-zinc-600/25 backdrop-blur-lg border-0 focus:ring-0 w-full h-full"
            />
            <button class="h-full px-3 bg-zinc-300/25 dark:bg-zinc-600/25 backdrop-blur-lg hover:bg-zinc-300 dark:hover:bg-zinc-600 transition">
                <span class="relative"><RiSearchEyeLine size="20px" /></span>
            </button>
        </div>
        <div class="flex-1"><!--spacer--></div>
        <Button id="filter-button" title="Filter">
            <span class="button-icon"><RiFilter2Line /></span>
            <span class="button-text">Filter</span>
        </Button>
        {#if $auth.currProfile && $auth.currProfile.id === data.id}
            <div class="mx-0.5"><!--spacer--></div>
            <LinkBlock
                id="add-blog-button"
                title="Add Blog"
                kind="primary"
                href="/profile/{data.id}/{slugify(data.username)}/blogs/new"
            >
                <span class="link-icon"><RiAddLine /></span>
                <span class="link-text">Add</span>
            </LinkBlock>
        {/if}
    {:else}
        <div class="flex items-center">
            <LinkBlock id="back-button" title="Go Back" href="/profile/{data.id}/{slugify(data.username)}/blogs">
                <span class="link-icon"><RiArrowLeftSLine /></span>
                <span class="link-text">Back</span>
            </LinkBlock>
            <div class="flex-1"><!--spacer--></div>
        </div>
    {/if}
</div>

<slot />
