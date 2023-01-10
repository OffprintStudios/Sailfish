<script lang="ts">
	import type { Paginate } from "$lib/util/types";
	import type { Work } from "$lib/models/content/works";
	import type { ResponseError } from "$lib/http";
	import type { Tag } from "$lib/models/tags";
	import { page } from "$app/stores";
	import { getReq } from "$lib/http";
	import { WorkCard } from "$lib/ui/content";
	import { Paginator } from "$lib/ui/util";
	import toast from "svelte-french-toast";
	import { TagKind } from "$lib/models/tags";
	import { abbreviate } from "$lib/util/functions";
	import {
		AliensLine,
		DoorClosedLine,
		EmotionLaughLine,
		FilePaper2Line,
		Ghost2Line,
		HeartsLine,
		Home3Line,
		MagicLine,
		MeteorLine,
		SearchEyeLine,
		SkullLine,
		SpyLine,
		SwordLine
	} from "svelte-remixicon";

	export let data: { tag: Tag; works: number; page: Paginate<Work> };
	$: pageNum = +($page.url.searchParams.get("page") ?? "1");
	$: perPage = +($page.url.searchParams.get("per") ?? "24");
	let loading = false;
	const iconSize = "42px";

	async function fetchPage(newPage: number) {
		loading = true;
		$page.url.searchParams.set("page", `${newPage}`);
		const response = await getReq<Paginate<Work>>(
			`/explore/works-by-tag?tagId=${$page.params.id}&page=${newPage}&per=${perPage}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			data.page = response as Paginate<Work>;
		}
		loading = false;
	}
</script>

<svelte:head>
	<title>{data.tag.name} &mdash; Offprint</title>
</svelte:head>

<div class="tag-header">
	{#if data.tag.kind === TagKind.genre}
		{#if data.tag.name === "Comedy"}
			<EmotionLaughLine size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Drama"}
			<FilePaper2Line size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Erotica"}
			<DoorClosedLine size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Fantasy"}
			<MagicLine size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Horror"}
			<Ghost2Line size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Mystery"}
			<SearchEyeLine size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Romance"}
			<HeartsLine size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Science Fiction"}
			<AliensLine size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Slice of Life"}
			<Home3Line size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Speculative Fiction"}
			<MeteorLine size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Thriller"}
			<SpyLine size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Tragedy"}
			<SkullLine size={iconSize} class="ml-2 mr-4" />
		{:else if data.tag.name === "Action/Adventure"}
			<SwordLine size={iconSize} class="ml-2 mr-4" />
		{/if}
	{/if}
	<div class="flex-1">
		<h1 class="text-white text-4xl relative top-1">{data.tag.name}</h1>
		{#if data.tag.parent}
			<h3 class="text-white italic">{data.tag.parent.name}</h3>
		{/if}
	</div>
	<div
		class="flex items-end text-white relative top-0.5"
		style="font-family: var(--header-text);"
	>
		<h2 class="text-4xl text-white mr-1">{abbreviate(data.works)}</h2>
		<span class="uppercase tracking-wider relative bottom-1">works</span>
	</div>
</div>

{#if data.page.metadata.total > 0}
	<div class="grid grid-cols-1 lg:grid-cols-3 gap-4 max-w-6xl mx-auto">
		{#each data.page.items as work}
			<WorkCard {work} withDropdown={false} />
		{/each}
	</div>
{:else}
	<div class="empty">
		<h3>Strangely, there's nothing here.</h3>
		<p>Just watch out for the tumbleweeds.</p>
	</div>
{/if}

{#if data.page.metadata.total > 0}
	<Paginator
		{pageNum}
		{perPage}
		totalItems={data.page.metadata.total}
		on:change={(event) => fetchPage(event.detail)}
	/>
{/if}

<style lang="scss">
	div.tag-header {
		@apply max-w-7xl mx-auto text-white my-6 flex items-center rounded-xl px-4 py-6;
		background: var(--accent);
	}
</style>
