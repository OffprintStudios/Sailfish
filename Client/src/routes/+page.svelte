<script lang="ts">
	import { NewsCarousel, ExploreSummary } from "$lib/ui/content";
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

<div>
	<NewsCarousel />
	<div class="my-6 hidden lg:block"><!--spacer--></div>
	<ExploreSummary />
	<!--<div class="flex flex-col h-full lg:flex-row">
		<div id="explore-nav" class="explore-nav" class:isStuck={exploreNavStuck}>
			<button class="explore-nav-button">
				<SparklingLine size="24px" class="mr-2" />
				<span class="hidden lg:block">Recommended For You</span>
				<span class="lg:hidden">Recommended</span>
			</button>
			<button class="explore-nav-button">
				<BlazeLine size="24px" class="mr-2" />
				<span class="hidden lg:block">Trending Now</span>
				<span class="lg:hidden">Trending</span>
			</button>
			<button class="explore-nav-button">
				<Loader2Line size="24px" class="mr-2" />
				<span class="hidden lg:block">What's New</span>
				<span class="lg:hidden">New</span>
			</button>
			<button class="explore-nav-button">
				<SignalTowerFill size="24px" class="mr-2" />
				<span class="hidden lg:block">Recently Updated</span>
				<span class="lg:hidden">Updated</span>
			</button>
			<button class="explore-nav-button">
				<NewspaperLine size="24px" class="mr-2" />
				<span class="hidden lg:block">News & Announcements</span>
				<span class="lg:hidden">News</span>
			</button>
			<div class="my-2 border-b-2 border-zinc-300 dark:border-zinc-600"></div>
		</div>
		<div class="lg:mx-6 my-6 lg:h-full">

		</div>
	</div>-->
</div>

<style lang="scss">
	div.explore-nav {
		@apply w-full lg:w-72 p-2 flex lg:flex-col sticky top-[50px] z-10 lg:top-0 lg:h-[calc(100vh-60px)] overflow-x-scroll transition duration-500;
		&.isStuck {
			@apply bg-zinc-200 dark:bg-zinc-700;
		}
		button.explore-nav-button {
			@apply p-2 rounded-2xl lg:w-full mx-0.5 first:ml-0 last:mr-0 lg:mx-0 whitespace-nowrap flex items-center lg:my-0.5 lg:first:mt-0 lg:last:mb-0 transition text-lg;
			font-family: var(--header-text);
			span {
				@apply relative top-[0.1675rem];
			}
		}
	}
</style>
