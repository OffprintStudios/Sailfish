<script lang="ts">
	import { account } from "$lib/state/account.state";
	import {
		BlazeLine,
		TeamLine,
		UserHeartLine,
		Group2Line,
		SunLine,
		RoadMapLine
	} from "svelte-remixicon";
	import { page } from "$app/stores";
	import { getReq, type ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { Profile } from "$lib/models/accounts";
	import { Avatar } from "$lib/ui/util";
	import toast from "svelte-french-toast";
	import { onMount } from "svelte";
	import { cubicIn, cubicOut } from "svelte/easing";
	import { fly } from "svelte/transition";

	export let data;

	const iconSize = "24px";
	let loading = false;
	let recentUpdates: Paginate<Profile> = {
		items: [],
		metadata: {
			page: 1,
			per: 10,
			total: 0
		}
	};

	$: basePathname = data.pathname;

	onMount(async () => {
		/*if ($account.account && $account.currProfile) {
			await fetchFollows();
		}*/
	});

	async function fetchFollows() {
		loading = true;
		const response = await getReq<Paginate<Profile>>(
			`/followers/fetch-following/${$account.currProfile?.id}?page=1&per=10`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			recentUpdates = response as Paginate<Profile>;
		}
		loading = false;
	}
</script>

<svelte:head>
	<title>Social &mdash; Offprint</title>
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
		<TeamLine class="mr-2 text-white w-[36px] h-[36px]" />
		<h1 class="text-white text-3xl lg:text-4xl relative top-1">Social</h1>
	</div>
	<div class="flex items-center relative lg:justify-center overflow-x-auto whitespace-nowrap p-2">
		<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname === "/social"}
			href="/social"
		>
			<RoadMapLine class="mr-1" size={iconSize} />
			<span>Discover</span>
		</a>
		<!--<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/trending-blogs")}
			href="/social/trending-blogs"
		>
			<BlazeLine class="mr-1" size={iconSize} />
			<span>Trending Blogs</span>
		</a>-->
		<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/following")}
			href="/social/following"
		>
			<UserHeartLine class="mr-1" size={iconSize} />
			<span>Following</span>
		</a>
		<!--<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/groups")}
			href="/social/groups"
		>
			<Group2Line class="mr-1" size={iconSize} />
			<span>Groups</span>
		</a>
		<a
			class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
			class:active={$page.url.pathname.includes("/special-events")}
			href="/social/special-events"
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
