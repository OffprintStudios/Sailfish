<script lang="ts">
	import { auth } from "$lib/state/auth.state";
	import { abbreviate, slugify } from "$lib/util/functions";
	import { Avatar, RoleBadge } from "$lib/ui/util";
	import {
		RiArrowDownSLine,
		RiArrowLeftRightLine,
		RiArrowRightSLine,
		RiArrowUpSLine,
		RiBookLine,
		RiCupLine,
		RiEyeLine,
		RiLink,
		RiLogoutCircleLine,
		RiQuillPenLine,
		RiSettings5Line
	} from "svelte-remixicon";
	import { slide } from "svelte/transition";
	import type { Profile } from "$lib/models/accounts";
	import { pushPanel } from "../guide.state";
	import { SettingsPanel, LogOutPanel } from "./settings";

	let profileSwitcherOpen = false;
	let showAddForm = false;

	async function selectProfile(profile: Profile) {
		$auth.currProfile = profile;
		profileSwitcherOpen = false;
	}
</script>

{#if $auth.account && $auth.currProfile}
	<div class="guide-section mt-2 bg-zinc-300 dark:bg-zinc-600">
		<div class="h-[6rem] overflow-hidden w-full relative">
			{#if $auth.currProfile.bannerArt !== null && $auth.currProfile.bannerArt !== undefined}
				<img
					src={$auth.currProfile.bannerArt}
					class="h-full w-full object-cover"
					alt="profile avatar"
				/>
			{:else}
				<div class="h-full w-full absolute" style="background: rgb(var(--accent));">
					<!--intentionally left blank-->
				</div>
			{/if}
		</div>
		<div class="flex items-center px-4 my-2">
			<Avatar src={$auth.currProfile.avatar} size="72px" borderWidth="1px" />
			<div class="ml-2">
				<a
					class="text-ellipsis overflow-hidden"
					href="/profile/{$auth.currProfile.id}/{slugify(
						$auth.currProfile.username
					)}"
				>
					<h3 class="text-2xl">{$auth.currProfile.username}</h3>
				</a>
				<RoleBadge roles={$auth.account.roles} size="large" />
			</div>
		</div>
		<div
			class="w-full flex items-center justify-center border-t border-zinc-400 dark:border-zinc-500 mt-0.5"
		>
			<a
				class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500"
				href="/profile/{$auth.currProfile.id}/{slugify(
					$auth.currProfile.username
				)}/works"
			>
				<div class="stat">
					<RiQuillPenLine size="18.4px" class="mr-1" />
					<span class="select-none">0</span>
				</div>
				<div class="stat-label">Works</div>
			</a>
			<a
				class="stat-box border-l border-r border-zinc-400 dark:border-zinc-500 hover:bg-zinc-400 dark:hover:bg-zinc-500"
				href="/profile/{$auth.currProfile.id}/{slugify(
					$auth.currProfile.username
				)}/blogs"
			>
				<div class="stat">
					<RiCupLine size="18.4px" class="mr-1" />
					<span class="select-none">0</span>
				</div>
				<div class="stat-label">Blogs</div>
			</a>
			<a
				class="stat-box hover:bg-zinc-400 dark:hover:bg-zinc-500"
				href="/profile/{$auth.currProfile.id}/{slugify(
					$auth.currProfile.username
				)}/followers"
			>
				<div class="stat">
					<RiEyeLine size="18.4px" class="mr-1" />
					<span class="select-none"
						>{abbreviate($auth.currProfile.followers)}</span
					>
				</div>
				<div class="stat-label">Follows</div>
			</a>
		</div>
	</div>
	<div class="guide-section bg-zinc-300 dark:bg-zinc-600">
		<a
			class="guide-button group"
			href="/profile/{$auth.currProfile.id}/{slugify(
				$auth.currProfile.username
			)}/works/new"
		>
			<RiBookLine size="24px" class="mr-2" />
			<span>Create New Work</span>
			<RiLink size="18px" class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400" />
		</a>
		<a
			class="guide-button group"
			href="/profile/{$auth.currProfile.id}/{slugify(
				$auth.currProfile.username
			)}/blogs/new"
		>
			<RiCupLine size="24px" class="mr-2" />
			<span>Create New Blog</span>
			<RiLink size="18px" class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400" />
		</a>
	</div>
	<div class="guide-section bg-zinc-300 dark:bg-zinc-600">
		<button
			class="guide-button group"
			on:click={() => (profileSwitcherOpen = !profileSwitcherOpen)}
		>
			<RiArrowLeftRightLine size="24px" class="mr-2" />
			<span>Switch Profile</span>
			{#if profileSwitcherOpen}
				<RiArrowUpSLine
					size="18px"
					class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
				/>
			{:else}
				<RiArrowDownSLine
					size="18px"
					class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
				/>
			{/if}
		</button>
		{#if profileSwitcherOpen}
			<div transition:slide={{ delay: 0, duration: 150 }}>
				<div class="flex items-center justify-center my-2">
                    {#each $auth.profiles as profile}
                        <button class="profile-button" on:click={() => selectProfile(profile)}>
                            <Avatar src={profile.avatar} size="72px" borderWidth="1px" />
                            <span>{profile.username}</span>
                        </button>
                    {/each}
                    {#if $auth.profiles.length < 3}
                        <button
                            class="profile-button"
                            on:click={() => (showAddForm = !showAddForm)}
                        >
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
{:else if $auth.account}
	<div class="px-4 mb-2">
		<h5 class="text-xl justify-self-start">Select Profile</h5>
		<div class="flex items-center justify-center">
            {#each $auth.profiles as profile}
                <button class="profile-button" on:click={() => selectProfile(profile)}>
                    <Avatar src={profile.avatar} size="72px" borderWidth="1px" />
                    <span>{profile.username}</span>
                </button>
            {/each}
            {#if $auth.profiles.length < 3}
                <button class="profile-button" on:click={() => (showAddForm = !showAddForm)}>
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
<div class="guide-section bg-zinc-300 dark:bg-zinc-600">
	<button class="guide-button group" on:click={() => pushPanel(SettingsPanel)}>
		<RiSettings5Line size="24px" class="mr-2" />
		<span>Settings</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(LogOutPanel)}>
		<RiLogoutCircleLine size="24px" class="mr-2" />
		<span>Log Out</span>
		<RiArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
</div>
