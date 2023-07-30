<script lang="ts">
	import {
		ArrowLeftSLine,
		ListUnordered,
		StickyNoteLine,
		DiscussLine,
		BookmarkLine,
		ShareBoxLine,
		OpenArmLine
	} from "svelte-remixicon";
	import FormattingDropdown from "./FormattingDropdown.svelte";
	import { onMount } from "svelte";
	import { section } from "$lib/state/section.state";
	import { Theme } from "$lib/util/constants/sections";

	const iconSize = "22px";

	onMount(() => {
		const themeColor = document.querySelector("meta[name='theme-color']");
		themeColor.setAttribute("content", "rgb(247, 241, 228)");
		const sectionPage = document.getElementById("section-page");
		sectionPage.classList.remove(
			Theme.white,
			Theme.paper,
			Theme.slate,
			Theme.dimmed,
			Theme.ink
		);
		sectionPage.classList.add($section.theme);
		sectionPage.style.setProperty("--section-font-family", $section.font as string);
		const themeColorValue =
			getComputedStyle(sectionPage).getPropertyValue("--section-background");
		themeColor.setAttribute("content", themeColorValue);
	});
</script>

<div id="section-page" class="section-page paper">
	<div class="section-tools">
		<div class="flex items-center w-1/3">
			<button class="section-button">
				<ArrowLeftSLine class="mr-1" size={iconSize} />
				<span class="hidden lg:block">Back</span>
			</button>
			<div class="hidden lg:block mx-0.5"><!--spacer--></div>
			<button class="section-button no-text hide-this" title="Table of Contents">
				<ListUnordered size={iconSize} />
			</button>
			<button class="section-button no-text hide-this" title="Notes & Highlights">
				<StickyNoteLine size={iconSize} />
			</button>
			<FormattingDropdown {iconSize} />
		</div>
		<div
			class="w-1/3 flex flex-col items-center justify-center"
			style="color: var(--section-tool-header-color); font-family: var(--header-text);"
		>
			<span class="font-bold text-base relative top-1 truncate max-w-[194px]"
				>A Work Unlike Any Other</span
			>
			<span class="text-[0.75rem] relative -top-0.5 hidden lg:block truncate"
				>II: The Start Of Something New</span
			>
		</div>
		<div class="w-1/3 flex items-center justify-end">
			<button class="section-button hide-this" title="Cheers">
				<OpenArmLine size={iconSize} class="mr-1" />
				<span class="text-xs" style="top: 0.03rem;">4.87</span>
				<span>k</span>
			</button>
			<button class="section-button hide-this" title="Comments">
				<DiscussLine size={iconSize} class="mr-1" />
				<span class="text-xs" style="top: 0.03rem;">1.23</span>
				<span>k</span>
			</button>
			<button class="section-button no-text" title="Bookmark Chapter">
				<BookmarkLine size={iconSize} />
			</button>
			<button class="section-button no-text hide-this" title="Share This">
				<ShareBoxLine size={iconSize} />
			</button>
		</div>
	</div>
	<div class="section-container">
		<h1 class="text-4xl mb-8 text-center">II: The Start Of Something New</h1>
		<slot />
	</div>
</div>
<div class="section-comments" />
