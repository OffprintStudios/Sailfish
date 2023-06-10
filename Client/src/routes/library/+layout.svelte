<script lang="ts">
	import { page } from "$app/stores";
	import { account } from "$lib/state/account.state";
	import {
		BookmarkLine,
		Bookmark3Line,
		StarLine,
		HistoryLine,
		CheckDoubleLine,
		BarChart2Line
	} from "svelte-remixicon";

	const iconSize = "24px";
</script>

<svelte:head>
	<title>Library &mdash; Offprint</title>
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

{#if $account.account && $account.currProfile}
	<div class="mx-auto max-w-7xl">
		<div
			class="lg:flex lg:flex-col lg:items-center lg:justify-center mb-6 lg:mt-6 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed lg:rounded-xl overflow-hidden"
		>
			<div
				class="flex items-center justify-center p-4 w-full"
				style="background: var(--accent)"
			>
				<BookmarkLine class="mr-2 text-white w-[36px] h-[36px] lg:w-[48px] lg:h-[48px]" />
				<h1 class="text-white text-3xl lg:text-4xl relative top-1">Library</h1>
			</div>
			<div class="flex items-center lg:justify-center overflow-x-auto whitespace-nowrap p-2">
				<a
					class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
					class:active={$page.url.pathname === "/library"}
					href="/library"
				>
					<Bookmark3Line class="mr-1" size={iconSize} />
					<span>My Library</span>
				</a>
				<a
					class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
					class:active={$page.url.pathname.includes("/favorite-blogs")}
					href="/library/favorite-blogs"
				>
					<StarLine class="mr-1" size={iconSize} />
					<span>Favorite Blogs</span>
				</a>
				<a
					class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
					class:active={$page.url.pathname.includes("/reading-history")}
					href="/library/reading-history"
				>
					<HistoryLine class="mr-1" size={iconSize} />
					<span>Reading History</span>
				</a>
				<a
					class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
					class:active={$page.url.pathname.includes("/finished-reading")}
					href="/library/finished-reading"
				>
					<CheckDoubleLine class="mr-1" size={iconSize} />
					<span>Finished Reading</span>
				</a>
				<div
					class="border-r-2 border-zinc-300 dark:border-zinc-600 ml-0.5 mr-1 h-full h-[48px]"
				>
					<!--spacer-->
				</div>
				<a
					class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
					class:active={$page.url.pathname.includes("/shelves")}
					href="/library/shelves"
				>
					<BarChart2Line class="mr-1" size={iconSize} />
					<span>Shelves</span>
				</a>
			</div>
		</div>
		<slot />
	</div>
{:else if $account.account}
	<div class="empty">
		<h3>No profile selected</h3>
		<p>You must select a profile before you're able to view this page.</p>
	</div>
{:else}
	<div class="empty">
		<h3>You aren't logged in</h3>
		<p>Gotta log in first before seeing your library, don't you think?</p>
	</div>
{/if}

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
