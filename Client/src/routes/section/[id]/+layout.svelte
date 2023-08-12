<script lang="ts">
	import { abbreviate, copyToClipboard, slugify, pluralize } from '$lib/util/functions';
	import type { SectionPage } from '$lib/models/content/works';
	import { afterNavigate, beforeNavigate, goto } from '$app/navigation';
	import { account } from '$lib/state/account.state';
	import toast from 'svelte-french-toast';
	import { delReq, patchReq, postReq, putReq, type ResponseError } from '$lib/http';
	import type { ReadingHistory } from '$lib/models/content/library';
	import type { Cheer } from '$lib/models/content/works';
	import {
		ArrowLeftSLine, ArrowRightSLine, Bookmark3Fill, Bookmark3Line,
		BookmarkFill,
		BookmarkLine,
		DiscussLine, LightbulbFlashLine,
		Loader5Line,
		OpenArmFill,
		OpenArmLine, ShareBoxLine
	} from 'svelte-remixicon';
	import { fade } from 'svelte/transition';
	import FormattingDropdown from './FormattingDropdown.svelte';
	import TableOfContents from './TableOfContents.svelte';
	import type { BeforeNavigate } from '@sveltejs/kit';
	import { onMount } from 'svelte';
	import { Justification, ParagraphStyle, Theme, WidthSettings } from '$lib/util/constants/sections';
	import { section } from '$lib/state/section.state';
	import { page } from '$app/stores';
	import SvelteMarkdown from 'svelte-markdown';
	import { Avatar } from '$lib/ui/util';
	import { NewComment } from '$lib/ui/comments';
	import { LinkTag } from '$lib/ui/content';

	export let data: SectionPage;

	const iconSize = "22px";
	let toolsInMeta = false;
	let bookmarking = false;
	let addingToLibrary = false;
	let cheering = false;

	onMount(() => {
		const themeColor = document.querySelector("meta[name='theme-color']")!;
		themeColor.setAttribute("content", "rgb(247, 241, 228)");

		/* theme */
		const sectionPage = document.getElementById("section-page")!;
		const sectionBody = document.getElementById("section-body");
		sectionPage.classList.remove(
			Theme.white,
			Theme.paper,
			Theme.slate,
			Theme.dimmed,
			Theme.ink
		);
		sectionPage.classList.add($section.theme);

		/* font family */
		sectionPage.style.setProperty("--section-font-family", $section.font as string);

		/* width */
		switch ($section.width) {
			case WidthSettings.Normal:
				sectionPage.style.setProperty("--section-width", WidthSettings.Normal);
				break;
			case WidthSettings.Narrow:
				sectionPage.style.setProperty("--section-width", WidthSettings.Narrow);
				break;
			case WidthSettings.Wide:
				sectionPage.style.setProperty("--section-width", WidthSettings.Wide);
				break;
		}

		/* font size */
		let size = 16;
		let lineHeight = 24;
		if ($section.fontSize < 1) {
			size = Math.floor(size * $section.fontSize + 2);
			lineHeight = Math.floor(lineHeight * $section.fontSize + 2);
		} else if ($section.fontSize > 1) {
			size = Math.floor(size * $section.fontSize - 2);
			lineHeight = Math.floor(lineHeight * $section.fontSize - 2);
		}
		sectionPage.style.setProperty("--section-font-size", `${size}px`);
		sectionPage.style.setProperty("--section-line-height", `${lineHeight}px`);

		/* paragraph style */
		switch ($section.paragraphs) {
			case ParagraphStyle.original:
				sectionPage.style.setProperty("--section-paragraph-margins", "1rem 0 1rem 0");
				sectionPage.style.setProperty("--section-paragraph-indent", "0");
				break;
			case ParagraphStyle.indented:
				sectionPage.style.setProperty("--section-paragraph-margins", "0");
				sectionPage.style.setProperty("--section-paragraph-indent", "2.5rem");
				break;
			case ParagraphStyle.doubleSpaced:
				sectionPage.style.setProperty("--section-paragraph-margins", "1rem 0 1rem 0");
				sectionPage.style.setProperty("--section-paragraph-indent", "0");
				break;
			case ParagraphStyle.both:
				sectionPage.style.setProperty("--section-paragraph-margins", "1rem 0 1rem 0");
				sectionPage.style.setProperty("--section-paragraph-indent", "2.5rem");
				break;
		}

		switch($section.justification) {
			case Justification.original:
				sectionBody?.classList.remove("justified");
				break;
			case Justification.justified:
				sectionBody?.classList.add("justified");
				break;
		}

		const themeColorValue =
			getComputedStyle(sectionPage).getPropertyValue("--section-background");
		themeColor.setAttribute("content", themeColorValue);

		const observer = new IntersectionObserver((entries) => {
			entries.forEach(entry => {
				if (!entry.isIntersecting) {
					console.log("is not intersecting");
					toolsInMeta = false;
					themeColor.setAttribute("content", themeColorValue);
				} else {
					console.log("is intersecting");
					toolsInMeta = true;
					const bgColor = getComputedStyle(document.documentElement).getPropertyValue("--background");
					themeColor.setAttribute("content", bgColor);
				}
			})
		}, {
			root: null,
			rootMargin: "0px 0px -92% 0px",
			threshold: 0,
		});
		observer.observe(document.getElementById("section-meta")!);
	});

	beforeNavigate((e: BeforeNavigate) => {
		if (!e.to?.url.pathname.startsWith("/section")) {
			const themeColor = document.querySelector("meta[name='theme-color']")!;
			const accentColor = getComputedStyle(document.documentElement).getPropertyValue(
				"--accent"
			);
			themeColor.setAttribute("content", accentColor);
		}
	});

	afterNavigate(() => {
		const sectionPage = document.getElementById("section-page");
		if (sectionPage) {
			sectionPage.scrollTo(0, 0);
		}
	});

	function goBack() {
		if ($page.url.pathname.includes("/comments")) {
			goto(`/section/${data.section.id}`);
		} else {
			goto(`/work/${data.section.work.id}/${slugify(data.section.work.title)}`);
		}
	}

	async function bookmarkSection() {
		if (!$account.currProfile) {
			toast.error("You need to be logged in and have a profile selected to use this feature.");
			return;
		}
		bookmarking = true;
		const response = await patchReq<ReadingHistory>(
			`/history/set-bookmark?workId=${data.section.work.id}&sectionId=${data.section.id}&profileId=${$account.currProfile?.id}`,
			{}
		);
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			data.readingHistory = response as ReadingHistory;
		}
		bookmarking = false;
	}

	async function toggleCheer() {
		if (!$account.currProfile) {
			toast.error("You need to be logged in and have a profile selected to use this feature.");
			return;
		}
		cheering = true;
		const response = await postReq<{ cheer?: Cheer }>(`/reading/toggle-cheer/${data.section.id}?profileId=${$account.currProfile?.id}`, {});
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			data.cheer = response as Cheer;
			if (data.cheer?.id) {
				data.section.section.cheers = data.section.section.cheers + 1;
			} else {
				data.section.section.cheers = data.section.section.cheers - 1;
			}
		}
		cheering = false;
	}

	async function setLibrary() {
		if (!$account.currProfile) {
			toast.error("You must be logged in and have a profile selected to use this feature.");
			return;
		}
		addingToLibrary = true;
		if (data.section.section.publishedOn === undefined) {
			toast.error(`This feature is disabled for unpublished works.`);
			addingToLibrary = false;
			return;
		}
		if ($account.account && $account.currProfile) {
			if ($account.currProfile.id === data.section.author.id) {
				toast.error(`You cannot add your own work to your library!`);
				addingToLibrary = false;
				return;
			}

			let response: { hasItem: boolean } | ResponseError;
			if (data.libraryItem?.hasItem) {
				response = await delReq<{ hasItem: boolean }>(
					`/library/remove-one?workId=${data.section.work.id}&profileId=${$account.currProfile.id}`
				);
			} else {
				response = await putReq<{ hasItem: boolean }>(
					`/library/add-one?workId=${data.section.work.id}&profileId=${$account.currProfile.id}`,
					{}
				);
			}

			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				data.libraryItem = response as { hasItem: boolean };
			}
		} else {
			toast.error(`You must be logged in to perform this action.`);
		}
		addingToLibrary = false;
	}
</script>

<svelte:head>
	<title>{data.section.work.title} &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content={data.section.work.title} />
	<meta name="description" content={data.section.work.desc} />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta
		property="og:url"
		content="https://offprint.net/work/{data.section.work.id}/{slugify(data.section.work.title)}"
	/>
	<meta property="og:title" content={data.section.work.title} />
	<meta property="og:description" content={data.section.work.desc} />
	<meta property="og:image" content={data.section.work.coverArt ?? data.section.author.avatar} />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta
		property="twitter:url"
		content="https://offprint.net/work/{data.section.work.id}/{slugify(data.section.work.title)}"
	/>
	<meta property="twitter:title" content={data.section.work.title} />
	<meta property="twitter:description" content={data.section.work.desc} />
	<meta property="twitter:image" content={data.section.work.coverArt ?? data.section.author.avatar} />
</svelte:head>

<div
	id="section-page"
	class="section-page paper"
	class:in-comments={$page.url.pathname.includes("/comments")}
>
	<div
		class="section-tools pinned"
		class:in-content={!toolsInMeta && !$page.url.pathname.includes("/comments")}
		class:out-of-content={toolsInMeta && !$page.url.pathname.includes("/comments")}
		class:comments-page={$page.url.pathname.includes("/comments")}
	>
		<div class="flex items-center w-1/3">
			<button class="section-button" on:click={goBack}>
				<ArrowLeftSLine class="lg:mr-1" size={iconSize} />
				<span class="hidden lg:block">Back</span>
			</button>
			{#if !$page.url.pathname.includes("/comments")}
				<div class="hidden lg:block mx-0.5"><!--spacer--></div>
				<TableOfContents
					authorId={data.section.author.id}
					sectionId={data.section.id}
					sectionList={data.tableOfContents}
					{iconSize}
				/>
				<!--{#if $account.account && $account.currProfile}
					<button
						class="section-button no-text hide-this"
						title="Notes & Highlights"
						style="margin-right: 0.25rem;"
					>
						<StickyNoteLine size={iconSize} />
					</button>
				{/if}-->
			{/if}
		</div>
		<div
			class="w-1/3 flex flex-col items-center justify-center"
			style="color: var(--section-tool-header-color); font-family: var(--header-text);"
		>
			{#if $page.url.pathname.includes("/comments")}
				<span class="font-bold text-base relative">
					{abbreviate(data.section.section.comments)} comment{pluralize(data.section.section.comments)}
				</span>
			{:else}
				<span class="font-bold text-base relative top-1 truncate max-w-[138px] md:max-w-[194px] lg:max-w-[250px]">
					<a
						style="color: var(--section-tool-color);"
						href="/work/{data.section.work.id}/{slugify(data.section.work.title)}"
					>
						{data.section.work.title}
					</a>
				</span>
				<span class="text-[0.75rem] relative -top-0.5 hidden lg:block truncate max-w-[250px]">
					{data.section.section.title}
				</span>
			{/if}
		</div>
		<div class="w-1/3 flex items-center justify-end">
			{#if toolsInMeta && !$page.url.pathname.includes("/comments")}
				<div class="flex items-center mr-0.5" transition:fade={{ delay: 0, duration: 150 }}>
					<button class="section-button hide-this" class:active={!!data.cheer} title="Cheers" on:click={toggleCheer}>
						{#if cheering}
							<Loader5Line size={iconSize} class="mr-1 animate-[spin_2s_linear_infinite]" />
							<span style="top: 0.03rem;">-</span>
						{:else}
							{#if data.cheer}
								<OpenArmFill size={iconSize} class="mr-1" />
							{:else}
								<OpenArmLine size={iconSize} class="mr-1" />
							{/if}
							<span class="text-xs" style="top: 0.03rem;">
							{abbreviate(data.section.section.cheers)}
						</span>
						{/if}
					</button>
					<div class="hidden lg:block mx-0.5"><!--spacer--></div>
					<button class="section-button hide-this" title="Comments" on:click={() => goto(`/section/${data.section.id}/comments`)}>
						<DiscussLine size={iconSize} class="mr-1" />
						<span class="text-xs" style="top: 0.03rem;">
						{abbreviate(data.section.section.comments)}
					</span>
					</button>
				</div>
			{/if}
			{#if !$page.url.pathname.includes("/comments")}
				<FormattingDropdown {iconSize} />
				<div class="hidden lg:block mx-0.5"><!--spacer--></div>
				<button class="section-button no-text" title="Bookmark Chapter" on:click={bookmarkSection}>
					{#if bookmarking}
						<Loader5Line size={iconSize} class="animate-[spin_2s_linear_infinite]" />
					{:else}
						{#if data.readingHistory?.bookmarked.id === data.section.id}
							<BookmarkFill size={iconSize} />
						{:else}
							<BookmarkLine size={iconSize} />
						{/if}
					{/if}
				</button>
			{/if}
		</div>
	</div>
	<slot />
	<div id="section-meta" class="section-meta" class:on-comments={$page.url.pathname.includes("/comments")}>
		{#if !$page.url.pathname.includes("/comments")}
			<div
				class="flex flex-col max-w-3xl mx-auto w-11/12 border-b-4 border-dotted border-zinc-200 dark:border-zinc-700 p-4 pb-8"
			>
				<div class="flex flex-col lg:flex-row items-center">
					{#if data.section.work.coverArt}
						<div class="bg-zinc-700 p-1 rounded-xl lg:mr-4">
							<img
								src={data.section.work.coverArt}
								alt="cover art"
								class="max-w-[150px] max-h-[110px] rounded-lg"
							/>
						</div>
					{/if}
					<div class="w-full" style="font-family: var(--header-text);">
						<h3 class="text-4xl text-center lg:text-left">{data.section.work.title}</h3>
						<div class="flex flex-col lg:flex-row items-center w-full">
					<span class="text-lg text-zinc-500 flex-1">
						by
						<a
							class="text-zinc-500 hover:text-zinc-500"
							href="/profile/{data.section.author.id}/{slugify(data.section.author.name)}"
						>
							{data.section.author.name}
						</a>
					</span>
							<div
								class="py-2 w-full font-normal lg:hidden"
								style="font-family: var(--body-text); text-align: center;"
							>
								{data.section.work.desc}
							</div>
						</div>
						<div
							class="py-2 w-full font-normal hidden lg:block"
							style="font-family: var(--body-text); color: var(--text-color);"
						>
							{data.section.work.desc}
						</div>
					</div>
				</div>
				<div class="flex items-center justify-center lg:justify-end pt-4 flex-wrap">
					<div class="flex items-center">
						<button class="meta-button with-text" on:click={setLibrary}>
							{#if addingToLibrary}
								<Loader5Line class="mr-2 animate-[spin_2s_linear_infinite]" />
								<span class="relative -top-0.5">Adding</span>
							{:else}
								{#if data.libraryItem?.hasItem}
									<Bookmark3Fill class="mr-2" />
									<span class="relative -top-0.5">Added</span>
								{:else}
									<Bookmark3Line class="mr-2" />
									<span class="relative -top-0.5">Library</span>
								{/if}
							{/if}
						</button>
						<div class="mx-0.5"><!--spacer--></div>
						<button class="meta-button with-text" on:click={() => copyToClipboard(`https://offprint.net/section/${data.section.id}`)}>
							<ShareBoxLine class="mr-2" />
							<span class="relative -top-0.5">Share</span>
						</button>
					</div>
				</div>
			</div>
			<div
				class="flex flex-col max-w-3xl mx-auto w-11/12 border-b-4 border-dotted border-zinc-200 dark:border-zinc-700 py-4 lg:p-8 cursor-pointer"
				on:click={() => goto(`/section/${data.section.id}/comments`)}
				on:keydown={() => goto(`/section/${data.section.id}/comments`)}
				on:keyup={() => goto(`/section/${data.section.id}/comments`)}
				on:keypress={() => goto(`/section/${data.section.id}/comments`)}
				role="button"
				tabindex="0"
			>
				<div class="flex items-center mb-4 pb-4 px-2 border-b border-zinc-200 dark:border-zinc-700">
					<h3 class="text-xl flex-1">Top Comments</h3>
					<ArrowRightSLine size="24px" />
				</div>
				{#if data.topComments.length === 0}
					<div class="flex flex-col items-center justify-center h-[200px] w-full">
						<LightbulbFlashLine size="62px" />
						<span class="all-small-caps font-bold tracking-wide text-base">Share Your Thoughts</span>
					</div>
				{:else}
					{#each data.topComments as comment}
						<NewComment {comment} collapsed={true} topComment={true} />
					{/each}
				{/if}
			</div>
			<div
				class="flex flex-col items-center justify-center max-w-[400px] mx-auto w-11/12 px-4 py-2 mt-4 rounded-xl font-normal"
				style="font-family: var(--body-text);"
			>
				<Avatar src={data.section.author.avatar} size="125px" />
				<h4 class="mt-3 text-2xl">{data.section.author.name}</h4>
				<div class="markdown-text">
					<SvelteMarkdown source={data.section.author.info.bio} />
				</div>
				{#if Object.keys(data.section.author.links).length !== 0}
					<div class="flex items-center flex-wrap">
						{#each Object.keys(data.section.author.links) as key}
							<LinkTag kind={key} href={data.section.author.links[key]} />
						{/each}
					</div>
				{/if}
			</div>
		{/if}
	</div>
</div>
