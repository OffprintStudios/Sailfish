<script lang="ts">
	import {
		computePosition,
		flip,
		offset,
		shift,
		arrow,
		type ShiftOptions
	} from "@floating-ui/dom";
	import type { SectionList } from "$lib/models/content/works";
	import { throttle, clickOutside } from "$lib/util/functions";
	import { navigating } from "$app/stores";
	import { ListUnordered } from "svelte-remixicon";
	import { fade } from "svelte/transition";

	export let sectionList: SectionList[];
	export let open = false;
	export let iconSize = "22px";

	let button: HTMLButtonElement;
	let dropdown: HTMLDivElement;
	let arrowEl: HTMLDivElement;

	const published = sectionList.filter((section) => section.publishedOn !== undefined);

	function determineState() {
		open = !open;
	}

	const throttled = throttle(determineState, 150);

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: "bottom",
				middleware: [
					offset({ mainAxis: 8 }),
					flip(),
					shift({ padding: 12 } as ShiftOptions),
					arrow({ element: arrowEl })
				]
			})
				.then(({ x, y, placement, middlewareData }) => {
					Object.assign(dropdown.style, {
						left: `${x}px`,
						top: `${y}px`
					});

					const { x: arrowX, y: arrowY } = middlewareData.arrow;
					const staticSide = {
						top: "bottom",
						right: "left",
						bottom: "top",
						left: "right"
					}[placement.split("-")[0]];
					Object.assign(arrowEl.style, {
						left: arrowX != null ? `${arrowX}px` : "",
						top: arrowY != null ? `${arrowY}px` : "",
						right: "",
						bottom: "",
						[staticSide]: "-7px"
					});
				})
				.catch(() => {
					console.log(`Button not yet assigned!`);
				});
		}

		if ($navigating !== null) {
			open = false;
		}
	}
</script>

<div class="relative z-[2]">
	<button
		class="section-button no-text hide-this"
		class:active={open}
		title="Table of Contents"
		bind:this={button}
		on:click={throttled}
	>
		<ListUnordered size={iconSize} />
	</button>
	{#if open}
		<div
			class="section-dropdown"
			transition:fade|local={{ delay: 0, duration: 100 }}
			bind:this={dropdown}
			use:clickOutside
			on:outclick={throttled}
		>
			{#each sectionList as section}
				<a class="toc-link">
					{section.title}
				</a>
			{/each}
			<div class="arrow" bind:this={arrowEl}><!--arrow--></div>
		</div>
	{/if}
</div>

<style lang="scss">
	a.toc-link {
		@apply w-full py-2 px-1 first:rounded-t-lg no-underline;
		&:nth-child(odd) {
			background-color: var(--section-button-hover);
		}
		&:nth-last-child(2) {
			@apply rounded-b-lg;
		}
		color: var(--section-text-color);
		&:hover {
			background-color: var(--section-select-bg);
		}
	}
	div.arrow {
		@apply absolute w-[12px] h-[12px] transform rotate-45 border-t border-l;
		background: var(--section-background);
		border-color: var(--section-tool-color);
	}
</style>
