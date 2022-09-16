<script lang="ts">
	import { Loader5Line } from 'svelte-remixicon';

	export let loading = false;
	export let isActive = false;
	export let disabled = false;
	export let classes = '';
	export let loadingText = 'Loading...';
	export let type = 'button';
	export let kind: 'primary' | 'normal' = 'normal';
	export let title = '';
	export let asLink = false;
	export let href = '';
	export let thisButton = null;

	let isDisabled: boolean;
	$: isDisabled = disabled || loading;
</script>

{#if asLink}
	<a
		class:primary={kind === 'primary'}
		class:active={isActive}
		class="{classes}"
		{title}
		{href}
		tabindex="0"
	>
		{#if loading}
			<Loader5Line class="button-icon animate-spin" />
			<span class="button-text">{loadingText}</span>
		{:else}
			<slot />
		{/if}
	</a>
{:else}
	<button
		{type}
		class:primary={kind === 'primary'}
		class:active={isActive}
		{title}
		class:disabled
		class="{classes}"
		disabled={isDisabled}
		tabindex="0"
		on:click
		bind:this={thisButton}
	>
		{#if loading}
			<Loader5Line class="button-icon animate-spin" />
			<span class="button-text">{loadingText}</span>
		{:else}
			<slot />
		{/if}
	</button>
{/if}

<style lang="scss">
	button, a {
		@apply flex items-center px-2 py-1.5 transition transform focus:ring-0 m-0 text-base rounded-lg select-none;
		text-transform: lowercase;
		font-variant: small-caps;
		font-weight: 700;
		letter-spacing: 1px;
		color: var(--text-color);

		&.primary,
		&.active {
			@apply text-white;
			background: var(--accent);

			&:hover {
				background: var(--accent-light);
			}
		}

		&.primary.active {
			@apply text-white;
			background: var(--accent-light);
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

		&:hover {
			color: white;
			background: var(--accent);
			text-decoration: none;
		}

		&:active {
			@apply text-white scale-95 cursor-pointer shadow-inner;
			background: var(--accent-dark);
		}

		:global(svg.button-icon) {
			@apply mr-1.5 relative;
		}

		:global(svg.button-icon.no-text) {
			@apply mr-0;
		}

		:global(span.button-text) {
			@apply relative -top-0.5;
		}
	}
</style>