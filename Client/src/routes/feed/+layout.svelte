<script lang="ts">
	import { account } from "$lib/state/account.state";
	import { Apps2Line, Loader2Line, NewspaperLine } from "svelte-remixicon";
	import { page } from "$app/stores";
	import { getReq, type ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { Profile } from "$lib/models/accounts";
	import { Avatar } from "$lib/ui/util";
	import toast from "svelte-french-toast";
	import { onMount } from "svelte";

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

	onMount(async () => {
		await fetchFollows();
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
	<title>Feed &mdash; Offprint</title>
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
				<NewspaperLine class="mr-2 text-white w-[36px] h-[36px] lg:w-[48px] lg:h-[48px]" />
				<h1 class="text-white text-3xl lg:text-4xl relative top-1">Feed</h1>
			</div>
			<div
				class="flex items-center relative lg:justify-center overflow-x-auto whitespace-nowrap p-2"
			>
				<div class="sticky left-0 flex items-center mr-1">
					<a
						class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
						class:active={$page.url.pathname === "/feed"}
						href="/feed"
					>
						<Apps2Line class="mr-1" size={iconSize} />
						<span>All Follows</span>
					</a>
					<div
						class="border-r-2 border-zinc-300 dark:border-zinc-600 ml-0.5 h-full h-[48px]"
					>
						<!--spacer-->
					</div>
				</div>
				{#if loading}
					<Loader2Line
						size="28px"
						class="animate-[spin_2s_linear_infinite] text-zinc-400"
					/>
				{:else}
					{#each recentUpdates.items as follow}
						<a
							class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
							class:active={$page.url.pathname === `/feed/${follow.id}`}
							href="/feed/{follow.id}"
						>
							<Avatar src={follow.avatar} size="28px" borderWidth="1px" />
							<span class="ml-1">{follow.username}</span>
						</a>
					{:else}
						<span
							class="text-lg p-3 relative top-0.5"
							style="font-family: var(--header-text); color: var(--text-color);"
							>No follows yet</span
						>
					{/each}
				{/if}
			</div>
		</div>
		<slot />
	</div>
{:else}
	<div class="empty">
		<h3>No profile selected</h3>
		<p>You must select a profile before you're able to view this page.</p>
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
