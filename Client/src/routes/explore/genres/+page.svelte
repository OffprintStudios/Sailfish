<script lang="ts">
	import type { Tag } from "$lib/models/tags";
	import { TagCard } from "$lib/ui/content";
	import {
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
		SwordLine
	} from "svelte-remixicon";

	export let data: { data: { tag: Tag; works: number }[] };

	const iconSize = "42px";
</script>

<svelte:head>
	<title>Genres &mdash; Offprint</title>
</svelte:head>

{#if data.data.length === 0}
	<div class="empty">
		<h3>No genres added</h3>
		<p>Contact site staff to get them off their butts and fix this.</p>
	</div>
{:else}
	<div class="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-4">
		{#each data.data as item}
			<TagCard tag={item.tag} works={item.works}>
				<svelte:fragment slot="icon">
					{#if item.tag.name === "Comedy"}
						<EmotionLaughLine size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Drama"}
						<FilePaper2Line size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Erotica"}
						<DoorClosedLine size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Fantasy"}
						<MagicLine size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Horror"}
						<Ghost2Line size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Mystery"}
						<SearchEyeLine size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Romance"}
						<HeartsLine size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Science Fiction"}
						<AliensLine size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Slice of Life"}
						<Home3Line size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Speculative Fiction"}
						<MeteorLine size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Thriller"}
						<SpyLine size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Tragedy"}
						<SkullLine size={iconSize} class="ml-2 mr-4" />
					{:else if item.tag.name === "Action/Adventure"}
						<SwordLine size={iconSize} class="ml-2 mr-4" />
					{/if}
				</svelte:fragment>
			</TagCard>
		{/each}
	</div>
{/if}
