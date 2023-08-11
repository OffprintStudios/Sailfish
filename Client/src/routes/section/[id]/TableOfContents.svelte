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
	import { ListUnordered, ArrowRightSLine } from "svelte-remixicon";
	import { fade } from "svelte/transition";
	import { account } from '$lib/state/account.state';

	export let authorId: string;
	export let sectionId: string;
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
					console.warn(`Button not yet assigned!`);
				});
		}

		if ($navigating !== null) {
			open = false;
		}
	}
</script>

<div class="relative z-[2]">
	<button
		class="section-button no-text"
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
			<div class="section-dropdown-content">
				{#if $account.currProfile?.id === authorId}
					{#each sectionList as section}
						<a class="toc-link" title={section.title} href="/section/{section.id}">
							{#if section.id === sectionId}
							<span class="min-w-[22px] max-w-[22px]">
								<ArrowRightSLine size="18px" />
							</span>
							{:else}
								<span class="min-w-[22px] max-w-[22px]"><!--placeholder--></span>
							{/if}
							<span class="max-w-full truncate">{section.title}</span>
						</a>
					{/each}
				{:else}
					{#each published as section}
						<a class="toc-link" title={section.title} href="/section/{section.id}">
							{#if section.id === sectionId}
							<span class="min-w-[22px] max-w-[22px]">
								<ArrowRightSLine size="18px" />
							</span>
							{:else}
								<span class="min-w-[22px] max-w-[22px]"><!--placeholder--></span>
							{/if}
							<span class="max-w-full truncate">{section.title}</span>
						</a>
					{/each}
				{/if}
			</div>
			<div class="arrow" bind:this={arrowEl}><!--arrow--></div>
		</div>
	{/if}
</div>

<style lang="scss">
	a.toc-link {
		@apply flex items-center w-full py-2 px-1 first:rounded-t-lg last:rounded-b-lg no-underline;
		&:nth-child(odd) {
			background-color: var(--section-button-hover);
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
