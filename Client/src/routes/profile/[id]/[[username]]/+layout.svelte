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
		ArrowRightSLine,
		HistoryLine,
		QuestionAnswerLine,
		BookmarkLine,
		SendPlaneLine,
		EditCircleLine,
		UserSettingsLine
	} from "svelte-remixicon";
	import { page } from "$app/stores";
	import { RoleBadge } from "$lib/ui/util";
	import { slugify } from "$lib/util/functions";
	import { Button } from "$lib/ui/util";
	import { account } from "$lib/state/account.state";
	import type { Profile } from "$lib/models/accounts";
	import { openPopup } from "$lib/ui/popup";
	import { UploadAvatar, UploadProfileCover } from "$lib/ui/upload";
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

	function updateAvatar() {
		openPopup(UploadAvatar, {
			onConfirm(value: Profile) {
				$account.currProfile = value;
				$account.profiles = $account.profiles.map((item) => {
					return item.id === value.id ? value : item;
				});
				data = value;
			}
		});
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

<div class="flex flex-col lg:flex-row">
	<div class="profile-details bg-zinc-200 dark:bg-zinc-700">
		<div class="profile-header">
			<div class="avatar">
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
			<div class="banner {data.bannerArt ? 'big-art' : 'small-art'}">
				{#if data.bannerArt}
					<img src={data.bannerArt} alt="cover art" class="w-full h-full object-cover" />
				{/if}
				<div class="absolute top-2 right-2 z-[2]">
					<div class="relative top-0.5 flex items-center">
						<div>
							<RoleBadge roles={data.account.roles} size="large" />
						</div>
					</div>
				</div>
			</div>
			<div class="user">
				<div class="flex-1"><!--spacer--></div>
				<div class="flex items-center bg-zinc-300 dark:bg-zinc-600 rounded-xl p-1">
					{#if $account.account && $account.currProfile}
						{#if $account.currProfile.id !== data.id}
							{#if hasFollowed.isFollowing}
								<Button
									on:click={unfollowUser}
									loading={loadingFollow}
									loadingText="Saving..."
									title="Unfollow"
								>
									<UserUnfollowLine class="button-icon no-text" />
								</Button>
							{:else}
								<Button
									on:click={followUser}
									loading={loadingFollow}
									loadingText="Saving..."
									title="Follow"
								>
									<UserFollowLine class="button-icon no-text" />
								</Button>
							{/if}
							<div class="mx-0.5" />
						{/if}
						<Dropdown>
							<svelte:fragment slot="button">
								<More2Fill class="button-icon no-text" size="20px" />
							</svelte:fragment>
							<svelte:fragment slot="items">
								{#if $account.currProfile.id !== data.id}
									<button>
										<SendPlaneLine class="mr-2" size="18px" />
										<span>Send Message</span>
									</button>
									<button on:click={reportUser}>
										<AlarmWarningLine class="mr-2" size="18px" />
										<span>Report</span>
									</button>
								{:else}
									<button on:click={updateAvatar}>
										<EditCircleLine class="mr-2" size="18px" />
										<span>Edit Avatar</span>
									</button>
									<button on:click={updateBanner}>
										{#if data.bannerArt}
											<ImageEditLine class="mr-2" size="18px" />
											<span>Edit Banner Art</span>
										{:else}
											<ImageAddLine class="mr-2" size="18px" />
											<span>Add Banner Art</span>
										{/if}
									</button>
								{/if}
							</svelte:fragment>
						</Dropdown>
					{:else}
						<Button disabled title="Follow">
							<UserFollowLine class="button-icon no-text" />
						</Button>
						<div class="mx-0.5" />
						<Button disabled title="More">
							<More2Fill class="button-icon no-text" size="20px" />
						</Button>
					{/if}
				</div>
			</div>
			<div class="tool-bar border-zinc-300 dark:border-zinc-600">
				<div class="flex items-center">
					<h1 class="text-3xl">
						<a href="/profile/{data.id}/{slugify(data.username)}">
							{data.username}
						</a>
					</h1>
				</div>
				<div class="flex items-center text-xs relative">
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
					<div class="flex-1" />
					<span>
						Joined <Time timestamp={data.createdAt} />
					</span>
				</div>
				<div class="flex flex-col my-4 rounded-xl">
					<div class="mb-2.5">
						<div class="markdown-text">
							<SvelteMarkdown source={data.info.bio} />
						</div>
					</div>
					{#if Object.keys(data.links).length !== 0}
						<div class="border-zinc-400 dark:border-zinc-500">
							<div class="flex items-center flex-wrap">
								{#each Object.keys(data.links) as key}
									<LinkTag kind={key} href={data.links[key]} />
								{/each}
							</div>
						</div>
					{/if}
				</div>
				<div class="flex-1" />
				<div
					class="flex lg:flex-col lg:items-start lg:justify-start items-center justify-center w-full self-end bg-zinc-300 dark:bg-zinc-600 rounded-xl overflow-hidden"
				>
					<a
						class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500 group"
						href="/profile/{data.id}/{slugify(data.username)}/works"
						class:active={$page.url.pathname.includes("/works")}
					>
						<div class="stat">
							<QuillPenLine
								class="mr-1 lg:mr-0 w-[18.4px] h-[18.4px] lg:w-[22px] lg:h-[22px]"
							/>
							<span class="select-none lg:hidden">
								{abbreviate(data.stats.works)}
							</span>
						</div>
						<div class="stat-label">
							<span class="select-none mr-1.5 hidden lg:block">
								{abbreviate(data.stats.works)}
							</span>
							Work{pluralize(data.stats.works)}
						</div>
						<div
							class="stat-caret text-zinc-400 dark:text-zinc-500 group-hover:text-white"
						>
							<ArrowRightSLine size="22px" />
						</div>
					</a>
					<a
						class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500 group"
						href="/profile/{data.id}/{slugify(data.username)}/blogs"
						class:active={$page.url.pathname.includes("/blogs")}
					>
						<div class="stat">
							<CupLine
								class="mr-1 lg:mr-0 w-[18.4px] h-[18.4px] lg:w-[22px] lg:h-[22px]"
							/>
							<span class="select-none lg:hidden">
								{abbreviate(data.stats.blogs)}
							</span>
						</div>
						<div class="stat-label">
							<span class="select-none mr-1.5 hidden lg:block">
								{abbreviate(data.stats.blogs)}
							</span>
							Blog{pluralize(data.stats.blogs)}
						</div>
						<div
							class="stat-caret text-zinc-400 dark:text-zinc-500 group-hover:text-white"
						>
							<ArrowRightSLine size="22px" />
						</div>
					</a>
					<a
						class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500 group"
						href="/profile/{data.id}/{slugify(data.username)}/shelves"
						class:active={$page.url.pathname.includes("/shelves")}
					>
						<div
							class="relative top-0.5 lg:top-0 lg:w-full flex flex-col lg:flex-row items-center"
						>
							<div class="stat">
								<BarChart2Line
									class="w-[18.4px] h-[18.4px] lg:w-[22px] lg:h-[22px]"
								/>
							</div>
							<div class="stat-label">Shelves</div>
							<div
								class="stat-caret text-zinc-400 dark:text-zinc-500 group-hover:text-white"
							>
								<ArrowRightSLine size="22px" />
							</div>
						</div>
					</a>
				</div>
				{#if $account.currProfile && $account.currProfile.id === data.id}
					<div
						class="hidden lg:flex flex-col w-full bg-zinc-300 dark:bg-zinc-600 rounded-xl mt-4 overflow-hidden"
					>
						<a
							class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500 group"
							href="/profile/{data.id}/{slugify(data.username)}/library"
							class:active={$page.url.pathname.includes("/library")}
						>
							<div class="stat">
								<BookmarkLine
									class="mr-1 lg:mr-0 w-[18.4px] h-[18.4px] lg:w-[22px] lg:h-[22px]"
								/>
							</div>
							<div class="stat-label">Library</div>
							<div
								class="stat-caret text-zinc-400 dark:text-zinc-500 group-hover:text-white"
							>
								<ArrowRightSLine size="22px" />
							</div>
						</a>
						<a
							class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500 group"
							href="/profile/{data.id}/{slugify(data.username)}/messages"
							class:active={$page.url.pathname.includes("/messages")}
						>
							<div class="stat">
								<QuestionAnswerLine
									class="mr-1 lg:mr-0 w-[18.4px] h-[18.4px] lg:w-[22px] lg:h-[22px]"
								/>
							</div>
							<div class="stat-label">Messages</div>
							<div
								class="stat-caret text-zinc-400 dark:text-zinc-500 group-hover:text-white"
							>
								<ArrowRightSLine size="22px" />
							</div>
						</a>
						<a
							class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500 group"
							href="/profile/{data.id}/{slugify(data.username)}/reading-history"
							class:active={$page.url.pathname.includes("/reading-history")}
						>
							<div class="stat">
								<HistoryLine
									class="mr-1 lg:mr-0 w-[18.4px] h-[18.4px] lg:w-[22px] lg:h-[22px]"
								/>
							</div>
							<div class="stat-label">Reading History</div>
							<div
								class="stat-caret text-zinc-400 dark:text-zinc-500 group-hover:text-white"
							>
								<ArrowRightSLine size="22px" />
							</div>
						</a>
					</div>
					<div
						class="hidden lg:flex flex-col w-full bg-zinc-300 dark:bg-zinc-600 rounded-xl mt-4 overflow-hidden"
					>
						<a
							class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500 group"
							href="/profile/{data.id}/{slugify(data.username)}/settings"
							class:active={$page.url.pathname.includes("/settings")}
						>
							<div class="stat">
								<UserSettingsLine
									class="mr-1 lg:mr-0 w-[18.4px] h-[18.4px] lg:w-[22px] lg:h-[22px]"
								/>
							</div>
							<div class="stat-label">Settings</div>
							<div
								class="stat-caret text-zinc-400 dark:text-zinc-500 group-hover:text-white"
							>
								<ArrowRightSLine size="22px" />
							</div>
						</a>
					</div>
				{/if}
			</div>
		</div>
	</div>
	<div class="w-full lg:mx-6 my-6">
		<slot />
	</div>
</div>

<style lang="scss">
	div.profile-details {
		@apply w-full lg:min-w-[350px] lg:max-w-[350px] lg:h-[calc(100vh-60px)] lg:sticky top-0 lg:overflow-hidden lg:overflow-y-scroll;

		div.profile-header {
			@apply grid relative w-full overflow-hidden;
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
				image-rendering: crisp-edges;
				@apply relative;
				&.big-art {
					@apply h-[175px];
				}
				&.small-art {
					@apply h-[100px];
				}
			}
			div.user {
				grid-area: user;
				@apply p-4 pb-0 pl-0 flex items-center z-[2] relative;
			}
			div.tool-bar {
				grid-area: action;
				@apply flex flex-col px-4 pb-4 pt-2 flex-wrap;
				a.stat-box {
					@apply cursor-pointer flex flex-col lg:flex-row items-center select-none no-underline p-4 w-1/3 lg:w-full h-[65px] lg:h-[50px] transition lg:border-b lg:border-zinc-500 lg:last:border-0;
					color: var(--text-color);
					div.stat {
						@apply flex items-center relative -top-0.5 lg:top-0 lg:mr-2;
						font-family: var(--header-text);
					}
					div.stat-label {
						@apply text-xs uppercase font-bold tracking-wider relative flex items-center lg:top-0.5 lg:text-base lg:normal-case lg:font-normal lg:tracking-normal lg:flex-1;
						font-family: var(--header-text);
					}
					div.stat-caret {
						@apply hidden lg:block;
					}
					&.active {
						@apply text-white;
						background: var(--accent);
						div.stat-caret {
							@apply text-white;
						}
					}
				}
				:global(div.markdown-text) {
					:global(p) {
						margin: 0 !important;
					}
				}
			}
		}
	}
</style>
