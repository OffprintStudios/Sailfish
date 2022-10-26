<script lang="ts">
	import { page } from "$app/stores";
	import { Home5Line, CupLine, QuillPenLine, BarChart2Line, ImageEditLine, ImageAddLine, ServiceLine, AlarmWarningLine, CloseCircleLine, PieChartLine } from "svelte-remixicon";
	import { Avatar, RoleBadge } from "$lib/ui/util";
	import { slugify } from "$lib/util/functions";
	import { Button } from "$lib/ui/util";
	import { profileState } from "$lib/state/profile.state";
	import { account } from "$lib/state/account.state";
	import type { Profile } from "$lib/models/accounts";

	export let data: Profile;

	$profileState = data;

	const iconSize = "24px";
</script>

<svelte:head>
	<title>{data.username}'s Profile &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{data.username}'s Profile" />
	<meta name="description" content="{data.info.bio}" />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content="https://offprint.net/profile/{data.id}/{slugify(data.username)}" />
	<meta property="og:title" content="{data.username}'s Profile" />
	<meta
		property="og:description"
		content="{data.info.bio}"
	/>
	<meta property="og:image" content="{data.avatar}" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary_large_image" />
	<meta property="twitter:url" content="https://offprint.net/profile/{data.id}/{slugify(data.username)}" />
	<meta property="twitter:title" content="{data.username}'s Profile" />
	<meta
		property="twitter:description"
		content="{data.info.bio}"
	/>
	<meta property="twitter:image" content="{data.avatar}" />
</svelte:head>

<div class="w-11/12 mx-auto max-w-7xl mb-6">
	<div class="profile-nav-container">
		{#if data.info.coverPic}
			{#if $account.account && $account.currProfile && $account.currProfile.id === data.id}
				<div class="absolute top-2 right-2">
					<Button kind="primary">
						<ImageEditLine class="button-icon no-text" size="20px" />
					</Button>
				</div>
			{/if}
			<div class="profile-cover">
				<img src={data.info.coverPic} alt="{data.username}'s Cover Picture" />
			</div>
		{:else}
			<div class="profile-banner">
				{#if $account.account && $account.currProfile && $account.currProfile.id === data.id}
					<div class="absolute top-2 right-2">
						<Button kind="primary">
							<ImageAddLine class="button-icon no-text" size="20px" />
						</Button>
					</div>
				{/if}
			</div>
		{/if}
		<div class="profile-nav bg-zinc-200 dark:bg-zinc-700">
			<Avatar src={data.avatar} size="150px" borderWidth="2px" />
			<div class="ml-4 self-center">
				<div class="flex items-center">
					<RoleBadge roles={data.account.roles} />
					<h3>{data.username}</h3>
				</div>
				<div class="flex items-center text-xs">
					<a
						class="text-zinc-800 dark:text-white no-underline"
						href="/profile/{data.id}/{slugify(data.username)}/followers"
					>
						0 followers
					</a>
					<span class="text-zinc-800 dark:text-white mx-1">•</span>
					<a
						class="text-zinc-800 dark:text-white no-underline"
						href="/profile/{data.id}/{slugify(data.username)}/following"
					>
						0 following
					</a>
				</div>
			</div>
			<div class="flex-1"><!--spacer--></div>
			<a
				class="link hover:no-underline hover:bg-zinc-300 dark:hover:bg-zinc-600"
				href="/profile/{data.id}/{slugify(data.username)}"
				class:active={$page.url.pathname === `/profile/${data.id}/${slugify(data.username)}`}
			>
				<span class="link-icon"><Home5Line size={iconSize} /></span>
				<span class="link-name">Home</span>
			</a>
			<a
				class="link hover:no-underline hover:bg-zinc-300 dark:hover:bg-zinc-600"
				href="/profile/{data.id}/{slugify(data.username)}/blogs"
				class:active={$page.url.pathname === `/profile/${data.id}/${slugify(data.username)}/blogs`}
			>
				<span class="link-icon"><CupLine size={iconSize} /></span>
				<span class="link-name">Blogs</span>
			</a>
			<a
				class="link hover:no-underline hover:bg-zinc-300 dark:hover:bg-zinc-600"
				href="/profile/{data.id}/{slugify(data.username)}/works"
				class:active={$page.url.pathname === `/profile/${data.id}/${slugify(data.username)}/works`}
			>
				<span class="link-icon"><QuillPenLine size={iconSize} /></span>
				<span class="link-name">Works</span>
			</a>
			<a
				class="link hover:no-underline hover:bg-zinc-300 dark:hover:bg-zinc-600"
				href="/profile/{data.id}/{slugify(data.username)}/shelves"
				class:active={$page.url.pathname === `/profile/${data.id}/${slugify(data.username)}/shelves`}
			>
				<span class="link-icon"><BarChart2Line size={iconSize} /></span>
				<span class="link-name">Shelves</span>
			</a>
			{#if $account.account && $account.currProfile}
				{#if $account.currProfile.id === data.id}
					<div class="h-full mx-1 border border-zinc-300 dark:border-zinc-500"><!--spacer--></div>
					<button class="link hover:bg-zinc-300 dark:hover:bg-zinc-600">
						<span class="link-icon"><PieChartLine size={iconSize} /></span>
						<span class="link-name">Stats</span>
					</button>
				{:else}
					<div class="h-full mx-1 border border-zinc-300"><!--spacer--></div>
					<button class="link hover:bg-zinc-300 dark:hover:bg-zinc-600">
						<span class="link-icon"><ServiceLine size={iconSize} /></span>
						<span class="link-name">Follow</span>
					</button>
					<button class="link hover:bg-zinc-300 dark:hover:bg-zinc-600">
						<span class="link-icon"><CloseCircleLine size={iconSize} /></span>
						<span class="link-name">Block</span>
					</button>
					<button class="link hover:bg-zinc-300 dark:hover:bg-zinc-600">
						<span class="link-icon"><AlarmWarningLine size={iconSize} /></span>
						<span class="link-name">Report</span>
					</button>
				{/if}
			{/if}
		</div>
	</div>

	<slot />
</div>

<style lang="scss">
	div.profile-nav-container {
		@apply flex flex-col w-full my-6;
		div.profile-banner {
			@apply h-[92px] w-full rounded-t-xl relative;
			background: var(--accent);
		}
		div.profile-cover {
			@apply h-[240px] w-full overflow-hidden rounded-t-xl;
			img {
				@apply object-cover w-full h-full;
			}
		}
		div.profile-nav {
			@apply flex items-end px-1.5 py-2 rounded-b-xl h-[77px] relative z-10;
			h3 {
				@apply text-4xl;
			}
			a.link, button.link {
				@apply mx-0.5 rounded-lg transition transform;
				@apply flex flex-col items-center justify-center w-[61px] h-[61px] relative;
				color: var(--text-color);
				&:active {
					@apply scale-95;
				}
				&.active {
					@apply no-underline text-white;
					background: var(--accent);
				}
				span.link-name {
					@apply text-[0.6rem] uppercase font-bold tracking-wider;
				}
			}
		}
	}
</style>
