<script lang="ts">
	import type { SectionView } from "$lib/models/content/works";
	import { computePosition, inline, type ReferenceElement } from "@floating-ui/dom";

	export let content: SectionView;
	export let containerHeight = 0;

	let annotationOptions: HTMLDivElement;
	let sectionContainer: HTMLDivElement;

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
	<h1 class="text-4xl mb-16 text-center">{content.section.title}</h1>
	<!--<div class="absolute" bind:this={annotationOptions}>hi hello how are you</div>-->
	<div class="section-body">
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
