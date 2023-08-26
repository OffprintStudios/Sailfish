<script lang="ts">
	import { page } from "$app/stores";

	export let type: 'link' | 'button' = 'link';
	export let href: string | null = null;
	export let isActive = false;
	export let hasMargin = true;
</script>

{#if type === 'link'}
	<a
		class="link hover:no-underline hover:bg-zinc-300 dark:hover:bg-zinc-600"
		{href}
		class:active={$page.url.pathname === href}
		class:mx-0.5={hasMargin}
	>
		<slot />
	</a>
{:else}
	<button class="link hover:bg-zinc-300 dark:hover:bg-zinc-600" class:mx-0.5={hasMargin} class:active={isActive} on:click>
		<slot />
	</button>
{/if}

<style lang="scss">
	a.link, button.link {
		@apply rounded-lg transition transform;
		@apply flex flex-col items-center justify-center w-[61px] h-[61px] relative;
		color: var(--text-color);
		&:active {
			@apply scale-95;
		}
		&.active {
			@apply no-underline text-white;
			background: var(--accent);
		}
		:global(span.link-name) {
			@apply text-[0.6rem] uppercase font-bold tracking-wider;
		}
		:global(svg.link-icon) {
			width: 24px;
			height: 24px;
		}
	}
</style>