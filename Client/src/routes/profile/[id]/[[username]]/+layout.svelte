<script lang="ts">
	import {
		CupLine,
		QuillPenLine,
		BarChart2Line,
		ImageEditLine,
		ImageAddLine,
		AlarmWarningLine,
		UserFollowLine,
		UserUnfollowLine,
		More2Fill,
		Cake2Line,
		InformationLine,
		LinksFill,
		Link
	} from "svelte-remixicon";
	import { page } from "$app/stores";
	import { RoleBadge } from "$lib/ui/util";
	import { slugify } from "$lib/util/functions";
	import { Button } from "$lib/ui/util";
	import { account } from "$lib/state/account.state";
	import type { Profile } from "$lib/models/accounts";
	import { openPopup } from "$lib/ui/popup";
	import { UploadProfileCover } from "$lib/ui/upload";
	import { onMount } from "svelte";
	import { delReq, getReq, postReq, type ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";
	import { abbreviate, pluralize } from "$lib/util/functions";
	import Time from "$lib/ui/util/Time.svelte";
	import SvelteMarkdown from "svelte-markdown";
	import Dropdown from "$lib/ui/dropdown/Dropdown.svelte";
	import LinkTag from "$lib/ui/content/LinkTag.svelte";
	import { ReportForm } from "$lib/ui/admin";
	import { ReportKind } from "$lib/models/admin/users/reports";

	export let data: Profile;

	let hasFollowed = { isFollowing: false };
	let loadingFollow = false;

	onMount(async () => {
		if ($account.account && $account.currProfile && $account.currProfile.id !== data.id) {
			await checkFollow();
		}
	});

	function updateBanner() {
		openPopup(
			UploadProfileCover,
			{
				onConfirm(value: Profile) {
					$account.currProfile = value;
					$account.profiles = $account.profiles.map((item) => {
						return item.id === value.id ? value : item;
					});
					data = value;
				}
			},
			{ profileId: data.id }
		);
	}

	async function checkFollow() {
		loadingFollow = true;
		const response = await getReq<{ isFollowing: boolean }>(
			`/followers/check-if-following/${data.id}?profileId=${$account.currProfile?.id}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			hasFollowed = response as { isFollowing: boolean };
		}
		loadingFollow = false;
	}

	async function followUser() {
		loadingFollow = true;
		const response = await postReq<{ isFollowing: boolean }>(
			`/followers/follow-user/${data.id}?profileId=${$account.currProfile?.id}`,
			{}
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			hasFollowed = response as { isFollowing: boolean };
		}
		loadingFollow = false;
	}

	async function unfollowUser() {
		loadingFollow = true;
		const response = await delReq<{ isFollowing: boolean }>(
			`/followers/unfollow-user/${data.id}?profileId=${$account.currProfile?.id}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			hasFollowed = response as { isFollowing: boolean };
		}
		loadingFollow = false;
	}

	function reportUser() {
		openPopup(
			ReportForm,
			{
				onConfirm: () => {
					console.log("0");
				}
			},
			{ kind: ReportKind.User, accountId: data.account.id, itemId: data.id }
		);
	}
</script>

<svelte:head>
	<title>{data.username}'s Profile &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content="{data.username}'s Profile" />
	<meta name="description" content={data.info.bio} />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="profile" />
	<meta property="profile:username" content={data.username} />
	<meta
		property="og:url"
		content="https://offprint.net/profile/{data.id}/{slugify(data.username)}"
	/>
	<meta property="og:title" content="{data.username}'s Profile" />
	<meta property="og:description" content={data.info.bio} />
	<meta property="og:image" content={data.avatar} />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary" />
	<meta
		property="twitter:url"
		content="https://offprint.net/profile/{data.id}/{slugify(data.username)}"
	/>
	<meta property="twitter:title" content="{data.username}'s Profile" />
	<meta property="twitter:description" content={data.info.bio} />
	<meta property="twitter:image" content={data.avatar} />
</svelte:head>

<div class="xl:w-11/12 mx-auto mb-6 xl:mt-6 max-w-7xl">
	<div class="profile-header bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
		<div class="avatar">
			<div
				class="w-[115px] h-[115px] lg:w-[175px] lg:h-[175px] border-4 border-zinc-300 dark:border-zinc-600 rounded-full bg-zinc-300 dark:bg-zinc-600 overflow-hidden"
			>
				<img
					src={data.avatar}
					alt="{data.username}'s Avatar"
					class="object-cover w-full h-full"
				/>
			</div>
		</div>
		<div class="banner {data.bannerArt ? 'big-art' : 'small-art'}">
			{#if data.bannerArt}
				<img src={data.bannerArt} alt="cover art" class="w-full h-full object-cover" />
			{/if}
			<div class="absolute top-2 right-2 z-[2]">
				<div class="relative top-0.5 flex items-center">
					<div class="lg:hidden">
						<RoleBadge roles={data.account.roles} size="large" />
					</div>
					{#if $account.account && $account.currProfile && $account.currProfile.id === data.id}
						<div class="lg:hidden mx-2 text-white text-lg relative">|</div>
						<Button on:click={updateBanner} kind="primary">
							{#if data.bannerArt}
								<ImageEditLine class="button-icon no-text" size="18px" />
							{:else}
								<ImageAddLine class="button-icon no-text" size="18px" />
							{/if}
						</Button>
					{/if}
				</div>
			</div>
		</div>
		<div class="user">
			<div class="flex-1">
				<div class="hidden lg:flex items-center">
					<h1 class="text-4xl">
						<a href="/profile/{data.id}/{slugify(data.username)}">
							{data.username}
						</a>
					</h1>
					<div class="mx-1"><!--spacer--></div>
					<RoleBadge roles={data.account.roles} size="large" />
				</div>
				<div class="hidden lg:flex items-center text-xs relative">
					<a
						style="color: var(--text-color);"
						href="/profile/{data.id}/{slugify(data.username)}/followers"
					>
						{abbreviate(data.stats.followers)} follower{pluralize(data.stats.followers)}
					</a>
					<span class="mx-1">•</span>
					<a
						style="color: var(--text-color);"
						href="/profile/{data.id}/{slugify(data.username)}/following"
					>
						{abbreviate(data.stats.following)} following
					</a>
					<span class="mx-1">•</span>
					<span>
						Joined <Time timestamp={data.createdAt} />
					</span>
				</div>
			</div>
			<div class="flex items-center bg-zinc-300 dark:bg-zinc-600 rounded-xl p-1">
				{#if $account.account && $account.currProfile}
					{#if $account.currProfile.id !== data.id}
						{#if hasFollowed.isFollowing}
							<Button
								on:click={unfollowUser}
								loading={loadingFollow}
								loadingText="Saving..."
							>
								<UserUnfollowLine class="button-icon variable-text" />
								<span class="button-text hidden lg:block">Unfollow</span>
							</Button>
						{:else}
							<Button
								on:click={followUser}
								loading={loadingFollow}
								loadingText="Saving..."
							>
								<UserFollowLine class="button-icon variable-text" />
								<span class="button-text hidden lg:block">Follow</span>
							</Button>
						{/if}
						<div class="mx-0.5"><!--spacer--></div>
					{/if}
					<Dropdown>
						<svelte:fragment slot="button">
							<More2Fill class="button-icon no-text" size="20px" />
						</svelte:fragment>
						<svelte:fragment slot="items">
							{#if $account.currProfile.id !== data.id}
								<button on:click={reportUser}>
									<AlarmWarningLine class="mr-2" size="18px" />
									<span>Report</span>
								</button>
							{/if}
						</svelte:fragment>
					</Dropdown>
				{:else}
					<Button disabled>
						<UserFollowLine class="button-icon variable-text" />
						<span class="button-text hidden lg:block">Follow</span>
					</Button>
					<div class="mx-0.5"><!--spacer--></div>
					<Button disabled>
						<More2Fill class="button-icon no-text" size="20px" />
					</Button>
				{/if}
			</div>
		</div>
		<div class="tool-bar lg:border-t-2 border-zinc-300 dark:border-zinc-600 lg:mt-4">
			<div class="flex items-center lg:hidden">
				<h1 class="text-4xl">
					<a href="/profile/{data.id}/{slugify(data.username)}">
						{data.username}
					</a>
				</h1>
			</div>
			<div class="flex items-center lg:hidden text-xs relative">
				<a
					style="color: var(--text-color);"
					href="/profile/{data.id}/{slugify(data.username)}/followers"
				>
					{abbreviate(data.stats.followers)} follower{pluralize(data.stats.followers)}
				</a>
				<span class="mx-1">•</span>
				<a
					style="color: var(--text-color);"
					href="/profile/{data.id}/{slugify(data.username)}/following"
				>
					{abbreviate(data.stats.following)} following
				</a>
				<div class="flex-1"><!--spacer--></div>
				<span>
					Joined <Time timestamp={data.createdAt} />
				</span>
			</div>
			<div
				class="flex flex-col lg:flex-row px-3 py-2 my-4 lg:my-0 bg-zinc-300 dark:bg-zinc-600 lg:max-h-[85px] lg:max-w-[600px] rounded-xl"
			>
				<div class="lg:min-w-[250px] mb-2 lg:mb-0">
					<div class="flex items-center">
						<InformationLine size="20px" class="mr-1" />
						<span
							class="all-small-caps font-bold tracking-wider relative -top-0.5 text-lg"
						>
							About Me
						</span>
					</div>
					<div class="markdown-text">
						<SvelteMarkdown source={data.info.bio} />
					</div>
				</div>
				{#if Object.keys(data.links).length !== 0}
					<div class="lg:ml-2 lg:pl-2 lg:border-l-2 border-zinc-400 dark:border-zinc-500">
						<div class="flex items-center">
							<LinksFill size="20px" class="mr-1" />
							<span class="all-small-caps font-bold tracking-wider text-lg">
								Links
							</span>
						</div>
						<div class="flex items-center flex-wrap">
							{#each Object.keys(data.links) as key}
								<LinkTag kind={key} href={data.links[key]} />
							{/each}
						</div>
					</div>
				{/if}
			</div>
			<div class="flex-1"><!--spacer--></div>
			<div
				class="flex items-center justify-center lg:ml-4 w-full lg:w-fit self-end bg-zinc-300 dark:bg-zinc-600 rounded-xl overflow-hidden"
			>
				<a
					class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500"
					href="/profile/{data.id}/{slugify(data.username)}/works"
					class:active={$page.url.pathname.includes("/works")}
				>
					<div class="stat">
						<QuillPenLine size="18.4px" class="mr-1" />
						<span class="select-none">{abbreviate(data.stats.works)}</span>
					</div>
					<div class="stat-label">Work{pluralize(data.stats.works)}</div>
				</a>
				<a
					class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500"
					href="/profile/{data.id}/{slugify(data.username)}/blogs"
					class:active={$page.url.pathname.includes("/blogs")}
				>
					<div class="stat">
						<CupLine size="18.4px" class="mr-1" />
						<span class="select-none">{abbreviate(data.stats.blogs)}</span>
					</div>
					<div class="stat-label">Blog{pluralize(data.stats.blogs)}</div>
				</a>
				<a
					class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500"
					href="/profile/{data.id}/{slugify(data.username)}/shelves"
					class:active={$page.url.pathname.includes("/shelves")}
				>
					<div class="relative top-0.5 flex flex-col items-center">
						<div class="stat">
							<BarChart2Line size="18.4px" />
						</div>
						<div class="stat-label">Shelves</div>
					</div>
				</a>
			</div>
		</div>
	</div>
	<slot />
</div>

<style lang="scss">
	div.profile-header {
		@apply grid xl:rounded-xl relative w-full mb-6 xl:mt-6 overflow-hidden;
		grid-template-areas:
			"banner banner"
			"avatar user"
			"action action";
		grid-template-rows: 1fr auto auto;
		grid-template-columns: auto 1fr;
		div.avatar {
			grid-area: banner / banner / avatar / avatar;
			display: flex;
			align-items: flex-end;
			@apply p-4 pb-0 relative z-[2] items-end justify-self-start;
		}
		div.banner {
			background: var(--accent);
			grid-area: banner;
			@apply relative;
		}
		div.user {
			grid-area: user;
			@apply p-4 pb-0 pl-0 flex items-center z-[2] relative;
		}
		div.tool-bar {
			grid-area: action;
			@apply flex flex-col lg:flex-row lg:items-center px-4 pb-4 lg:pt-4 flex-wrap;
		}
	}
	div.big-art {
		@apply h-[200px] lg:h-[250px];
	}
	div.small-art {
		@apply h-[100px] lg:h-[150px];
	}
	a.stat-box {
		@apply block cursor-pointer flex flex-col items-center select-none no-underline p-4 w-1/3 h-[65px] transition;
		color: var(--text-color);
		div.stat {
			@apply flex items-center relative -top-0.5;
		}
		div.stat-label {
			@apply text-xs uppercase font-bold tracking-wider relative -top-0.5;
		}
		&.active {
			@apply text-white;
			background: var(--accent);
		}
	}
	:global(div.markdown-text) {
		:global(p) {
			margin: 0 !important;
		}
	}
</style>
