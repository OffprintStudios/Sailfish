<script lang="ts">
	import { onMount } from 'svelte';
	import { section } from '$lib/state/section.state';
	import { Justification, ParagraphStyle, Theme, WidthSettings } from '$lib/util/constants/sections';
	import type { SectionPage } from '$lib/models/content/works';
	import SectionContent from './SectionContent.svelte';
	import SectionTools from './SectionTools.svelte';
	import SectionBottomNav from './SectionBottomNav.svelte';
	import SectionMeta from './SectionMeta.svelte';

	export let data: SectionPage;
	const iconSize = "22px";
	let scrollY = 0;
	let sectionContainerHeight = 0;
	let showToC = false;

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
	});
</script>

<svelte:window bind:scrollY />

<div id="section-page" class="section-page paper">
	<SectionTools
		sectionView={data.section}
		tableOfContents={data.tableOfContents}
		containerHeight={sectionContainerHeight}
		{iconSize}
		{scrollY}
	/>
	<SectionContent content={data.section} bind:containerHeight={sectionContainerHeight} />
	<SectionBottomNav
		cheers={data.section.section.cheers}
		comments={data.section.section.comments}
		{iconSize}
	/>
	<SectionMeta sectionView={data.section} />
</div>
