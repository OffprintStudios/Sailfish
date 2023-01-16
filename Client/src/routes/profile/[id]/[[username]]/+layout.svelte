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
	import UpdateLinksPrompt from "./UpdateLinksPrompt.svelte";
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

	function updateLinks() {
		openPopup(
			UpdateLinksPrompt,
			{
				onConfirm: async (value: Map<string, string>) => {
					console.log(value);
				}
			},
			{ links: data.links }
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

<div
	class="w-11/12 mx-auto my-6 max-w-7xl relative justify-items-start grid grid-cols-1 lg:grid-cols-3 xl:gap-12"
>
	<div
		class="profile-block lg:sticky lg:top-6 col-span-1 w-full h-fit bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
	>
		<div class="h-32 overflow-hidden w-full relative">
			{#if data.bannerArt !== null && data.bannerArt !== undefined}
				<img src={data.bannerArt} class="h-full w-full object-cover" alt="profile avatar" />
			{:else}
				<div class="h-full w-full" style="background: var(--accent);">
					<!--intentionally left blank-->
				</div>
			{/if}
		</div>
		<div class="relative flex items-center p-2">
			<div class="absolute -bottom-0">
				<div
					class="w-[115px] h-[115px] border-4 border-zinc-300 dark:border-zinc-600 rounded-full bg-zinc-300 dark:bg-zinc-600 overflow-hidden"
				>
					<img
						src={data.avatar}
						alt="{data.username}'s Avatar"
						class="object-cover w-full h-full"
					/>
				</div>
			</div>
			<div class="flex-1"><!--spacer--></div>
			{#if $account.account && $account.currProfile}
				{#if $account.currProfile.id !== data.id}
					{#if hasFollowed.isFollowing}
						<Button
							on:click={unfollowUser}
							loading={loadingFollow}
							loadingText="Saving..."
						>
							<UserUnfollowLine class="button-icon" />
							<span class="button-text">Unfollow</span>
						</Button>
					{:else}
						<Button
							on:click={followUser}
							loading={loadingFollow}
							loadingText="Saving..."
						>
							<UserFollowLine class="button-icon" />
							<span class="button-text">Follow</span>
						</Button>
					{/if}
				{/if}
				<div class="mx-0.5"><!--spacer--></div>
				<Dropdown>
					<svelte:fragment slot="button">
						<More2Fill class="button-icon no-text" size="20px" />
					</svelte:fragment>
					<svelte:fragment slot="items">
						{#if $account.currProfile.id === data.id}
							{#if data.bannerArt}
								<button on:click={updateBanner}>
									<ImageEditLine class="mr-2" size="18px" />
									<span>Edit Banner</span>
								</button>
							{:else}
								<button on:click={updateBanner}>
									<ImageAddLine class="mr-2" size="18px" />
									<span>Add Banner</span>
								</button>
							{/if}
							<button on:click={updateLinks}>
								<Link class="mr-2" size="18px" />
								<span>Update Links</span>
							</button>
						{:else}
							<button on:click={reportUser}>
								<AlarmWarningLine class="mr-2" size="18px" />
								<span>Report</span>
							</button>
						{/if}
					</svelte:fragment>
				</Dropdown>
			{:else}
				<Button disabled>
					<UserFollowLine class="button-icon" />
					<span class="button-text">Follow</span>
				</Button>
				<div class="mx-0.5"><!--spacer--></div>
				<Button disabled>
					<More2Fill class="button-icon no-text" size="20px" />
				</Button>
			{/if}
		</div>
		<div class="pb-1 pt-1 px-4">
			<h4 class="text-3xl truncate">
				<a
					class="text-ellipsis overflow-hidden"
					href="/profile/{data.id}/{slugify(data.username)}"
				>
					{data.username}
				</a>
			</h4>
			<div class="flex items-center text-xs relative -top-1">
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
				<RoleBadge roles={data.account.roles} size="large" />
			</div>
		</div>
		<div
			class="w-full flex items-center justify-center border-t border-b border-zinc-300 dark:border-zinc-600 mt-0.5"
		>
			<a
				class="stat-box hover:bg-zinc-300 dark:hover:bg-zinc-600"
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
				class="stat-box border-l border-r border-zinc-300 dark:border-zinc-600 hover:bg-zinc-300 dark:hover:bg-zinc-600"
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
				class="stat-box hover:bg-zinc-300 dark:hover:bg-zinc-600"
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
		<div class="px-4 py-2 mx-4 my-4 bg-zinc-300 dark:bg-zinc-600 rounded-xl">
			<div class="mb-4">
				<div class="flex items-center">
					<Cake2Line size="20px" class="mr-1" />
					<span class="all-small-caps font-bold tracking-wider text-lg"> Joined </span>
				</div>
				<Time timestamp={data.createdAt} />
			</div>
			<div class="mt-4" class:mb-4={Object.keys(data.links).length > 0}>
				<div class="flex items-center">
					<InformationLine size="20px" class="mr-1" />
					<span class="all-small-caps font-bold tracking-wider text-lg"> About Me </span>
				</div>
				<div class="markdown-text pb-1">
					<SvelteMarkdown source={data.info.bio} />
				</div>
			</div>
			{#if Object.keys(data.links).length !== 0}
				<div class="mt-4">
					<div class="flex items-center">
						<LinksFill size="20px" class="mr-1" />
						<span class="all-small-caps font-bold tracking-wider text-lg"> Links </span>
					</div>
					<div class="flex items-center flex-wrap">
						{#each Object.keys(data.links) as key}
							<LinkTag kind={key} href={data.links[key]} />
						{/each}
					</div>
				</div>
			{/if}
		</div>
	</div>
	<div class="col-span-2 my-6 w-full">
		<slot />
	</div>
</div>

<style lang="scss">
	div.profile-block {
		@apply flex flex-col overflow-hidden rounded-xl;
	}
	a.stat-box {
		@apply block cursor-pointer flex flex-col items-center select-none no-underline p-4 w-1/3 h-[70px] transition;
		color: var(--text-color);
		div.stat {
			@apply flex items-center;
		}
		div.stat-label {
			@apply text-xs uppercase font-bold tracking-wider;
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
