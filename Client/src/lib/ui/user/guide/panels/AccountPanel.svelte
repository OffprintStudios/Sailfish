<script lang="ts">
	import { account } from "$lib/state/account.state";
	import { abbreviate, slugify } from "$lib/util/functions";
	import { Avatar, Button, RoleBadge } from "$lib/ui/util";
	import {
		ArrowDownSLine,
		ArrowLeftRightLine,
		ArrowRightSLine,
		ArrowUpSLine,
		BookLine,
		CheckLine,
		CloseLine,
		CupLine,
		EyeLine,
		Link,
		LogoutCircleLine,
		QuillPenLine,
		Settings5Line
	} from "svelte-remixicon";
	import { slide } from "svelte/transition";
	import type { Profile } from "$lib/models/accounts";
	import { pushPanel } from "$lib/ui/user/guide/guide.state";
	import { SettingsPanel, LogOutPanel } from "./settings";
	import { createForm } from "felte";
	import { Presence, type ProfileForm } from "$lib/models/accounts";
	import { postReq, type ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";
	import { TextArea, TextField } from "$lib/ui/forms";

	let profileSwitcherOpen = false;
	let showAddForm = false;

	async function selectProfile(profile: Profile) {
		$account.currProfile = profile;
		const response = await fetch(`/api/auth/set-profile?profileId=${$account.currProfile.id}`, {
			method: "POST",
			credentials: "include"
		});
		if (response.status !== 200) {
			toast.error("Could not set profile in cookies!");
		}
		profileSwitcherOpen = false;
	}

	const { form, errors, isSubmitting } = createForm({
		onSubmit: async (values, context) => {
			const formInfo: ProfileForm = {
				username: values.username,
				presence: Presence.Offline,
				bio: values.bio
			};
			const response = await postReq<Profile>(`/accounts/create-profile`, formInfo);
			if ((response as Profile).id) {
				$account.profiles = [...$account.profiles, response as Profile];
				toast.success(`Profile added!`);
				context.reset();
				showAddForm = false;
			} else {
				const error = response as ResponseError;
				toast.error(error.message);
			}
		},
		validate: (values) => {
			const errors = {
				username: "",
				bio: ""
			};

			if (!values.username || values.username.length < 3 || values.username.length > 36) {
				errors.username = "Usernames must be between 3 and 36 characters in length";
			}

			if (values.bio && (values.bio.length < 3 || values.username.length > 120)) {
				errors.bio = "Profile bios must be between 3 and 120 characters in length";
			}

			return errors;
		},
		initialValues: {
			username: null,
			presence: Presence.Offline,
			bio: null,
			tagline: null
		}
	});
</script>

{#if $account.account && $account.currProfile}
	<div class="guide-section mt-2 bg-zinc-300 dark:bg-zinc-600">
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
					<span class="select-none">{abbreviate($account.currProfile.stats.works)}</span>
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
					<span class="select-none">{abbreviate($account.currProfile.stats.blogs)}</span>
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
	<div class="guide-section bg-zinc-300 dark:bg-zinc-600">
		<a
			class="guide-button group"
			href="/profile/{$account.currProfile.id}/{slugify(
				$account.currProfile.username
			)}/works/new"
		>
			<BookLine size="24px" class="mr-2" />
			<span>Create New Work</span>
			<Link size="18px" class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400" />
		</a>
		<a
			class="guide-button group"
			href="/profile/{$account.currProfile.id}/{slugify(
				$account.currProfile.username
			)}/blogs/new"
		>
			<CupLine size="24px" class="mr-2" />
			<span>Create New Blog</span>
			<Link size="18px" class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400" />
		</a>
	</div>
	<div class="guide-section bg-zinc-300 dark:bg-zinc-600">
		<button
			class="guide-button group"
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
				{#if showAddForm}
					<form class="px-2 pb-2" use:form>
						<TextField
							name="username"
							type="text"
							title="Username"
							placeholder="A New Face"
							errorMessage={$errors.username}
						/>
						<TextArea
							name="bio"
							title="Bio (Optional)"
							placeholder="Just another somebody"
							errorMessage={$errors.bio}
						/>
						<div class="flex items-center justify-center">
							<Button type="submit" loading={$isSubmitting} loadingText="Saving...">
								<CheckLine class="button-icon" />
								<span class="button-text">Submit</span>
							</Button>
							<div class="mx-0.5" />
							<Button type="button" on:click={() => (showAddForm = false)}>
								<CloseLine class="button-icon" />
								<span class="button-text">Cancel</span>
							</Button>
						</div>
					</form>
				{:else}
					<div class="flex items-center justify-center my-2">
						{#each $account.profiles as profile}
							<button class="profile-button" on:click={() => selectProfile(profile)}>
								<Avatar src={profile.avatar} size="72px" borderWidth="1px" />
								<span>{profile.username}</span>
							</button>
						{/each}
						{#if $account.profiles.length < 3}
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
				{/if}
			</div>
		{/if}
	</div>
{:else if $account.account}
	<div class="px-4 mb-2">
		<h5 class="text-xl justify-self-start">Select Profile</h5>
		{#if showAddForm}
			<form class="px-2 pb-2" use:form>
				<TextField
					name="username"
					type="text"
					title="Username"
					placeholder="A New Face"
					kind="primary"
					errorMessage={$errors.username}
				/>
				<TextArea
					name="bio"
					title="Bio (Optional)"
					placeholder="Just another somebody"
					kind="primary"
					errorMessage={$errors.bio}
				/>
				<div class="flex items-center justify-center">
					<Button type="submit" loading={$isSubmitting} loadingText="Saving...">
						<CheckLine class="button-icon" />
						<span class="button-text">Submit</span>
					</Button>
					<div class="mx-0.5" />
					<Button type="button" on:click={() => (showAddForm = false)}>
						<CloseLine class="button-icon" />
						<span class="button-text">Cancel</span>
					</Button>
				</div>
			</form>
		{:else}
			<div class="flex items-center justify-center">
				{#each $account.profiles as profile}
					<button class="profile-button" on:click={() => selectProfile(profile)}>
						<Avatar src={profile.avatar} size="72px" borderWidth="1px" />
						<span>{profile.username}</span>
					</button>
				{/each}
				{#if $account.profiles.length < 3}
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
		{/if}
	</div>
{/if}
<div class="guide-section bg-zinc-300 dark:bg-zinc-600">
	<button class="guide-button group" on:click={() => pushPanel(SettingsPanel)}>
		<Settings5Line size="24px" class="mr-2" />
		<span>Settings</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
	<button class="guide-button group" on:click={() => pushPanel(LogOutPanel)}>
		<LogoutCircleLine size="24px" class="mr-2" />
		<span>Log Out</span>
		<ArrowRightSLine
			size="18px"
			class="text-zinc-400 dark:text-zinc-500 group-hover:text-zinc-400"
		/>
	</button>
</div>
