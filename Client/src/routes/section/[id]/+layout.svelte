<script lang="ts">
	import { abbreviate, slugify } from '$lib/util/functions';
	import type { SectionPage } from '$lib/models/content/works';
	import { afterNavigate, beforeNavigate, goto } from '$app/navigation';
	import { account } from '$lib/state/account.state';
	import toast from 'svelte-french-toast';
	import { patchReq, postReq, type ResponseError } from '$lib/http';
	import type { ReadingHistory } from '$lib/models/content/library';
	import type { Cheer } from '$lib/models/content/works';
	import {
		ArrowLeftSLine,
		BookmarkFill,
		BookmarkLine,
		DiscussLine,
		Loader5Line,
		OpenArmFill,
		OpenArmLine
	} from 'svelte-remixicon';
	import { fade } from 'svelte/transition';
	import FormattingDropdown from './FormattingDropdown.svelte';
	import TableOfContents from './TableOfContents.svelte';
	import type { BeforeNavigate } from '@sveltejs/kit';
	import { onMount } from 'svelte';
	import { Justification, ParagraphStyle, Theme, WidthSettings } from '$lib/util/constants/sections';
	import { section } from '$lib/state/section.state';

	export let data: SectionPage;

	const iconSize = "22px";
	let toolsInMeta = false;
	let bookmarking = false;
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
					toolsInMeta = false;
					themeColor.setAttribute("content", themeColorValue);
				} else {
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

	function goToWork() {
		goto(`/work/${data.section.work.id}/${slugify(data.section.work.title)}`);
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

<div id="section-page" class="section-page paper">
	<div
		class="section-tools pinned"
		class:in-content={!toolsInMeta}
		class:out-of-content={toolsInMeta}
	>
		<div class="flex items-center w-1/3">
			<button class="section-button" on:click={goToWork}>
				<ArrowLeftSLine class="lg:mr-1" size={iconSize} />
				<span class="hidden lg:block">Back</span>
			</button>
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
		</div>
		<div
			class="w-1/3 flex flex-col items-center justify-center"
			style="color: var(--section-tool-header-color); font-family: var(--header-text);"
		>
		<span class="font-bold text-base relative top-1 truncate max-w-[138px] md:max-w-[194px] lg:max-w-[250px]">
			{data.section.work.title}
		</span>
			<span class="text-[0.75rem] relative -top-0.5 hidden lg:block truncate max-w-[250px]">
			{data.section.section.title}
		</span>
		</div>
		<div class="w-1/3 flex items-center justify-end">
			{#if toolsInMeta}
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
					<button class="section-button hide-this" title="Comments">
						<DiscussLine size={iconSize} class="mr-1" />
						<span class="text-xs" style="top: 0.03rem;">
						{abbreviate(data.section.section.comments)}
					</span>
					</button>
				</div>
			{/if}
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
		</div>
	</div>
	<slot />
</div>
