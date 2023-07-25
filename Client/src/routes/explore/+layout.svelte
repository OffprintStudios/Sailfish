<script lang="ts">
	import { page } from "$app/stores";
	import {
		Loader2Line,
		CompassDiscoverLine,
		SignalTowerFill,
		Book2Line,
		EmpathizeLine
	} from "svelte-remixicon";
	import { cubicIn, cubicOut } from "svelte/easing";
	import { fly } from "svelte/transition";

	export let data;

	$: basePathname = data.pathname;

	const iconSize = "24px";
</script>

<svelte:head>
	<title>Explore &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="Offprint" />
	<meta name="description" content="A next-generation publishing and community platform." />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content="https://offprint.net/" />
	<meta property="og:title" content="Offprint" />
	<meta
		property="og:description"
		content="A next-generation publishing and community platform."
	/>
	<meta property="og:image" content="/images/offprint_icon.png" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta property="twitter:url" content="https://offprint.net/" />
	<meta property="twitter:title" content="Offprint" />
	<meta
		property="twitter:description"
		content="A next-generation publishing and community platform."
	/>
	<meta property="twitter:image" content="/images/offprint_icon.png" />
</svelte:head>

<div class="mb-6 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed overflow-hidden">
	<div
		class="flex items-center justify-center px-4 py-4 lg:py-6 w-full"
		style="background: var(--accent-dark)"
	>
		<CompassDiscoverLine class="mr-2 text-white w-[36px] h-[36px]" />
		<h1 class="text-white text-3xl lg:text-4xl relative top-1">Explore</h1>
	</div>
	<div class="flex items-center lg:justify-center overflow-x-auto whitespace-nowrap p-2">
		<!--<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/popular-this-week")}
			href="/explore/popular-this-week"
		>
			<BlazeLine class="mr-1" size={iconSize} />
			<span>Trending Now</span>
		</a>-->
		<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/new-works")}
			href="/explore/new-works"
			data-sveltekit-preload-data
		>
			<Loader2Line class="mr-1" size={iconSize} />
			<span>What's New</span>
		</a>
		<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/updated-works")}
			href="/explore/updated-works"
			data-sveltekit-preload-data
		>
			<SignalTowerFill class="mr-1" size={iconSize} />
			<span>Recently Updated</span>
		</a>
		<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/genres")}
			href="/explore/genres"
			data-sveltekit-preload-data
		>
			<Book2Line class="mr-1" size={iconSize} />
			<span>Genres</span>
		</a>
		<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/fandoms")}
			href="/explore/fandoms"
			data-sveltekit-preload-data
		>
			<EmpathizeLine class="mr-1" size={iconSize} />
			<span>Fandoms</span>
		</a>
		<!--<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/special-events")}
			href="/explore/special-events"
		>
			<SunLine class="mr-1" size={iconSize} />
			<span>Special Events</span>
		</a>-->
	</div>
</div>
{#key basePathname}
	<div
		in:fly={{ easing: cubicOut, x: 10, delay: 400, duration: 300 }}
		out:fly={{ easing: cubicIn, x: -10, duration: 300 }}
		class="w-11/12 mx-auto"
	>
		<slot />
	</div>
{/key}

<style lang="scss">
	a.feature-link {
		@apply flex text-base lg:text-lg items-center p-3 rounded-lg no-underline mr-0.5 last:mr-0 transition transform;
		color: var(--text-color);
		font-family: var(--header-text);
		span {
			@apply relative top-0.5;
		}
		&.active {
			@apply text-white;
			background: var(--accent);
		}
	}
</style>
