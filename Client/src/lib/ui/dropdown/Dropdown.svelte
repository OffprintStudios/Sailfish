<script lang="ts">
	import { computePosition, flip, offset, shift } from "@floating-ui/dom";
	import type { Placement } from "@floating-ui/dom";
	import { slide } from 'svelte/transition';
	import { Button } from "$lib/ui/util"
	import { clickOutside } from '$lib/util/functions'

	export let kind: 'primary' | 'normal' = 'normal';
	export let open = false;
	export let position: Placement = 'bottom-start';

	function determineOpenState() {
		open = !open;
	}

	let button: HTMLButtonElement = null;
	let dropdown: HTMLDivElement = null;

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: position,
				middleware: [offset({ mainAxis: 6 }), flip(), shift({ padding: 5 })]
			}).then(({ x, y }) => {
				Object.assign(dropdown.style, {
					left: `${x}px`,
					top: `${y}px`
				})
			}).catch(() => {
				console.log(`Button not yet assigned!`);
			})
		}
	}
</script>

<div class="relative z-[2]">
	<Button
		kind={kind === 'normal' ? 'normal' : 'primary'}
		isActive={open}
		on:click={determineOpenState}
		bind:thisButton={button}
	>
		<slot name="button" />
	</Button>
	{#if open}
		<div
			class="dropdown-items"
			transition:slide|local="{{ delay: 0, duration: 150 }}"
			bind:this={dropdown}
			use:clickOutside
			on:outclick={determineOpenState}
		>
			<slot name="items" />
		</div>
	{/if}
</div>

<style lang="scss">
	:global(div.dropdown-items) {
		@apply absolute rounded-lg z-10 p-1 min-w-[12rem] max-w-[24rem] bg-zinc-200;
		box-shadow: var(--dropshadow);
		:global(a), :global(button) {
			@apply flex items-center w-full p-2 rounded-lg transition transform no-underline hover:bg-zinc-300;
			color: var(--text-color);
			:global(span) {
				@apply text-sm;
			}
		}
		:global(span.label) {
			@apply text-xs uppercase font-bold tracking-wider px-2 py-1.5 relative mb-2;
		}
		:global(div.divider) {
			@apply w-11/12 mx-auto my-2 border-b;
		}
		:global(a.active), :global(button.active) {
			@apply text-white;
			background: var(--accent);
		}
	}

	:global(.dark div.dropdown-items) {
		@apply bg-zinc-700;
		:global(a), :global(button) {
			@apply hover:bg-zinc-600;
		}
	}
</style>