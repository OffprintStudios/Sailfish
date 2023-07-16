<script lang="ts">
	import { computePosition, flip, offset, shift } from "@floating-ui/dom";
	import { navigating } from "$app/stores";
	import Button from "$lib/ui/util/Button.svelte";
	import {
		ArrowLeftRightLine,
		Settings5Line,
		LogoutCircleLine,
		BookLine,
		CupLine,
		ArrowRightSLine,
		ArrowDownSLine,
		Link,
		EyeLine,
		QuillPenLine
	} from "svelte-remixicon";
	import { slide } from "svelte/transition";
	import { abbreviate, clickOutside, slugify } from "$lib/util/functions";
	import { account } from "$lib/state/account.state";
	import { Avatar, RoleBadge } from "$lib/ui/util";

	export let open = false;

	let button: HTMLButtonElement;
	let dropdown: HTMLDivElement;
	let profileSwitcherOpen = false;

	function switchState() {
		open = !open;
	}

	$: {
		if (button) {
			computePosition(button, dropdown, {
				placement: "bottom-start",
				middleware: [offset({ mainAxis: 16 }), flip(), shift()]
			})
				.then(({ x, y }) => {
					Object.assign(dropdown.style, {
						left: `${x}px`,
						top: `${y}px`
					});
				})
				.catch(() => {
					console.log(`Button not yet assigned!`);
				});
		}

		if ($navigating !== null) {
			open = false;
		}
	}
</script>

<div class="relative z-[2]">
	<Button on:click={switchState} bind:thisButton={button} isActive={open} kind="primary">
		{#if $account.account && $account.currProfile}
			<Avatar src={$account.currProfile.avatar} size="36px" borderWidth="1px" />
		{:else if $account.account}
			<ArrowLeftRightLine class="button-icon no-text -rotate-45" size="24px" />
		{/if}
	</Button>
	{#if open}
		<div
			class="account-dropdown bg-zinc-200 dark:bg-zinc-700"
			transition:slide={{ delay: 0, duration: 150 }}
			bind:this={dropdown}
			use:clickOutside
			on:outclick={switchState}
		>
			{#if $account.account && $account.currProfile}
				<div class="account-dropdown-section bg-zinc-300 dark:bg-zinc-600">
					<div class="h-[6rem] overflow-hidden w-full relative">
						{#if $account.currProfile.bannerArt !== null && $account.currProfile.bannerArt !== undefined}
							<img
								src={$account.currProfile.bannerArt}
								class="h-full w-full object-cover"
								alt="profile avatar"
							/>
						{:else}
							<div class="h-full w-full absolute" style="background: var(--accent);">
								<!--intentionally left blank-->
							</div>
						{/if}
					</div>
					<div class="flex items-center px-4 my-2">
						<Avatar src={$account.currProfile.avatar} size="72px" borderWidth="1px" />
						<div class="ml-2">
							<a
								class="text-ellipsis overflow-hidden"
								href="/profile/{$account.currProfile.id}/{slugify(
									$account.currProfile.username
								)}"
							>
								<h3 class="text-2xl">{$account.currProfile.username}</h3>
							</a>
							<RoleBadge roles={$account.account.roles} size="large" />
						</div>
					</div>
					<div
						class="w-full flex items-center justify-center border-t border-zinc-300 dark:border-zinc-500 mt-0.5"
					>
						<a
							class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500"
							href="/profile/{$account.currProfile.id}/{slugify(
								$account.currProfile.username
							)}/works"
						>
							<div class="stat">
								<QuillPenLine size="18.4px" class="mr-1" />
								<span class="select-none"
									>{abbreviate($account.currProfile.stats.works)}</span
								>
							</div>
							<div class="stat-label">Works</div>
						</a>
						<a
							class="stat-box border-l border-r border-zinc-300 dark:border-zinc-500 hover:bg-zinc-400 dark:hover:bg-zinc-500"
							href="/profile/{$account.currProfile.id}/{slugify(
								$account.currProfile.username
							)}/blogs"
						>
							<div class="stat">
								<CupLine size="18.4px" class="mr-1" />
								<span class="select-none"
									>{abbreviate($account.currProfile.stats.blogs)}</span
								>
							</div>
							<div class="stat-label">Blogs</div>
						</a>
						<a
							class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500"
							href="/profile/{$account.currProfile.id}/{slugify(
								$account.currProfile.username
							)}/followers"
						>
							<div class="stat">
								<EyeLine size="18.4px" class="mr-1" />
								<span class="select-none"
									>{abbreviate($account.currProfile.stats.followers)}</span
								>
							</div>
							<div class="stat-label">Follows</div>
						</a>
					</div>
				</div>
				<div class="account-dropdown-section bg-zinc-300 dark:bg-zinc-600">
					<a
						class="account-dropdown-button group"
						href="/profile/{$account.currProfile.id}/{slugify(
							$account.currProfile.username
						)}/works/new"
					>
						<BookLine size="24px" class="mr-2" />
						<span>Create New Work</span>
						<Link
							size="18px"
							class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
						/>
					</a>
					<a
						class="account-dropdown-button group"
						href="/profile/{$account.currProfile.id}/{slugify(
							$account.currProfile.username
						)}/blogs/new"
					>
						<CupLine size="24px" class="mr-2" />
						<span>Create New Blog</span>
						<Link
							size="18px"
							class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
						/>
					</a>
				</div>
				<div class="account-dropdown-section bg-zinc-300 dark:bg-zinc-600">
					<button class="account-dropdown-button group">
						<ArrowLeftRightLine size="24px" class="mr-2" />
						<span>Switch Profile</span>
						<ArrowDownSLine
							size="18px"
							class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
						/>
					</button>
				</div>
			{:else if $account.account}
				<div class="px-4 mb-2">
					<h5 class="text-xl justify-self-start">Select Profile</h5>
					<div class="flex items-center justify-center">
						{#each $account.profiles as profile}
							<button
								class="profile-button"
								on:click={() => ($account.currProfile = profile)}
							>
								<Avatar src={profile.avatar} size="72px" borderWidth="1px" />
								<span>{profile.username}</span>
							</button>
						{/each}
						{#if $account.profiles.length < 3}
							<button class="profile-button">
								<span
									class="w-[72px] h-[72px] text-6xl font-extralight rounded-full border-2 border-dashed"
								>
									<span class="relative top-1"> + </span>
								</span>
								<span>Add</span>
							</button>
						{/if}
					</div>
				</div>
			{/if}
			<div class="account-dropdown-section bg-zinc-300 dark:bg-zinc-600">
				<button class="account-dropdown-button group">
					<Settings5Line size="24px" class="mr-2" />
					<span>Settings</span>
					<ArrowRightSLine
						size="18px"
						class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
					/>
				</button>
				<button class="account-dropdown-button group">
					<LogoutCircleLine size="24px" class="mr-2" />
					<span>Log Out</span>
					<ArrowRightSLine
						size="18px"
						class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
					/>
				</button>
			</div>
		</div>
	{/if}
</div>

<style lang="scss">
	div.account-dropdown {
		@apply absolute rounded-2xl z-50 p-2 flex flex-col lg:w-[375px] overflow-hidden;
		box-shadow: var(--dropshadow);
		font-family: var(--header-text);
		div.account-dropdown-section {
			@apply flex flex-col w-full rounded-xl overflow-hidden my-2 first:mt-0 last:mb-0;
		}
		button.account-dropdown-button,
		a.account-dropdown-button {
			@apply flex items-center w-full px-4 py-3 transition no-underline hover:bg-zinc-400 dark:hover:bg-zinc-500 border-b border-zinc-500 last:border-0;
			color: var(--text-color);
			span {
				@apply text-base relative top-0.5 flex-1 text-left;
			}
		}
		button.profile-button {
			@apply flex flex-col items-center justify-center p-2 rounded-xl transition mx-0.5 first:ml-0 last:mr-0;
			span {
				@apply mt-1;
			}
		}
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
	}
</style>
