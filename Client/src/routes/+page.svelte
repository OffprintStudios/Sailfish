<script lang="ts">
	import { DEFAULT_SLOGANS } from '$lib/util/constants';

	let currSlogan = DEFAULT_SLOGANS[Math.floor(Math.random() * DEFAULT_SLOGANS.length)];
	const today = new Date();
</script>

<svelte:head>
	<title>Home &mdash; Offprint</title>
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

<div class="w-11/12 mx-auto max-w-7xl mb-6">
	<div class="home-header">
		<div class="hidden lg:block w-1/4">
			<div class="deco-box flex-col">
				<span class="relative top-2 left-[0.075rem] text-4xl">{today.toLocaleString('default', { month: 'short' })}</span>
				<span class="relative bottom-1.5 left-[0.075rem] text-xl">{today.getFullYear()}</span>
			</div>
		</div>
		<div class="lg:w-2/4 flex flex-col items-center justify-center">
			<img
				src="/images/logo.png"
				alt="offprint logo"
				class="max-w-[8rem] lg:max-w-[18rem] mx-auto"
			/>
			<h2 class="hidden lg:block text-white font-light text-lg">
				{currSlogan}
			</h2>
		</div>
		<div class="hidden w-1/4 lg:flex items-center justify-end">
			<div class="deco-box flex-row">
				<span class="relative text-5xl font-normal">25</span>
				<span class="relative text-3xl bottom-0.5 ml-1">¢</span>
			</div>
		</div>
	</div>
</div>

<style lang="scss">
	div.home-header {
		@apply text-white text-center my-6 rounded-xl px-4 py-2 w-full flex items-center justify-center;
		background: var(--accent);
		div.deco-box {
			@apply h-20 w-20 rounded-full flex items-center justify-center text-white font-semibold all-small-caps;
			font-family: var(--header-text), sans-serif;
		}
	}
</style>
