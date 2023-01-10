<script lang="ts">
	import { page } from "$app/stores";
	import { account } from "$lib/state/account.state";
	import { MistLine, ListUnordered, Hashtag, GroupLine, HistoryLine } from "svelte-remixicon";

	const iconSize = "24px";
</script>

<svelte:head>
	<title>Dashboard &mdash; Offprint</title>
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
			<div class="p-2 w-full" style="background: var(--accent)">
				<img
					src="/images/dashlogo.png"
					alt="offprint dash logo"
					class="max-w-[10rem] lg:max-w-[18rem] mx-auto"
				/>
			</div>
			<div class="flex items-center lg:justify-center overflow-x-auto whitespace-nowrap p-2">
				<a
					class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
					class:active={$page.url.pathname === "/dashboard"}
					href="/dashboard"
				>
					<MistLine class="mr-1" size={iconSize} />
					<span>Overview</span>
				</a>
				<a
					class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
					class:active={$page.url.pathname.includes("/approval-queue")}
					href="/dashboard/approval-queue"
					data-sveltekit-preload-data
				>
					<ListUnordered class="mr-1" size={iconSize} />
					<span>Approval Queue</span>
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
					class:active={$page.url.pathname.includes("/users")}
					href="/dashboard/users"
				>
					<GroupLine class="mr-1" size={iconSize} />
					<span>Users</span>
				</a>
				<!--<a
					class="feature-link hover:bg-zinc-300 hover:dark:bg-zinc-600"
					class:active={$page.url.pathname.includes("/audit-log")}
					href="/dashboard/audit-log"
				>
					<HistoryLine class="mr-1" size={iconSize} />
					<span>Audit Log</span>
				</a>-->
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
