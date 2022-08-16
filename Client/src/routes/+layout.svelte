<script lang="ts">
	import '../app.scss';
	import { Nav } from '$lib/ui/nav';
	import { app } from "$lib/state/app.state";
	import { Guide } from "$lib/ui/guide";
	import { Toaster } from "svelte-french-toast";
</script>

<main
	class="flex flex-col h-full lg:overflow-y-hidden lg:flex-row lg:h-full {$app.theme}"
	class:light={$app.darkMode === false}
	class:dark={$app.darkMode === true}
>
	<Nav />
	<Guide>
		<slot />
	</Guide>
	<Toaster />
</main>

<style lang="scss">
	:global(main) {
		color: var(--text-color);
		font-family: var(--body-text);
		background: var(--background);
		@apply transition transform relative;
	}
</style>
