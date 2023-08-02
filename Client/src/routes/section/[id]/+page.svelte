<script lang="ts">
	import {
		ArrowRightSLine,
		ArrowLeftSLine,
		ListUnordered,
		StickyNoteLine,
		DiscussLine,
		BookmarkLine,
		OpenArmLine,
		ThumbUpLine,
		ThumbDownLine
	} from "svelte-remixicon";
	import FormattingDropdown from "./FormattingDropdown.svelte";
	import { onMount } from "svelte";
	import { section } from "$lib/state/section.state";
	import { ParagraphStyle, Theme, WidthSettings } from "$lib/util/constants/sections";
	import { Guide } from "$lib/ui/user/guide";
	import { account } from "$lib/state/account.state";
	import AccountDropdown from "$lib/ui/user/AccountDropdown.svelte";
	import type { SectionPage } from "$lib/models/content/works";
	import { abbreviate, slugify } from "$lib/util/functions";
	import { LinkTag } from "$lib/ui/content";
	import SvelteMarkdown from "svelte-markdown";
	import Avatar from "$lib/ui/util/Avatar.svelte";

	export let data: SectionPage;
	const iconSize = "22px";
	let scrollY = 0;
	let sectionContainer: HTMLDivElement;
	let sectionContainerHeight = 0;

	onMount(() => {
		const themeColor = document.querySelector("meta[name='theme-color']")!;
		themeColor.setAttribute("content", "rgb(247, 241, 228)");

		/* theme */
		const sectionPage = document.getElementById("section-page")!;
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

		const themeColorValue =
			getComputedStyle(sectionPage).getPropertyValue("--section-background");
		themeColor.setAttribute("content", themeColorValue);

		getSectionHeight();
	});

	function getSectionHeight() {
		sectionContainerHeight = sectionContainer.scrollHeight + 100;
	}
</script>

<svelte:window bind:scrollY />

<div id="section-page" class="section-page paper">
	<div
		class="section-tools pinned"
		class:in-content={scrollY < sectionContainerHeight}
		class:out-of-content={scrollY >= sectionContainerHeight}
	>
		<div class="flex items-center w-1/3">
			<button class="section-button">
				<ArrowLeftSLine class="lg:mr-1" size={iconSize} />
				<span class="hidden lg:block">Back</span>
			</button>
			<div class="hidden lg:block mx-0.5"><!--spacer--></div>
			<button class="section-button no-text hide-this" title="Table of Contents">
				<ListUnordered size={iconSize} />
			</button>
			{#if $account.account && $account.currProfile}
				<button
					class="section-button no-text hide-this"
					title="Notes & Highlights"
					style="margin-right: 0.25rem;"
				>
					<StickyNoteLine size={iconSize} />
				</button>
			{/if}
			<FormattingDropdown {iconSize} on:change={getSectionHeight} />
		</div>
		<div
			class="w-1/3 flex flex-col items-center justify-center"
			style="color: var(--section-tool-header-color); font-family: var(--header-text);"
		>
			<span
				class="font-bold text-base relative top-1 truncate max-w-[194px] lg:max-w-[250px]"
			>
				{data.section.work.title}
			</span>
			<span class="text-[0.75rem] relative -top-0.5 hidden lg:block truncate max-w-[250px]">
				{data.section.section.title}
			</span>
		</div>
		<div class="w-1/3 flex items-center justify-end">
			<button class="section-button hide-this" title="Cheers">
				<OpenArmLine size={iconSize} class="mr-1" />
				<span class="text-xs" style="top: 0.03rem;">
					{abbreviate(data.section.section.cheers)}
				</span>
			</button>
			<button class="section-button hide-this" title="Comments">
				<DiscussLine size={iconSize} class="mr-1" />
				<span class="text-xs" style="top: 0.03rem;">
					{abbreviate(data.section.section.comments)}
				</span>
			</button>
			{#if $account.account && $account.currProfile}
				<button class="section-button no-text" title="Bookmark Chapter">
					<BookmarkLine size={iconSize} />
				</button>
			{/if}
			{#if $account.account}
				<div class="hidden lg:block">
					<Guide mode="section" />
				</div>
				<div class="lg:hidden">
					<AccountDropdown mode="section" />
				</div>
			{/if}
		</div>
	</div>
	<div bind:this={sectionContainer}>
		<div class="section-container">
			<h1 class="text-4xl mb-16 text-center">{data.section.section.title}</h1>
			<div class="section-body">
				{@html data.section.section.body}
			</div>
			{#if data.section.section.noteBottom}
				<div class="section-authors-note">
					<div class="flex items-center">
						<h3 class="text-2xl">From the author—</h3>
					</div>
					<div class="authors-note">
						{@html data.section.section.noteBottom}
					</div>
				</div>
			{/if}
		</div>
		<div class="section-nav">
			<button class="section-button">
				<ArrowLeftSLine class="lg:mr-1" size={iconSize} />
				<span class="hidden lg:block">Prev</span>
			</button>
			<div class="mx-2"><!--spacer--></div>
			<button class="section-button" title="Cheers">
				<OpenArmLine size={iconSize} class="mr-1" />
				<span class="text-xs" style="top: 0.03rem;">
					{abbreviate(data.section.section.cheers)}
				</span>
			</button>
			<button class="section-button" title="Comments">
				<DiscussLine size={iconSize} class="mr-1" />
				<span class="text-xs" style="top: 0.03rem;">
					{abbreviate(data.section.section.comments)}
				</span>
			</button>
			<div class="mx-2"><!--spacer--></div>
			<button class="section-button">
				<span class="hidden lg:block">Next</span>
				<ArrowRightSLine class="lg:ml-1" size={iconSize} />
			</button>
		</div>
	</div>
	<div class="section-meta">
		<div
			class="flex flex-col lg:flex-row items-center max-w-3xl mx-auto w-11/12 border-b-4 border-dotted border-zinc-700 p-4 pb-8"
		>
			{#if data.section.work.coverArt}
				<div class="bg-zinc-700 p-1 rounded-xl mr-4">
					<img
						src={data.section.work.coverArt}
						alt="cover art"
						class="max-w-[150px] max-h-[110px] lg:max-w-[250px] lg:max-h-[210px]"
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
							href="/profile/{data.section.author.id}/{slugify(
								data.section.author.name
							)}"
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
					<div class="flex items-center">
						<button class="meta-button thumbs-up">
							<ThumbUpLine class="mr-2" />
							<span class="text-xs">1.2k</span>
						</button>
						<div class="mx-0.5"><!--spacer--></div>
						<button class="meta-button thumbs-down">
							<ThumbDownLine class="mr-2" />
							<span class="text-xs">20</span>
						</button>
					</div>
				</div>
				<div
					class="py-2 w-full font-normal hidden lg:block"
					style="font-family: var(--body-text);"
				>
					{data.section.work.desc}
				</div>
			</div>
		</div>
		<div
			class="flex flex-col items-center justify-center max-w-[400px] mx-auto w-11/12 px-4 py-2 mt-4 w-full rounded-xl font-normal"
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
	</div>
</div>

<style lang="scss">
	:global(div.markdown-text) {
		:global(p) {
			@apply text-white;
			margin: 0.5rem 0 0.5rem 0 !important;
			text-align: center !important;
		}
	}
</style>
