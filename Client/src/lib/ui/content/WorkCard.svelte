<script lang="ts">
	import TagBadge from "./TagBadge.svelte";
	import { TagKind } from "$lib/models/tags";
	import type { Work } from "$lib/models/content/works";
	import { abbreviate, slugify } from "$lib/util/functions";
	import { account } from "$lib/state/account.state";
	import { Dropdown } from "../dropdown";
	import { Time } from "../util";
	import {
		Calendar2Line,
		LineChartLine,
		MoreFill,
		PenNibLine,
		ThumbUpLine,
		ThumbDownLine,
		ThumbUpFill,
		ThumbDownFill
	} from "svelte-remixicon";
	import { openPopup } from "$lib/ui/popup";
	import { AllTagsPrompt } from "$lib/ui/content/index";

	export let work: Work;
	export let withDropdown = true;
	const fandoms = work.tags.filter((value) => value.kind === TagKind.fandom);

	function openAllTags() {
		openPopup(AllTagsPrompt, null, { tags: work.tags });
	}
</script>

<div
	class="work-card bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed hover:bg-zinc-300 dark:hover:bg-zinc-600"
	title={work.title}
>
	<a
		class="absolute top-0 right-0 left-0 bottom-0 z-[2]"
		href="/work/{work.id}/{slugify(work.title)}"
		data-sveltekit-preload-data
	>
		<!--should be empty-->
	</a>
	<div class="card-header w-full">
		{#if work.coverArt}
			<div class="cover-art">
				<img
					src={work.coverArt}
					class="bg-zinc-300 dark:bg-zinc-600 border-4 border-zinc-300 dark:border-zinc-600 object-contain rounded-xl max-w-[6rem] max-h-[6rem]"
					style="box-shadow: var(--dropshadow);"
					alt="cover-art"
				/>
			</div>
		{:else}
			<div class="cover-art"><!--empty when nothing's here--></div>
		{/if}
		<div class="banner">
			{#if work.bannerArt}
				<img src={work.bannerArt} alt="cover art" class="w-full h-full object-cover" />
			{/if}
			<div class="absolute flex items-center top-1 px-1.5 w-full">
				{#if withDropdown && $account.account && $account.currProfile}
					<Dropdown kind={work.bannerArt ? "normal" : "primary"}>
						<svelte:fragment slot="button">
							<MoreFill size="18px" class="button-icon no-text" />
						</svelte:fragment>
						<svelte:fragment slot="items">
							<slot name="dropdown" />
						</svelte:fragment>
					</Dropdown>
				{/if}
				<div class="flex-1"><!--spacer--></div>
				<TagBadge category={work.category} kind={TagKind.category} size="small" />
				<div class="mx-[0.025rem]"><!--spacer--></div>
				<TagBadge kind={TagKind.workKind} workKind={work.kind} size="small" />
				<div class="mx-[0.075rem]" />
				<TagBadge kind={TagKind.status} size="small" status={work.status} />
				<div class="mx-[0.025rem]"><!--spacer--></div>
				<TagBadge kind={TagKind.rating} rating={work.rating} size="small" />
			</div>
		</div>
		<div class="title-bar overflow-hidden">
			<h3 class="font-medium text-lg truncate max-w-full" style="color: var(--text-color);">
				{work.title}
			</h3>
			<div class="flex items-center text-zinc-400" style="font-family: var(--header-text);">
				<span class="mr-1">by</span>
				<a
					class="text-zinc-400 hover:text-zinc-400 relative z-[2]"
					href="/profile/{work.author.id}/{slugify(work.author.username)}"
					>{work.author.username}</a
				>
			</div>
		</div>
	</div>
	<div class="flex items-center flex-wrap px-2">
		{#each work.tags.filter((item) => item.kind === TagKind.genre) as tag}
			<TagBadge {tag} kind={tag.kind} size="small" />
			<div class="mx-[0.05rem] last:mx-0"><!--spacer--></div>
		{/each}
		{#each fandoms as tag, i}
			{#if i === 0}
				<TagBadge {tag} kind={tag.kind} size="small" />
				{#if fandoms.length > 1}
					<button
						class="relative z-[2] text-sm top-1 lg:top-0.5 ml-2 text-zinc-400"
						style="font-family: var(--header-text);"
						on:click={openAllTags}
					>
						+ {fandoms.length - 1} more
					</button>
				{/if}
			{/if}
		{/each}
	</div>
	<div class="text-xs px-4 mt-4 mb-4">
		{@html work.shortDesc}
	</div>
	<div class="flex-1"><!--spacer--></div>
	<div
		class="flex items-center text-zinc-400 lg:text-sm text-xs px-2 py-1"
		style="font-family: var(--header-text);"
	>
		<span class="flex items-center relative z-[2] text-green-600" title="Likes">
			{#if work.likes > work.dislikes}
				<ThumbUpFill class="mr-1" size="16px" />
			{:else}
				<ThumbUpLine class="mr-1" size="16px" />
			{/if}
			<span class="relative">{abbreviate(work.likes)}</span>
		</span>
		<span class="mx-2">/</span>
		<span class="flex items-center relative z-[2] text-red-500" title="Dislikes">
			{#if work.dislikes > work.likes}
				<ThumbDownFill class="mr-1" size="16px" />
			{:else}
				<ThumbDownLine class="mr-1" size="16px" />
			{/if}
			<span class="relative">{abbreviate(work.dislikes)}</span>
		</span>
		<span class="flex-1"><!--spacer--></span>
		<span class="flex items-center relative z-[2]" title="Views">
			<LineChartLine class="mr-1" size="16px" />
			<span class="relative">{abbreviate(work.views)}</span>
		</span>
		<span class="mx-2">/</span>
		<span class="flex items-center relative z-[2]" title="Words">
			<PenNibLine class="mr-1" size="16px" />
			<span class="relative">{abbreviate(work.words)}</span>
		</span>
		<span class="mx-2">/</span>
		{#if work.publishedOn}
			<span class="flex items-center relative z-[2]" title="Published On">
				<Calendar2Line class="mr-1" size="16px" />
				<span class="relative"><Time timestamp={work.publishedOn} format="M-D-YY" /></span>
			</span>
		{:else}
			<span class="flex items-center relative z-[2]" title="Created On">
				<Calendar2Line class="mr-1" size="16px" />
				<span class="relative"><Time timestamp={work.createdAt} format="M-D-YY" /></span>
			</span>
		{/if}
	</div>
</div>

<style lang="scss">
	div.work-card {
		@apply flex flex-col rounded-xl overflow-hidden no-underline transition relative;
		div.card-header {
			@apply grid rounded-xl relative max-w-full;
			grid-template-areas:
				"a b"
				"c d";
			grid-template-rows: 1fr auto;
			grid-template-columns: auto 1fr;

			div.cover-art {
				grid-area: a / c / c / c;
				display: flex;
				align-items: flex-end;
				@apply p-2 relative z-[1];
			}

			div.banner {
				@apply relative h-[120px];
				background: var(--accent);
				grid-area: a / a / b / b;
			}

			div.title-bar {
				grid-area: d;
				@apply p-2 pl-0 relative max-w-full;
			}
		}
	}
</style>
