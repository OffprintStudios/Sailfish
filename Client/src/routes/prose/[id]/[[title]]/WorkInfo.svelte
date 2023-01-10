<script lang="ts">
	import { fly } from "svelte/transition";
	import { ArrowDownSLine, ArrowUpSLine } from "svelte-remixicon";
	import type { Work } from "$lib/models/content/works";
	import { Button } from "$lib/ui/util";

	export let work: Work;

	let showDesc = true;
</script>

<div class="w-full">
	<div class="w-full flex items-center pb-1">
		<h3 class="text-2xl flex-1">Description</h3>
		<Button on:click={() => showDesc = !showDesc}>
			{#if showDesc}
				<ArrowUpSLine class="button-icon no-text" />
			{:else}
				<ArrowDownSLine class="button-icon no-text" />
			{/if}
		</Button>
	</div>
	{#if showDesc}
		<div class="html-description" transition:fly|local={{ delay: 0, duration: 150, y: -25 }}>
			{@html work.longDesc}
		</div>
	{/if}
</div>
