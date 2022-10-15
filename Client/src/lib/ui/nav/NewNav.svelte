<script lang="ts">
	import { computePosition, flip, offset, shift } from "@floating-ui/dom";
	import { clickOutside, slugify, abbreviate } from "../../util/functions";
	import { slide } from 'svelte/transition';
	import {
		ArrowDownSLine,
		SearchEyeLine,
		User5Line,
		GroupLine,
		BarChart2Line,
		QuillPenLine,
		CupLine,
		EyeLine,
		Notification3Line,
		ArrowLeftRightLine,
		LogoutCircleRLine,
		Settings3Line,
	} from "svelte-remixicon";
	import { DEFAULT_SLOGANS } from '$lib/util/constants';
	import { openPopup } from "../popup";
	import { FormContainer, LogOutAlert, SelectProfileContainer } from "../auth";
	import { account } from "../../state/account.state";
	import { Avatar } from "../util";
	import RoleBadge from "$lib/ui/util/RoleBadge.svelte";
	import toast from "svelte-french-toast";

	let currSlogan = DEFAULT_SLOGANS[Math.floor(Math.random() * DEFAULT_SLOGANS.length)];
	const iconSize = "28px";
	const accountDropdownIconSize = "24px";

	let exploreButton: HTMLButtonElement = null;
	let exploreDropdown: HTMLDivElement = null;
	let exploreOpen = false;

	let accountButton: HTMLButtonElement = null;
	let accountDropdown: HTMLDivElement = null;
	let accountOpen = false;

	function determineExploreOpenState() {
		exploreOpen = !exploreOpen;
	}

	function determineAccountOpenState() {
		accountOpen = !accountOpen;
	}

	$: {
		if (exploreButton) {
			computePosition(exploreButton, exploreDropdown, {
				placement: 'bottom-start',
				middleware: [offset({ mainAxis: 20 }), flip(), shift({ padding: 5 })]
			}).then(({ x, y }) => {
				Object.assign(exploreDropdown.style, {
					left: `${x}px`,
					top: `${y}px`
				})
			}).catch(() => {
				console.log("Explore button not yet assigned!");
			})
		}
	}

	$: {
		if (accountButton) {
			computePosition(accountButton, accountDropdown, {
				placement: 'bottom-end',
				middleware: [offset({ mainAxis: 20 }), flip(), shift({ padding: 5 })]
			}).then(({ x, y }) => {
				Object.assign(accountDropdown.style, {
					left: `${x}px`,
					top: `${y}px`
				})
			}).catch(() => {
				console.log("Account button not yet assigned!");
			})
		}
	}

	async function logOut() {
		accountOpen = false;
		openPopup(LogOutAlert, {
			async onConfirm() {
				const response = await fetch(`/api/auth/log-out`, { method: 'GET' });
				if (response.status === 200) {
					toast.success("See you later!");
					$account.account = null;
					$account.currProfile = null;
					$account.profiles = [];
				} else {
					toast.error(`${response.status}: Something went wrong! Try again in a little bit.`);
				}
			}
		})
	}
</script>

<nav>
	<div class="w-1/4 flex items-center">
		<button
			class="nav-button"
			bind:this={exploreButton}
			on:click={determineExploreOpenState}
			class:active={exploreOpen}
		>
			<span class="mr-2">Explore</span>
			<ArrowDownSLine />
		</button>
		{#if exploreOpen}
			<div
				class="explore-dropdown bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
				bind:this={exploreDropdown}
				transition:slide|local="{{ delay: 0, duration: 100 }}"
				use:clickOutside
				on:outclick={determineExploreOpenState}
			>
				<div class="flex flex-col pr-2 border-r-2 border-zinc-300 dark:border-zinc-600">
					<a class="explore-option hover:bg-zinc-300 dark:hover:bg-zinc-600">Popular this week</a>
					<a class="explore-option hover:bg-zinc-300 dark:hover:bg-zinc-600">Popular today</a>
					<a class="explore-option hover:bg-zinc-300 dark:hover:bg-zinc-600">New works</a>
					<a class="explore-option hover:bg-zinc-300 dark:hover:bg-zinc-600">Fandoms</a>
					<a class="explore-option hover:bg-zinc-300 dark:hover:bg-zinc-600">Special events</a>
				</div>
			</div>
		{/if}
		<div class="mx-0.5"><!--spacer--></div>
		<button class="nav-button">
			<span>Groups</span>
		</button>
	</div>
	<div class="w-2/4 flex items-center justify-center">
		<a class="offprint-logo" href="/">
			<img
				src="/images/logo.png"
				alt="offprint logo"
				class="max-w-[8rem] lg:max-w-[14rem] mx-auto"
			/>
			<h2 class="text-white font-light leading-4 lg:block hidden all-small-caps text-[1.25rem]">
				{currSlogan}
			</h2>
		</a>
	</div>
	<div class="w-1/4 flex items-center">
		<div class="flex-1"></div>
		<a class="nav-button icon-only" href="/search" title="Search">
			<SearchEyeLine size={iconSize} />
		</a>
		<div class="mx-0.5"><!--spacer--></div>
		{#if $account.account && $account.currProfile}
			<a class="nav-button icon-only" href="/library" title="Library & Watchlists">
				<BarChart2Line size={iconSize} />
			</a>
			<div class="mx-0.5"><!--spacer--></div>
			<button class="nav-button icon-only" title="Activity">
				<Notification3Line size={iconSize} />
			</button>
			<div class="mx-0.5"><!--spacer--></div>
			<button
				class="nav-button avatar"
				title="User Settings"
				bind:this={accountButton}
				on:click={determineAccountOpenState}
				class:active={accountOpen}
			>
				<Avatar src={$account.currProfile.avatar} size="46px" borderWidth="1px" />
				<ArrowDownSLine />
			</button>
			{#if accountOpen}
				<div
					class="account-dropdown bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
					bind:this={accountDropdown}
					transition:slide|local="{{ delay: 0, duration: 100 }}"
					use:clickOutside
					on:outclick={determineAccountOpenState}
				>
					<div class="flex items-center pb-2">
						<Avatar src={$account.currProfile.avatar} size="64px" borderWidth="1px" />
						<div class="ml-2">
							<h4 class="text-2xl">
								<a class="text-ellipsis overflow-hidden" href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}">
									{$account.currProfile.username}
								</a>
							</h4>
							<RoleBadge roles={$account.account.roles} />
						</div>
					</div>
					<div class="w-full flex items-center justify-center border-t-2 border-b-2 border-zinc-300 dark:border-zinc-600 mt-0.5">
						<a
							class="stat-box hover:bg-zinc-300 dark:hover:bg-zinc-600"
							href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}/works"
						>
							<div class="stat">
								<QuillPenLine size="18.4px" class="mr-1" />
								<span class="select-none">{abbreviate($account.currProfile.stats.works)}</span>
							</div>
							<div class="stat-label">Works</div>
						</a>
						<a
							class="stat-box border-l-2 border-r-2 border-zinc-300 dark:border-zinc-600 hover:bg-zinc-300 dark:hover:bg-zinc-600"
							href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}/blogs"
						>
							<div class="stat">
								<CupLine size="18.4px" class="mr-1" />
								<span class="select-none">{abbreviate($account.currProfile.stats.blogs)}</span>
							</div>
							<div class="stat-label">Blogs</div>
						</a>
						<a
							class="stat-box hover:bg-zinc-300 dark:hover:bg-zinc-600"
							href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}/followers"
						>
							<div class="stat">
								<EyeLine size="18.4px" class="mr-1" />
								<span class="select-none">{abbreviate($account.currProfile.stats.followers)}</span>
							</div>
							<div class="stat-label">Follows</div>
						</a>
					</div>
					<div class="flex flex-col mt-2">
						<a href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}/works" class="account-dropdown-button hover:bg-zinc-300 dark:hover:bg-zinc-600">
							<QuillPenLine size={accountDropdownIconSize} />
							<span>Create Work</span>
						</a>
						<a href="/profile/{$account.currProfile.id}/{slugify($account.currProfile.username)}/blogs" class="account-dropdown-button hover:bg-zinc-300 dark:hover:bg-zinc-600">
							<CupLine size={accountDropdownIconSize} />
							<span>Create Blog</span>
						</a>
						<div class="border-b-2 w-full border-zinc-300 dark:border-zinc-600 my-2"></div>
						<button class="account-dropdown-button hover:bg-zinc-300 dark:hover:bg-zinc-600"  on:click={() => { openPopup(SelectProfileContainer); accountOpen = false; }}>
							<ArrowLeftRightLine size={accountDropdownIconSize} />
							<span>Switch profile</span>
						</button>
						<a href="/settings" class="account-dropdown-button hover:bg-zinc-300 dark:hover:bg-zinc-600">
							<Settings3Line size={accountDropdownIconSize} />
							<span>Settings</span>
						</a>
						<div class="border-b-2 w-full border-zinc-300 dark:border-zinc-600 my-2"></div>
						<button class="account-dropdown-button hover:bg-zinc-300 dark:hover:bg-zinc-600" on:click={logOut}>
							<LogoutCircleRLine size={accountDropdownIconSize} />
							<span>Log out</span>
						</button>
					</div>
				</div>
			{/if}
		{:else if $account.account}
			<button class="nav-button icon-only" title="Select Profile" on:click={() => { openPopup(SelectProfileContainer); accountOpen = false; }}>
				<GroupLine size={iconSize} />
			</button>
		{:else}
			<button class="nav-button icon-only" title="Log in or Sign up" on:click={() => openPopup(FormContainer)}>
				<User5Line size={iconSize} />
			</button>
		{/if}
	</div>
</nav>

<style lang="scss">
	nav {
		@apply flex items-center w-full lg:max-w-7xl mx-auto px-3 lg:rounded-b-xl mb-6 py-2;
		background: var(--accent);
		div.explore-dropdown {
			@apply absolute rounded-xl px-2 py-2 z-50;
			box-shadow: var(--dropshadow);
			a.explore-option {
				@apply px-4 py-3 flex items-center hover:no-underline rounded-xl transition text-base;
				color: var(--text-color);
			}
		}
		div.account-dropdown {
			@apply absolute rounded-xl px-2 py-2 z-50;
			box-shadow: var(--dropshadow);
			a.stat-box {
				@apply block cursor-pointer flex flex-col items-center select-none no-underline p-4 w-1/3 transition transform;
				color: var(--text-color);
				div.stat {
					@apply flex items-center;
				}
				div.stat-label {
					@apply text-xs uppercase font-bold tracking-wider;
				}
			}
			button.account-dropdown-button, a.account-dropdown-button {
				@apply flex items-center block no-underline px-4 py-3 w-full rounded-lg;
				color: var(--text-color);
				span {
					@apply ml-2 flex-1 text-left;
				}
			}
		}
		a.offprint-logo {
			@apply flex flex-col items-center justify-center rounded-xl px-2 pt-1 pb-1.5 transition transform hover:no-underline;
			&:hover {
				background: var(--accent-light);
			}
		}
		a.nav-button, button.nav-button {
			@apply flex items-center text-[1.15rem] text-white px-2 py-4 rounded-xl transition transform hover:no-underline;
			font-family: var(--header-text);
			&.icon-only {
				@apply px-4;
			}
			&.avatar {
				@apply pl-2 pr-0.5 py-2;
			}
			&:hover, &.active {
				background: var(--accent-light);
			}
			span {
				@apply relative top-0.5;
			}
		}
	}
</style>