<script lang="ts">
	import { computePosition, flip, offset, shift } from "@floating-ui/dom";
	import type { Placement } from "@floating-ui/dom";
	import { slide, scale } from "svelte/transition";
	import { Button } from "$lib/ui/util";
	import { clickOutside } from "$lib/util/functions";
	import { DEFAULT_SLOGANS } from "$lib/util/constants";
	import { SearchEyeLine } from "svelte-remixicon";

	export let open = false;
	export let position: Placement = "bottom";

	const currSlogan = DEFAULT_SLOGANS[Math.floor(Math.random() * DEFAULT_SLOGANS.length)];

	let button: HTMLButtonElement = null;
	let dropdown: HTMLDivElement = null;

	function determineState() {
		open = !open;
	}

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: position,
				middleware: [offset({ mainAxis: -40 }), flip(), shift({ padding: 5 })]
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
	<button class="search-button" on:click={determineState} bind:this={button}>
		<SearchEyeLine size="20px" class="mr-2" />
		<span>{currSlogan}</span>
	</button>
	{#if open}
		<div
			class="search-dropdown-items bg-zinc-200 dark:bg-zinc-700"
			transition:slide|local={{ delay: 0, duration: 150 }}
			bind:this={dropdown}
			use:clickOutside
			on:outclick={determineState}
		>
			<div class="search-button">
				<SearchEyeLine size="20px" class="mx-2" />
				<input
					type="text"
					class="text-white text-sm px-0 py-2.5 flex-1 m-0 bg-transparent border-0 focus:ring-0 rounded-lg placeholder:text-zinc-200"
					placeholder={currSlogan}
				/>
			</div>
			<div class="search-items">
				<div class="search-tab-row">
					<button class="active">Works</button>
					<button>Blogs</button>
					<button>Users</button>
				</div>
				<div class="search-results">
					<div class="empty">
						<p>Let's see what we can dig up, yeah?</p>
					</div>
				</div>
			</div>
		</div>
	{/if}
</div>

<style lang="scss">
	button.search-button {
		@apply w-9/12 mx-auto flex items-center justify-center py-2 border-b-2 border-white text-sm rounded-md z-10 transition transform;
		background: var(--accent-light);
		box-shadow: var(--dropshadow);
		&:hover {
			@apply scale-[1.025];
		}
	}
	div.search-button {
		@apply w-full flex items-center justify-center border-b-2 border-white text-sm rounded-t-md z-10 overflow-hidden transition transform;
		background: var(--accent-light);
		box-shadow: var(--dropshadow);
	}
	div.search-items {
		@apply p-2 min-h-[350px] max-h-[350px];
	}
	div.search-tab-row {
		@apply flex items-center justify-center mx-auto;
		button {
			@apply px-4 py-2 all-small-caps text-lg tracking-wider font-bold transition border-b-4 border-transparent;
			&.active {
				border-color: var(--accent);
			}
		}
	}
	div.search-dropdown-items {
		@apply absolute rounded-lg z-50 min-w-[36rem] max-w-[36rem];
		box-shadow: var(--dropshadow);
	}
</style>
