<script lang="ts">
	import { abbreviate } from "$lib/util/functions";
	import type { SectionList, SectionView } from '$lib/models/content/works';
	import { fade } from "svelte/transition";
	import {
		ArrowLeftSLine,
		OpenArmLine,
		DiscussLine,
		BookmarkLine
	} from "svelte-remixicon";
	import { account } from '$lib/state/account.state';
	import TableOfContents from "./TableOfContents.svelte";
	import FormattingDropdown from "./FormattingDropdown.svelte";
	import toast from 'svelte-french-toast';

	export let tableOfContents: SectionList[];
	export let sectionView: SectionView;
	export let containerHeight: number;
	export let scrollY: number;
	export let iconSize = "22px";

	function bookmarkSection() {
		if (!$account.currProfile) {
			toast.error("You need to be logged in to use this feature!");
		}
	}
</script>

<div
	class="section-tools pinned"
	class:in-content={scrollY < containerHeight + 100}
	class:out-of-content={scrollY >= containerHeight + 100}
>
	<div class="flex items-center w-1/3">
		<button class="section-button">
			<ArrowLeftSLine class="lg:mr-1" size={iconSize} />
			<span class="hidden lg:block">Back</span>
		</button>
		<div class="hidden lg:block mx-0.5"><!--spacer--></div>
		<TableOfContents authorId={sectionView.author.id} sectionId={sectionView.id} sectionList={tableOfContents} {iconSize} />
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
			{sectionView.work.title}
		</span>
		<span class="text-[0.75rem] relative -top-0.5 hidden lg:block truncate max-w-[250px]">
			{sectionView.section.title}
		</span>
	</div>
	<div class="w-1/3 flex items-center justify-end">
		{#if scrollY >= containerHeight + 100}
			<div class="flex items-center mr-0.5" transition:fade={{ delay: 0, duration: 150 }}>
				<button class="section-button hide-this" title="Cheers">
					<OpenArmLine size={iconSize} class="mr-1" />
					<span class="text-xs" style="top: 0.03rem;">
						{abbreviate(sectionView.section.cheers)}
					</span>
				</button>
				<div class="mx-0.5"><!--spacer--></div>
				<button class="section-button hide-this" title="Comments">
					<DiscussLine size={iconSize} class="mr-1" />
					<span class="text-xs" style="top: 0.03rem;">
						{abbreviate(sectionView.section.comments)}
					</span>
				</button>
			</div>
		{/if}
		<FormattingDropdown {iconSize} />
		<div class="mx-0.5"><!--spacer--></div>
		<button class="section-button no-text" title="Bookmark Chapter" on:click={bookmarkSection}>
			<BookmarkLine size={iconSize} />
		</button>
	</div>
</div>
