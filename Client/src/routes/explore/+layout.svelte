<script lang="ts">
	import { page } from "$app/stores";
	import {
		NewspaperLine,
		CalendarLine,
		Calendar2Line,
		Hashtag,
		SunLine,
		CompassDiscoverLine
	} from "svelte-remixicon";

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

<div class="mx-auto max-w-7xl">
	<div
		class="flex flex-col items-center justify-center my-6 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed rounded-xl overflow-hidden"
	>
		<div class="flex items-center justify-center p-4 w-full" style="background: var(--accent)">
			<CompassDiscoverLine size="48px" class="mr-2 text-white" />
			<h1 class="text-white text-4xl relative top-1">Explore</h1>
		</div>
		<div class="flex items-center justify-center p-2">
			<a
				class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
				class:active={$page.url.pathname.includes("/popular-this-week")}
				href="/explore/popular-this-week"
			>
				<CalendarLine class="mr-1" size={iconSize} />
				<span>Popular This Week</span>
			</a>
			<a
				class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
				class:active={$page.url.pathname.includes("/popular-today")}
				href="/explore/popular-today"
			>
				<Calendar2Line class="mr-1" size={iconSize} />
				<span>Popular Today</span>
			</a>
			<a
				class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
				class:active={$page.url.pathname.includes("/new-works")}
				href="/explore/new-works"
			>
				<NewspaperLine class="mr-1" size={iconSize} />
				<span>New Works</span>
			</a>
			<a
				class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
				class:active={$page.url.pathname.includes("/tags")}
				href="/dashboard/tags"
			>
				<Hashtag class="mr-1" size={iconSize} />
				<span>Tags</span>
			</a>
			<a
				class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
				class:active={$page.url.pathname.includes("/special-events")}
				href="/explore/popular-today"
			>
				<SunLine class="mr-1" size={iconSize} />
				<span>Special Events</span>
			</a>
		</div>
	</div>
	<slot />
</div>

<style lang="scss">
	a.feature-link {
		@apply flex text-lg items-center p-3 rounded-lg no-underline mr-0.5 last:mr-0 transition transform;
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
