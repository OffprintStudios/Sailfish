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
		SwordLine,
		Contrast2Fill,
		EmotionSadLine
	} from "svelte-remixicon";
	import { app } from "$lib/state/app.state";

	export let data: { tag: Tag; works: number; page: Paginate<Work> };
	let pageNum = +($page.url.searchParams.get("page") ?? "1");
	let perPage = +($page.url.searchParams.get("per") ?? "24");
	let loading = false;

	async function fetchPage(newPage: number) {
		loading = true;
		pageNum = newPage;
		const response = await getReq<Paginate<Work>>(
			`/explore/works-by-tag?tagId=${$page.params.id}&filter=${$app.filter}&page=${newPage}&per=${perPage}`
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
			<EmotionLaughLine class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Drama"}
			<FilePaper2Line class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Erotica"}
			<DoorClosedLine class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Fantasy"}
			<MagicLine class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Horror"}
			<Ghost2Line class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Mystery"}
			<SearchEyeLine class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Romance"}
			<HeartsLine class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Science Fiction"}
			<AliensLine class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Slice of Life"}
			<Home3Line class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Speculative Fiction"}
			<MeteorLine class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Thriller"}
			<SpyLine class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Tragedy"}
			<SkullLine class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Action/Adventure"}
			<SwordLine class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Dark"}
			<Contrast2Fill class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{:else if data.tag.name === "Sad"}
			<EmotionSadLine class="w-[36px] h-[36px] lg:w-[42px] lg:h-[42px] ml-2 mr-4" />
		{/if}
	{/if}
	<div class="flex-1">
		<h1 class="text-white text-2xl lg:text-4xl relative top-1">{data.tag.name}</h1>
		{#if data.tag.parent}
			<h3 class="text-white italic">{data.tag.parent.name}</h3>
		{/if}
	</div>
	<div
		class="flex items-end text-white relative top-0.5"
		style="font-family: var(--header-text);"
	>
		<h2 class="text-2xl lg:text-4xl text-white mr-1">{abbreviate(data.works)}</h2>
		<span class="uppercase tracking-wider relative bottom-1 text-xs lg:text-sm">works</span>
	</div>
</div>

{#if data.page.metadata.total > 0}
	<div
		class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4 max-w-6xl w-11/12 xl:w-full mx-auto"
	>
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
		currPage={pageNum}
		{perPage}
		totalItems={data.page.metadata.total}
		on:change={(event) => fetchPage(event.detail)}
	/>
{/if}

<style lang="scss">
	div.tag-header {
		@apply max-w-7xl mx-auto text-white mb-6 xl:mt-6 flex items-center xl:w-11/12 xl:rounded-xl px-4 py-6;
		background: var(--accent);
	}
</style>
