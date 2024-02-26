<script lang="ts">
	import { computePosition, flip, offset, shift } from "@floating-ui/dom";
	import type { Placement } from "@floating-ui/dom";
	import { slide } from "svelte/transition";
	import { Button } from "$lib/ui/util";
    import { clickOutsideAction } from "svelte-legos";
	import { throttle } from "$lib/util/functions";

    export let title: string;
	export let kind: "primary" | "normal" = "normal";
	export let open = false;
	export let position: Placement = "bottom-start";

	function determineOpenState() {
		open = !open;
	}
	const throttled = throttle(determineOpenState, 150);

	let button: HTMLButtonElement;
	let dropdown: HTMLDivElement;

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: position,
				middleware: [offset({ mainAxis: 6 }), flip(), shift({ padding: 5 })]
			})
				.then(({ x, y }) => {
					Object.assign(dropdown.style, {
						left: `${x}px`,
						top: `${y}px`
					});
				})
				.catch(() => {
					console.log(`Button not yet assigned!`);
				});
		}
	}
</script>

<div class="relative z-[2]">
	<Button
        id="dropdown-toggle-button"
        {title}
		{kind}
		active={open}
		on:click={throttled}
		bind:thisButton={button}
	>
		<slot name="button" />
	</Button>
	{#if open}
		<div
			class="dropdown-items"
			transition:slide|local={{ delay: 0, duration: 150 }}
			bind:this={dropdown}
			on:click={throttled}
			use:clickOutsideAction
			on:clickoutside={throttled}
		>
			<slot name="items" />
		</div>
	{/if}
</div>

<style lang="scss">
	:global(div.dropdown-items) {
		@apply absolute rounded-lg z-50 p-1 min-w-[12rem] max-w-[24rem];
		box-shadow: var(--dropshadow);
		background: rgb(var(--accent));
		:global(a),
		:global(button) {
			@apply flex items-center text-white w-full p-2 rounded-lg transition transform no-underline;
			:global(span) {
				@apply text-sm;
			}
			:global(svg) {
				@apply w-[18px] h-[18px];
			}
		}
		:global(span.label) {
			@apply text-xs uppercase font-bold tracking-wider px-2 py-1.5 relative mb-2;
		}
		:global(div.divider) {
			@apply w-11/12 mx-auto my-2 border-b border-white;
		}
		:global(a.active),
		:global(button.active) {
			@apply text-white;
			background: rgb(var(--accent-light));
		}
		:global(a:hover),
		:global(button:hover) {
			background: rgb(var(--accent-light)) !important;
		}
	}
</style>
