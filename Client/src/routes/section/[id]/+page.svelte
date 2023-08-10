<script lang="ts">
	import { onMount } from 'svelte';
	import { section } from '$lib/state/section.state';
	import { Justification, ParagraphStyle, Theme, WidthSettings } from '$lib/util/constants/sections';
	import type { SectionPage } from '$lib/models/content/works';
	import SectionContent from './SectionContent.svelte';
	import SectionTools from './SectionTools.svelte';
	import SectionBottomNav from './SectionBottomNav.svelte';
	import SectionMeta from './SectionMeta.svelte';
	import { patchReq, type ResponseError } from '$lib/http';
	import type { ReadingHistory } from '$lib/models/content/library';
	import { account } from '$lib/state/account.state';
	import toast from 'svelte-french-toast';
	import { slugify } from '$lib/util/functions';
	import { afterNavigate } from '$app/navigation';

	export let data: SectionPage;
	const iconSize = "22px";
	let scrollY = 0;
	let sectionContainerHeight = 0;
	let sectionPage: HTMLDivElement;

	onMount(async () => {
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

		if($account.currProfile) {
			await markAsRead();
		}
	});

	afterNavigate(() => {
		const sectionPage = document.getElementById("section-page");
		if (sectionPage) {
			sectionPage.scrollIntoView({ behavior: "instant", block: "start", inline: "nearest" });
		}
	});

	async function markAsRead() {
		const response = await patchReq<ReadingHistory>(
			`/history/set-as-read?workId=${data.section.work.id}&sectionId=${data.section.id}&profileId=${$account.currProfile?.id}`,
			{}
		);
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			data.readingHistory = response as ReadingHistory;
		}
	}

	function onPageScroll() {
		console.log(sectionPage.scrollTop);
		scrollY = sectionPage.scrollTop;
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

<div id="section-page" class="section-page paper" on:scroll={onPageScroll} bind:this={sectionPage}>
	<SectionTools
		sectionView={data.section}
		tableOfContents={data.tableOfContents}
		readingHistory={data.readingHistory}
		containerHeight={sectionContainerHeight}
		cheer={data.cheer}
		{iconSize}
		bind:scrollY
	/>
	<SectionContent content={data.section} bind:containerHeight={sectionContainerHeight} />
	<SectionBottomNav
		authorId={data.section.author.id}
		sectionId={data.section.id}
		tableOfContents={data.tableOfContents}
		cheers={data.section.section.cheers}
		cheer={data.cheer}
		comments={data.section.section.comments}
		{iconSize}
	/>
	<SectionMeta
		readingHistory={data.readingHistory}
		sectionView={data.section}
		topComments={data.topComments}
		libraryItem={data.libraryItem}
	/>
</div>
