<script lang="ts">
	import { Icon } from "svelte-remix";

	export let loading = false;
	export let isActive = false;
	export let isPositive = false;
	export let isNegative = false;
	export let disabled = false;
	export let classes = "";
	export let loadingText = "Loading...";
	export let type = "button";
	export let kind: "primary" | "blurred" | "normal" = "normal";
	export let title = "";
	export let asLink = false;
	export let href = "";
	export let thisButton = null;
	export let inline = false;
	export let noAxis = false;

	let isDisabled: boolean;
	$: isDisabled = disabled || loading;
</script>

{#if asLink}
	<a
		class:primary={kind === "primary"}
		class:active={isActive}
		class:z-10={!noAxis}
		class={classes}
		{title}
		{href}
		tabindex="0"
	>
		{#if loading}
			<Icon name="loader-5-line" class="button-icon animate-spin" />
			<span class="button-text">{loadingText}</span>
		{:else}
			<slot />
		{/if}
	</a>
{:else}
	<button
		{type}
		class:primary={kind === "primary"}
		class:active={isActive}
		class:positive={isPositive}
		class:negative={isNegative}
		class:position-inline={inline}
		class:z-10={!noAxis}
		class:blurred={kind === "blurred"}
		{title}
		class:disabled
		class={classes}
		disabled={isDisabled}
		tabindex="0"
		on:click|stopPropagation
		bind:this={thisButton}
	>
		{#if loading}
			<Icon name="loader-5-line" class="button-icon animate-spin" />
			<span class="button-text">{loadingText}</span>
		{:else}
			<slot />
		{/if}
	</button>
{/if}

<style lang="scss">
	button,
	a {
		@apply flex items-center px-2 py-1.5 transition transform focus:ring-0 m-0 text-base rounded-lg select-none relative;
		text-transform: lowercase;
		font-variant: small-caps;
		font-weight: 700;
		letter-spacing: 1px;
		color: var(--text-color);
		font-family: var(--body-text);

		&.primary,
		&.active {
			@apply text-white;
			background: rgba(var(--accent-value), 0.5);

			&:hover {
				background: var(--accent-light);
			}
		}

		&.primary.active {
			@apply text-white;
			background: var(--accent-light);
		}

		&.positive {
			@apply text-white bg-green-600;
			color: white !important;
			&:hover {
				@apply bg-green-500;
			}
		}

		&.negative {
			@apply text-white bg-red-600;
			color: white !important;
			&:hover {
				@apply bg-red-500;
			}
		}

		&.position-inline {
			@apply rounded-none px-3 h-full;
		}

		&.disabled {
			@apply text-zinc-500 cursor-not-allowed;
			&:hover,
			&:active {
				color: var(--text-color);
				background: transparent;
				text-decoration: none;
				@apply scale-100;
			}
		}

		&.primary.disabled {
			@apply cursor-not-allowed;
			color: var(--accent-dark);

			&:hover,
			&:active {
				color: var(--accent-dark);
				background: var(--accent);
				text-decoration: none;
				@apply scale-100;
			}
		}

		&.blurred {
			@apply text-white bg-zinc-400 bg-opacity-30;
			backdrop-filter: blur(7px);
		}

		&:hover {
			@apply bg-zinc-400;
			color: white;
			text-decoration: none;
		}

		&:active {
			@apply text-white scale-95 cursor-pointer shadow-inner;
			background: var(--accent-dark);
		}

		:global(svg.button-icon) {
			@apply mr-1.5 relative w-4 h-4;
		}

		:global(svg.button-icon.no-text) {
			@apply mr-0 w-6 h-6;
		}

		:global(svg.button-icon.variable-text) {
			@apply mr-0 lg:mr-1.5 relative;
		}

		:global(span.button-text) {
			@apply relative -top-0.5;
		}

		:global(span.button-small-text) {
			@apply text-sm font-medium;
		}
	}
</style>
