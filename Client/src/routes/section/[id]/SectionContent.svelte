<script lang="ts">
	import type { SectionView } from "$lib/models/content/works";
	import { computePosition, inline, type ReferenceElement } from "@floating-ui/dom";
	import { ArrowDownSLine, ArrowUpSLine } from 'svelte-remixicon';
	import { slide } from 'svelte/transition';

	export let content: SectionView;
	export let containerHeight = 0;

	let annotationOptions: HTMLDivElement;
	let sectionContainer: HTMLDivElement;
	let noteTopOpen = false;

	$: containerHeight = sectionContainer?.scrollHeight;

	function selectChanged(e: MouseEvent) {
		const selection = window.getSelection();
		const range = selection?.getRangeAt(0);
		const virtualEl: ReferenceElement = {
			getBoundingClientRect: () => range!.getBoundingClientRect(),
			getClientRects: () => range!.getClientRects()
		};
		computePosition(virtualEl, annotationOptions, { middleware: [inline()] });
		console.log("computed");
	}
</script>

<div class="section-container" bind:this={sectionContainer}>
	<div class="mb-16">
		<h1 class="text-4xl text-center">{content.section.title}</h1>
		{#if content.section.noteTop}
			<div class="flex flex-col items-center italic w-11/12 max-w-lg mx-auto">
				{#if noteTopOpen}
					<div class="flex flex-col pt-4 w-full" transition:slide={{ delay: 0, duration: 150 }}>
						<div class="authors-note italic text-justify">
							{@html content.section.noteTop}
						</div>
						<span class="w-full my-4 text-right">—A word from the author</span>
					</div>
				{/if}
				<button class="section-button" on:click={() => noteTopOpen = !noteTopOpen}>
					{#if noteTopOpen}
						<ArrowUpSLine size="24px" />
					{:else}
						<ArrowDownSLine size="24px" />
					{/if}
				</button>
			</div>
		{/if}
	</div>
	<div id="section-body" class="section-body">
		<!--<div class="absolute" bind:this={annotationOptions}>hi hello how are you</div>-->
		{@html content.section.body}
	</div>
	{#if content.section.noteBottom}
		<div class="section-authors-note">
			<div class="flex items-center">
				<h3 class="text-2xl">From the author—</h3>
			</div>
			<div class="authors-note">
				{@html content.section.noteBottom}
			</div>
		</div>
	{/if}
</div>
