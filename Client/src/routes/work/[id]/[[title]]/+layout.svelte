<script lang="ts">
    import { type FetchWorkPage, Kind } from "$lib/models/content/works";
	import { TagKind } from "$lib/models/tags";
    import { Dropdown } from "$lib/ui/dropdown";
	import { Button, InfoBar } from "$lib/ui/util";
    import { slugify, abbreviate } from "$lib/util/functions";
	import { Icon } from "svelte-remix";
    import { page } from "$app/stores";
    import { account } from "$lib/state/account.state";

    export let data: FetchWorkPage;

    const firstGenre = data.work.tags.filter(tag => tag.kind === TagKind.genre)[0];
    const fandoms = data.work.tags.filter(tag => tag.kind === TagKind.fandom);
    const firstFandom = fandoms.length > 0 ? fandoms[0].name : data.work.category.toString();

    let sectionsName = "Sections";
    switch (data.work.kind) {
        case Kind.Prose:
            sectionsName = "Chapters";
            break;
        case Kind.Poetry:
            sectionsName = "Poems";
            break;
        case Kind.Nonfiction:
            sectionsName = "Sections";
            break;
        case Kind.Script:
            sectionsName = "Parts";
            break;
        case Kind.Anthology:
            sectionsName = "Entries";
            break;
    }
</script>

<svelte:head>
	<title>{data.work.title} &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content={data.work.title} />
	<meta name="description" content={data.work.shortDesc} />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="book" />
	<meta
		property="og:url"
		content="https://offprint.net/work/{data.work.id}/{slugify(data.work.title)}"
	/>
	<meta property="og:title" content={data.work.title} />
	<meta
		property="book:author"
		content="https://offprint.net/profile/{data.work.author.id}/{slugify(
			data.work.author.username
		)}"
	/>
	<meta property="og:description" content={data.work.shortDesc} />
	<meta property="og:image" content={data.work.coverArt ?? data.work.author.avatar} />
	<meta property="og:site_name" content="Offprint" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary" />
	<meta property="twitter:site" content="offprint" />
	<meta
		property="twitter:url"
		content="https://offprint.net/work/{data.work.id}/{slugify(data.work.title)}"
	/>
	<meta property="twitter:title" content={data.work.title} />
	<meta property="twitter:description" content={data.work.shortDesc} />
	<meta property="twitter:image" content={data.work.coverArt ?? data.work.author.avatar} />
</svelte:head>

<div class="relative w-full h-[300px]" style="background: var(--accent-dark);">
    {#if data.work.bannerArt}
        <img class="w-full h-full object-cover" src={data.work.bannerArt} alt="Banner Art" />
    {/if}
    <div class="absolute top-4 w-full">
        <div class="flex items-center w-full px-4">
            <div class="flex-1"><!--spacer--></div>
            <Button kind="primary">
                <Icon name="add-line" class="button-icon" />
                <span class="button-text">Library</span>
            </Button>
            <div class="mx-0.5"><!--spacer--></div>
            <Dropdown kind="primary">
                <svelte:fragment slot="button">
                    <Icon name="more-fill" width="24px" height="24px" class="button-icon no-text" />
                </svelte:fragment>
                <svelte:fragment slot="items">
                    <button>
                        <Icon name="bar-chart-fill" class="mr-2" />
                        <span>Add to Shelf</span>
                    </button>
                    <button>
                        <Icon name="share-box-line" class="mr-2" />
                        <span>Share This</span>
                    </button>
                    <div class="divider"><!--spacer--></div>
                    <button>
                        <Icon name="alarm-warning-line" class="mr-2" />
                        <span>Report</span>
                    </button>
                </svelte:fragment>
            </Dropdown>
        </div>
    </div>
</div>

<div class="mx-auto max-w-4xl w-11/12">
    <div class="flex items-end h-[75px]">
        <div
			class="relative overflow-hidden w-max flex flex-col items-center justify-center bg-zinc-300 dark:bg-zinc-600 border-4 border-zinc-300 dark:border-zinc-600 rounded-xl z-[2]"
			style="box-shadow: var(--dropshadow);"
		>
            <img
                src={data.work.coverArt}
                alt="cover art"
                class="max-w-[160px] max-h-[256px] lg:max-w-[200px] lg:max-h-[320px]"
            />
        </div>
        <div class="flex-1"><!--spacer--></div>
        <div class="flex items-center bg-zinc-200 dark:bg-zinc-700 rounded-xl p-1">
            <Button>
                <Icon name="thumb-up-line" width="18px" height="18px" class="button-icon text-green-600" />
                <span class="button-small-text text-green-600">{abbreviate(data.work.likes)}</span>
            </Button>
            <div class="mx-0.5"><!--spacer--></div>
            <Button>
                <Icon name="thumb-down-line" width="18px" height="18px" class="button-icon text-red-600" />
                <span class="button-small-text text-red-600">{abbreviate(data.work.dislikes)}</span>
            </Button>
        </div>
    </div>
    <div class="flex flex-col w-full pt-6 mb-6 border-b border-zinc-200 dark:border-zinc-700">
        <div class="flex items-center text-xs lg:text-sm uppercase font-bold tracking-wide">
            <span>{firstFandom}</span>
            <span class="relative mx-1 -top-[0.075rem]">•</span>
            <span>{firstGenre.name}</span>
        </div>
        <div>
            <h1 class="text-3xl lg:text-4xl">{data.work.title}</h1>
        </div>
        <div class="text-lg lg:text-2xl text-zinc-400 dark:text-zinc-500" style="font-family: var(--header-text);">
            <span>by <a class="text-zinc-400 dark:text-zinc-500" href="/profile/{data.work.author.id}/{slugify(data.work.author.username)}">{data.work.author.username}</a></span>
        </div>
        <div class="flex items-center text-sm text-zinc-400 dark:text-zinc-500">
            <span class="flex items-center" title="Views">
                <Icon name="line-chart-line" width="20px" height="20px" class="mr-1" />
                <span>{abbreviate(data.work.views)}</span>
            </span>
            <span class="relative mx-1">•</span>
            <span class="flex items-center" title="Words">
                <Icon name="pen-nib-line" width="20px" height="20px" class="mr-1" />
                <span>{abbreviate(data.work.words)}</span>
            </span>
        </div>
        {#if !data.work.publishedOn}
            <InfoBar
			    message="<b>This work is a draft.</b> No views will be counted when navigating to
                                this page, and all social features (such as comments and likes/dislikes) are disabled."
		    />
        {/if}
        {#if $account.currProfile?.id !== data.work.author.id && data.work.publishedOn}
            <a class="go-read start-reading" href="/section/{data.tableOfContents[0].id}">
                <Icon name="book-open-line" width="18px" height="18px" class="mr-2" />
                <span class="uppercase text-xs tracking-wide font-bold relative top-[0.075rem]">Start Reading</span>
            </a>
        {/if}
        <div class="flex items-center lg:justify-center">
            <a 
                class="work-tab-button w-1/3 lg:w-auto" 
                class:active={$page.url.pathname === `/work/${data.work.id}/${slugify(data.work.title)}`}
                href="/work/{data.work.id}/{slugify(data.work.title)}"
            >
                Details
            </a>
            <a 
                class="work-tab-button w-1/3 lg:w-auto" 
                class:active={$page.url.pathname.includes(`/sections`)}
                href="/work/{data.work.id}/{slugify(data.work.title)}/sections"
            >
                {sectionsName}
            </a>
            <a 
                class="work-tab-button w-1/3 lg:w-auto" 
                class:active={$page.url.pathname.includes(`/reviews`)}
                href="/work/{data.work.id}/{slugify(data.work.title)}/reviews"
            >
                Reviews
            </a>
        </div>
    </div>
</div>

<div class="mx-auto w-11/12 max-w-4xl">
    <slot />
</div>

<style lang="scss">
    a.go-read {
        @apply flex items-center justify-center p-3 my-6 rounded-xl max-w-lg w-full mx-auto transition text-white no-underline;
        &.start-reading {
            @apply bg-green-600;
            &:hover {
                @apply bg-green-700
            }
        }
        &.continue-reading {
            @apply bg-blue-600;
            &:hover {
                @apply bg-blue-700;
            }
        }
    }
    a.work-tab-button {
        @apply px-4 py-3 text-center no-underline border-b-4 border-transparent uppercase text-sm tracking-wide font-bold;
        color: var(--text-color);
        &.active {
            @apply border-zinc-700;
        }
        &:hover {
            @apply border-zinc-700;
        }
    }

    :global(.dark a.work-tab-button) {
        &.active {
            @apply border-white;
        }
        &:hover {
            @apply border-white;
        }
    }
</style>