<script lang="ts">
	import type { SectionView } from "$lib/models/content/works";
	import { slugify } from "$lib/util/functions";
	import { ThumbUpLine, ThumbDownLine } from "svelte-remixicon";
	import { Avatar } from "$lib/ui/util";
	import { LinkTag } from "$lib/ui/content";
	import SvelteMarkdown from "svelte-markdown";

	export let sectionView: SectionView;
</script>

<div class="section-meta">
	<div
		class="flex flex-col lg:flex-row items-center max-w-3xl mx-auto w-11/12 border-b-4 border-dotted border-zinc-700 p-4 pb-8"
	>
		{#if sectionView.work.coverArt}
			<div class="bg-zinc-700 p-1 rounded-xl lg:mr-4">
				<img
					src={sectionView.work.coverArt}
					alt="cover art"
					class="max-w-[150px] max-h-[110px] rounded-lg"
				/>
			</div>
		{/if}
		<div class="w-full" style="font-family: var(--header-text);">
			<h3 class="text-4xl text-center lg:text-left">{sectionView.work.title}</h3>
			<div class="flex flex-col lg:flex-row items-center w-full">
				<span class="text-lg text-zinc-500 flex-1">
					by
					<a
						class="text-zinc-500 hover:text-zinc-500"
						href="/profile/{sectionView.author.id}/{slugify(sectionView.author.name)}"
					>
						{sectionView.author.name}
					</a>
				</span>
				<div
					class="py-2 w-full font-normal lg:hidden"
					style="font-family: var(--body-text); text-align: center;"
				>
					{sectionView.work.desc}
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
				{sectionView.work.desc}
			</div>
		</div>
	</div>
	<div
		class="flex flex-col items-center justify-center max-w-[400px] mx-auto w-11/12 px-4 py-2 mt-4 rounded-xl font-normal"
		style="font-family: var(--body-text);"
	>
		<Avatar src={sectionView.author.avatar} size="125px" />
		<h4 class="mt-3 text-2xl">{sectionView.author.name}</h4>
		<div class="markdown-text">
			<SvelteMarkdown source={sectionView.author.info.bio} />
		</div>
		{#if Object.keys(sectionView.author.links).length !== 0}
			<div class="flex items-center flex-wrap">
				{#each Object.keys(sectionView.author.links) as key}
					<LinkTag kind={key} href={sectionView.author.links[key]} />
				{/each}
			</div>
		{/if}
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
