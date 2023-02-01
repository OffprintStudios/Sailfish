<script lang="ts">
	import { onMount } from "svelte";
	import {
		Book2Line,
		EmotionLaughLine,
		FilePaper2Line,
		DoorClosedLine,
		MagicLine,
		Ghost2Line,
		SearchEyeLine,
		HeartsLine,
		AliensLine,
		Home3Line,
		MeteorLine,
		SpyLine,
		SkullLine,
		SwordLine,
		EmpathizeLine,
		SignalTowerFill,
		Loader2Line
	} from "svelte-remixicon";
	import type { ResponseError } from "$lib/http";
	import type { TopTag } from "$lib/models/tags";
	import type { Paginate } from "$lib/util/types";
	import type { Work } from "$lib/models/content/works";
	import { getReq } from "$lib/http";
	import { TagKind } from "$lib/models/tags";
	import { TagCard, WorkCard } from "$lib/ui/content";
	import { app } from "$lib/state/app.state";
	import toast from "svelte-french-toast";

	let newWorks: Paginate<Work>;
	let updatedWorks: Paginate<Work>;
	let topGenres: TopTag[] = [];
	let topFandoms: TopTag[] = [];
	const iconSize = "42px";

	onMount(async () => {
		await loadNewWorks();
		await loadUpdatedWorks();
		await loadTopTags(TagKind.genre);
		await loadTopTags(TagKind.fandom);
	});

	async function loadNewWorks() {
		const response = await getReq<Paginate<Work>>(
			`/explore/new-works?filter=${$app.filter}&page=1&per=6`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			newWorks = response as Paginate<Work>;
		}
	}

	async function loadUpdatedWorks() {
		const response = await getReq<Paginate<Work>>(
			`/explore/updated-works?filter=${$app.filter}&page=1&per=6`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			updatedWorks = response as Paginate<Work>;
		}
	}

	async function loadTopTags(kind: TagKind) {
		console.log(kind);
		/*const response = await getReq<TopTag[]>(`/explore/top-tags?tagKind=${kind}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			if (kind === TagKind.genre) {
				topGenres = response as TopTag[];
			} else if (kind === TagKind.fandom) {
				topFandoms = response as TopTag[];
			}
		}*/
	}
</script>

<div class="section">
	<div class="section-header">
		<Loader2Line class="mr-2 w-[24px] h-[24px] lg:w-[36px] lg:h-[36px]" />
		<h3 class="text-xl lg:text-3xl relative top-0.5 lg:top-1">New</h3>
		<div class="flex-1"><!--spacer--></div>
		<a class="text-base lg:text-lg relative top-1" href="/explore/new-works">All New »</a>
	</div>
	{#if !newWorks}
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	{:else if newWorks?.items.length === 0}
		<div class="empty">
			<h3>Strangely, there's nothing here</h3>
			<p>Just watch out for the tumbleweeds.</p>
		</div>
	{:else}
		<div class="section-items grid-cols-1 lg:grid-cols-2 xl:grid-cols-3">
			{#each newWorks?.items as work}
				<WorkCard {work} withDropdown={false} />
			{/each}
		</div>
	{/if}
</div>

<div class="section">
	<div class="section-header">
		<SignalTowerFill class="mr-2 w-[24px] h-[24px] lg:w-[36px] lg:h-[36px]" />
		<h3 class="text-xl lg:text-3xl relative top-1">Updated</h3>
		<div class="flex-1"><!--spacer--></div>
		<a class="text-base lg:text-lg relative top-1" href="/explore/updated-works"
			>All Updated »</a
		>
	</div>
	{#if !updatedWorks}
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	{:else if updatedWorks?.items.length === 0}
		<div class="empty">
			<h3>Strangely, there's nothing here</h3>
			<p>Just watch out for the tumbleweeds.</p>
		</div>
	{:else}
		<div class="section-items grid-cols-1 lg:grid-cols-2 xl:grid-cols-3">
			{#each updatedWorks?.items as work}
				<WorkCard {work} withDropdown={false} />
			{/each}
		</div>
	{/if}
</div>

<!--<div class="section">
	<div class="section-header">
		<Book2Line class="mr-2 w-[24px] h-[24px] lg:w-[36px] lg:h-[36px]" />
		<h3 class="text-xl lg:text-3xl relative top-1">Top Genres</h3>
		<div class="flex-1"></div>
		<a class="text-base lg:text-lg relative top-1" href="/explore/genres">All Genres »</a>
	</div>
	{#if topGenres.length === 0}
		<div class="empty">
			<h3>No genres added</h3>
			<p>Contact site staff to get this fixed ASAP!</p>
		</div>
	{:else}
		<div class="section-items grid-cols-1 lg:grid-cols-3">
			{#each topGenres as genre}
				<TagCard tag={genre} works={genre.total}>
					<svelte:fragment slot="icon">
						{#if genre.name === "Comedy"}
							<EmotionLaughLine size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Drama"}
							<FilePaper2Line size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Erotica"}
							<DoorClosedLine size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Fantasy"}
							<MagicLine size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Horror"}
							<Ghost2Line size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Mystery"}
							<SearchEyeLine size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Romance"}
							<HeartsLine size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Science Fiction"}
							<AliensLine size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Slice of Life"}
							<Home3Line size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Speculative Fiction"}
							<MeteorLine size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Thriller"}
							<SpyLine size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Tragedy"}
							<SkullLine size={iconSize} class="ml-2 mr-4" />
						{:else if genre.name === "Action/Adventure"}
							<SwordLine size={iconSize} class="ml-2 mr-4" />
						{/if}
					</svelte:fragment>
				</TagCard>
			{/each}
		</div>
	{/if}
</div>-->

<!--<div class="section">
	<div class="section-header">
		<EmpathizeLine class="mr-2 w-[24px] h-[24px] lg:w-[36px] lg:h-[36px]" />
		<h3 class="text-xl lg:text-3xl relative top-1">Top Fandoms</h3>
		<div class="flex-1"></div>
		<a class="text-base lg:text-lg relative top-1" href="/explore/fandoms">All Fandoms »</a>
	</div>
	{#if topFandoms.length === 0}
		<div class="empty">
			<h3>No fandoms added</h3>
			<p>Contact site staff to get this fixed ASAP!</p>
		</div>
	{:else}
		<div class="section-items grid-cols-1 lg:grid-cols-3">
			{#each topFandoms as fandom}
				<TagCard tag={fandom} works={fandom.total} />
			{/each}
		</div>
	{/if}
</div>-->
<style lang="scss">
	div.section {
		@apply max-w-6xl w-11/12 xl:w-full mx-auto my-6 first:mt-0;
		div.section-header {
			@apply flex items-center border-b pb-2 mb-4;
			font-family: var(--header-text);
			color: var(--text-color);
			h3 {
				color: var(--text-color);
			}
		}
		div.section-items {
			@apply grid gap-4;
		}
	}
</style>
