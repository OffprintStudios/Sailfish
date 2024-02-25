<script lang="ts">
    import { Jumbotron, CardCarousel, NewsPanel, GenreGrid } from "$lib/ui/content";
	import { RiLoader2Line, RiSignalTowerLine } from "svelte-remixicon";
</script>

<svelte:head>
	<title>Home &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="Offprint" />
	<meta name="description" content="For The Stories Left Untold" />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content="https://offprint.cafe/" />
	<meta property="og:title" content="Offprint" />
	<meta
		property="og:description"
		content="For The Stories Left Untold"
	/>
	<meta property="og:image" content="/images/offprint_icon.png" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta property="twitter:url" content="https://offprint.cafe/" />
	<meta property="twitter:title" content="Offprint" />
	<meta
		property="twitter:description"
		content="For The Stories Left Untold"
	/>
	<meta property="twitter:image" content="/images/offprint_icon.png" />
</svelte:head>

<Jumbotron />

<div class="flex flex-col max-w-6xl mx-auto w-full md:w-11/12 my-6">
    <CardCarousel>
        <RiLoader2Line size="30px" />
        <h3 class="text-2xl text-black dark:text-white mx-2">What's New</h3>
    </CardCarousel>
    <div class="my-4"><!--spacer--></div>
    <CardCarousel>
        <RiSignalTowerLine size="30px" />
        <h3 class="text-2xl text-black dark:text-white mx-2">Recently Updated</h3>
    </CardCarousel>
    <div class="my-4"><!--spacer--></div>
    <NewsPanel />
    <GenreGrid />
</div>
