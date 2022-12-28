<script lang="ts">
	import type { Tag } from "$lib/models/tags";
	import { TagCard } from "$lib/ui/content";

	export let data: { data: { tag: Tag; works: number }[] };
</script>

<svelte:head>
	<title>Fandoms &mdash; Offprint</title>
</svelte:head>

{#if data.data.length === 0}
	<div class="empty">
		<h3>No fandoms added</h3>
		<p>Contact site staff to get them off their butts and fix this.</p>
	</div>
{:else}
	<div class="grid grid-cols-1 lg:grid-cols-5 gap-4">
		{#each data.data as item}
			<TagCard tag={item.tag} works={item.works} />
		{/each}
	</div>
{/if}
