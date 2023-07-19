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
		ArrowUpSLine,
		Link,
		EyeLine,
		QuillPenLine,
		ArrowLeftSLine,
		CheckLine,
		CloseLine,
		HistoryLine,
		BookmarkLine,
		SunLine,
		SunFill,
		MoonLine,
		MoonFill
	} from "svelte-remixicon";
	import { fade, slide, fly } from "svelte/transition";
	import { abbreviate, clickOutside, slugify, throttle } from "$lib/util/functions";
	import { account } from "$lib/state/account.state";
	import { Avatar, RoleBadge } from "$lib/ui/util";
	import type { Profile } from "$lib/models/accounts";
	import toast from "svelte-french-toast";
	import { activity } from "$lib/state/activity.state";
	import { ContentFilter, ThemePref } from "$lib/util/constants";
	import { app, setFilter, setOfAge, setTheme } from "$lib/state/app.state";
	import { Toggle } from "$lib/ui/forms";

	enum Panels {
		Home,
		QuickSettings,
		LogOut
	}

	export let open = false;

	let button: HTMLButtonElement;
	let dropdown: HTMLDivElement;
	let currPanel = Panels.Home;
	let profileSwitcherOpen = false;
	const themes = Object.entries(ThemePref).map(([key, value]) => ({ value: value, label: key }));
	let currTheme = themes.filter((theme) => {
		return theme.value === $app.theme;
	})[0];

	function toggleBrightness(value: string | null) {
		if (value === "dark") {
			$app.brightness = "dark";
			document.documentElement.classList.add("dark");
		} else {
			$app.brightness = null;
			document.documentElement.classList.remove("dark");
		}
	}

	let enableMature = false;
	let enableExplicit = false;

	if ($app.filter === ContentFilter.restricted) {
		enableMature = false;
		enableExplicit = false;
	} else if ($app.filter === ContentFilter.mature) {
		enableMature = true;
		enableExplicit = false;
	} else if ($app.filter === ContentFilter.explicit) {
		enableMature = false;
		enableExplicit = true;
	} else if ($app.filter === ContentFilter.everything) {
		enableMature = true;
		enableExplicit = true;
	}
	$: setFilter(enableMature, enableExplicit);

	function selectProfile(profile: Profile) {
		$account.currProfile = profile;
		profileSwitcherOpen = false;
	}
	function switchState() {
		open = !open;
		currPanel = Panels.Home;
	}

	let throttled = throttle(switchState, 150);

	function switchPanel(panel: Panels) {
		currPanel = panel;
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

	async function logOut() {
		const response = await fetch(`/api/auth/log-out?accountId=${$account.account?.id}`, {
			method: "POST"
		});
		if (response.status === 200) {
			toast.success("See you later!");
			$account.account = null;
			$account.currProfile = null;
			$account.profiles = [];
			$account.token = null;
			$activity.markAsRead = [];
			$activity.count = 0;
			open = false;
		} else {
			toast.error(`Something went wrong! Try again in a little bit.`);
		}
	}
</script>

<div class="relative z-[2]">
	<Button on:click={throttled} bind:thisButton={button} isActive={open} kind="primary">
		{#if $account.account && $account.currProfile}
			<Avatar src={$account.currProfile.avatar} size="36px" borderWidth="1px" />
		{:else if $account.account}
			<ArrowLeftRightLine class="button-icon no-text -rotate-45" size="24px" />
		{/if}
	</Button>
	{#if open}
		<div
			class="account-dropdown bg-zinc-200 dark:bg-zinc-700"
			transition:fly={{ delay: 0, duration: 150, x: 200 }}
			bind:this={dropdown}
			use:clickOutside
			on:outclick={throttled}
		>
			{#if currPanel === Panels.Home}
				{#if $account.account && $account.currProfile}
					<div transition:fade={{ delay: 0, duration: 150 }}>
						<div class="account-dropdown-section bg-zinc-300 dark:bg-zinc-600">
							<div class="h-[6rem] overflow-hidden w-full relative">
								{#if $account.currProfile.bannerArt !== null && $account.currProfile.bannerArt !== undefined}
									<img
										src={$account.currProfile.bannerArt}
										class="h-full w-full object-cover"
										alt="profile avatar"
									/>
								{:else}
									<div
										class="h-full w-full absolute"
										style="background: var(--accent);"
									>
										<!--intentionally left blank-->
									</div>
								{/if}
							</div>
							<div class="flex items-center px-4 my-2">
								<Avatar
									src={$account.currProfile.avatar}
									size="72px"
									borderWidth="1px"
								/>
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
								class="w-full flex items-center justify-center border-t border-zinc-400 dark:border-zinc-500 mt-0.5"
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
									class="stat-box border-l border-r border-zinc-400 dark:border-zinc-500 hover:bg-zinc-400 dark:hover:bg-zinc-500"
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
											>{abbreviate(
												$account.currProfile.stats.followers
											)}</span
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
							<a
								class="account-dropdown-button group"
								href="/profile/{$account.currProfile.id}/{slugify(
									$account.currProfile.username
								)}/library"
							>
								<BookmarkLine size="24px" class="mr-2" />
								<span>Library</span>
								<Link
									size="18px"
									class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
								/>
							</a>
							<a
								class="account-dropdown-button group"
								href="/profile/{$account.currProfile.id}/{slugify(
									$account.currProfile.username
								)}/reading-history"
							>
								<HistoryLine size="24px" class="mr-2" />
								<span>Reading History</span>
								<Link
									size="18px"
									class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
								/>
							</a>
						</div>
						<div class="account-dropdown-section bg-zinc-300 dark:bg-zinc-600">
							<button
								class="account-dropdown-button group"
								on:click={() => (profileSwitcherOpen = !profileSwitcherOpen)}
							>
								<ArrowLeftRightLine size="24px" class="mr-2" />
								<span>Switch Profile</span>
								{#if profileSwitcherOpen}
									<ArrowUpSLine
										size="18px"
										class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
									/>
								{:else}
									<ArrowDownSLine
										size="18px"
										class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
									/>
								{/if}
							</button>
							{#if profileSwitcherOpen}
								<div transition:slide={{ delay: 0, duration: 150 }}>
									<div class="flex items-center justify-center my-2">
										{#each $account.profiles as profile}
											<button
												class="profile-button"
												on:click={() => selectProfile(profile)}
											>
												<Avatar
													src={profile.avatar}
													size="72px"
													borderWidth="1px"
												/>
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
												<span>Add Profile</span>
											</button>
										{/if}
									</div>
								</div>
							{/if}
						</div>
					</div>
				{:else if $account.account}
					<div class="px-4 mb-2">
						<h5 class="text-xl justify-self-start">Select Profile</h5>
						<div class="flex items-center justify-center">
							{#each $account.profiles as profile}
								<button
									class="profile-button"
									on:click={() => selectProfile(profile)}
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
									<span>Add Profile</span>
								</button>
							{/if}
						</div>
					</div>
				{/if}
				<div class="account-dropdown-section bg-zinc-300 dark:bg-zinc-600">
					<button
						class="account-dropdown-button group"
						on:click={() => switchPanel(Panels.QuickSettings)}
					>
						<Settings5Line size="24px" class="mr-2" />
						<span>Settings</span>
						<ArrowRightSLine
							size="18px"
							class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
						/>
					</button>
					<button
						class="account-dropdown-button group"
						on:click={() => switchPanel(Panels.LogOut)}
					>
						<LogoutCircleLine size="24px" class="mr-2" />
						<span>Log Out</span>
						<ArrowRightSLine
							size="18px"
							class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
						/>
					</button>
				</div>
			{:else if currPanel === Panels.QuickSettings}
				<div in:fade={{ delay: 0, duration: 150 }}>
					<div class="mb-1">
						<Button on:click={() => switchPanel(Panels.Home)}>
							<ArrowLeftSLine class="button-icon" />
							<span class="button-text">Back</span>
						</Button>
					</div>
					<h5 class="ml-2">COLOR</h5>
					<div
						class="account-dropdown-section p-2.5 bg-zinc-300 dark:bg-zinc-600"
						style="margin-top: 0.125rem;"
					>
						<select
							class="w-full rounded-lg border-transparent bg-zinc-400 dark:bg-zinc-500 focus:ring-0"
							on:change={(event) => setTheme(ThemePref[event.target.value])}
						>
							{#each themes as theme}
								{#if currTheme.value === theme.value}
									<option value={theme.label} selected>{theme.label}</option>
								{:else}
									<option value={theme.label}>{theme.label}</option>
								{/if}
							{/each}
						</select>
					</div>
					<h5 class="ml-2">DARK MODE</h5>
					<div
						class="account-dropdown-section p-2.5 bg-zinc-300 dark:bg-zinc-600"
						style="margin-top: 0.125rem;"
					>
						<div class="flex items-center justify-center">
							<button
								class="mode-toggle"
								class:active={$app.brightness === null}
								on:click={() => toggleBrightness(null)}
							>
								{#if $app.brightness === null}
									<SunFill size="24px" />
								{:else}
									<SunLine size="24px" />
								{/if}
								<span>Lights On</span>
							</button>
							<button
								class="mode-toggle"
								class:active={$app.brightness === "dark"}
								on:click={() => toggleBrightness("dark")}
							>
								{#if $app.brightness === "dark"}
									<MoonFill size="24px" />
								{:else}
									<MoonLine size="24px" />
								{/if}
								<span>Lights Off</span>
							</button>
						</div>
					</div>
					<h5 class="ml-2">CONTENT RATINGS</h5>
					<div
						class="account-dropdown-section p-2.5 items-center justify-center bg-zinc-300 dark:bg-zinc-600"
						style="margin-top: 0.125rem;"
					>
						{#if $app.isOfAge}
							<Toggle bind:value={enableMature}>Show Mature</Toggle>
							<Toggle bind:value={enableExplicit}>Show Explicit</Toggle>
						{:else}
							<span
								>Changing this setting may expose you to content not suitable for
								people under the age of 18.</span
							>
							<span class="my-2">Are you sure you want to proceed?</span>
							<Button on:click={setOfAge}>
								<CheckLine class="button-icon" />
								<span class="button-text">Show me the money</span>
							</Button>
						{/if}
					</div>
					<div class="mt-2 mb-4 border-b border-zinc-300 dark:border-zinc-600">
						<!--spacer-->
					</div>
					<Button
						classes="w-full justify-center"
						kind="primary"
						asLink={true}
						href="/account/settings"
					>
						<Settings5Line class="button-icon" />
						<span class="button-text">Show All</span>
					</Button>
				</div>
			{:else if currPanel === Panels.LogOut}
				<div in:fade={{ delay: 0, duration: 150 }}>
					<Button on:click={() => switchPanel(Panels.Home)}>
						<ArrowLeftSLine class="button-icon" />
						<span class="button-text">Back</span>
					</Button>
					<div class="mb-1"><!--spacer--></div>
					<h2 class="text-2xl text-center">Log Out</h2>
					<p class="text-center" style="font-family: var(--body-text);">
						Are you sure you want to log out?
					</p>
					<div class="flex items-center justify-center mb-6">
						<Button kind="primary" classes="text-center" on:click={logOut}>
							<CheckLine class="button-icon" />
							<span class="button-text">Yes</span>
						</Button>
						<div class="mx-0.5"><!--spacer--></div>
						<Button classes="text-center" on:click={() => switchPanel(Panels.Home)}>
							<CloseLine class="button-icon" />
							<span class="button-text">No</span>
						</Button>
					</div>
				</div>
			{/if}
		</div>
	{/if}
</div>

<style lang="scss">
	div.account-dropdown {
		@apply absolute rounded-2xl z-50 max-h-[calc(100vh-80px)] p-2 lg:w-[375px] overflow-hidden overflow-y-scroll;
		box-shadow: var(--dropshadow);
		font-family: var(--header-text);
		div.account-dropdown-section {
			@apply flex flex-col w-full rounded-xl overflow-hidden my-4 first:mt-0 last:mb-0 shrink-0;
			color: var(--text-color);
		}
		button.account-dropdown-button,
		a.account-dropdown-button {
			@apply flex items-center w-full px-4 py-3 transition no-underline hover:bg-zinc-400 dark:hover:bg-zinc-500 border-b border-zinc-400 dark:border-zinc-500 last:border-0;
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
		button.mode-toggle {
			@apply flex flex-col items-center justify-center pt-0.5 border-2 border-zinc-400 dark:border-white rounded-lg mx-2 w-[80px] h-[68px];
			span {
				@apply all-small-caps font-bold;
			}
			&.active {
				@apply text-white;
				background: var(--accent);
			}
		}
	}
</style>
