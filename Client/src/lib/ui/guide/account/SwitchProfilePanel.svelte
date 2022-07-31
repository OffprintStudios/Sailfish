<script lang="ts">
	import { createForm } from "felte";
	import { account } from "$lib/state/account.state";
	import { Avatar, Button } from "$lib/ui/util";
	import type { Profile, ProfileForm } from "$lib/models/accounts";
	import { TextField, TextArea } from "$lib/ui/forms";
	import { AddBoxLine, CheckLine, CloseLine } from "svelte-remixicon";
	import { Presence } from "$lib/models/accounts";

	let showAddForm = false;

	const { form, errors, isSubmitting } = createForm({
		onSubmit: async (values) => {
			const formInfo: ProfileForm = {
				username: values.username,
				pronouns: [],
				presence: Presence.Offline,
				bio: values.bio,
			};
			//TODO: implement profile creation
		},
		validate: () => {
			// TODO: implement errors
			return {
				username: '',
				pronouns: '',
			};
		},
		initialValues: {
			username: null,
			pronouns: [],
			bio: null,
		}
	});

	async function fetchProfiles(): Promise<Profile[]> {
		const response = await fetch('/api/accounts/fetch-profiles');
		return await response.json();
	}
</script>

<div class="panel-container">
	<div class="title-block">
		<h1>Select Profile</h1>
	</div>
	<div class="content-container">
		{#await fetchProfiles()}
			<div class="empty">
				<h3 class="text-2xl">Loading...</h3>
			</div>
		{:then profiles}
			{#each profiles as profile}
				<div
					class="profile-box border-zinc-600 dark:border-white"
					on:click={() => $account.currProfile = profile}
				>
					<Avatar src={profile.avatar} size="64px" />
					<div class="user-info-container">
						<h3>{profile.username}</h3>
					</div>
				</div>
			{/each}
			{#if profiles.length < 3}
				<div
					class="add-profile-box border-zinc-600 dark:border-white"
					class:auto-height={showAddForm}
				>
					{#if showAddForm}
						<form use:form>
							<TextField
								name="username"
								type="text"
								title="Username"
								placeholder="A New Face"
								errorMessage={$errors.username}
							/>
							<TextArea
								name="bio"
								title="Bio"
								placeholder="Just another somebody"
								errorMessage={$errors.bio}
							/>
							<div class="flex items-center justify-center">
								<Button type="submit" loading={$isSubmitting} loadingText="Saving...">
									<CheckLine class="button-icon" />
									<span class="button-text">Submit</span>
								</Button>
								<div class="mx-0.5"></div>
								<Button type="button" on:click={() => (showAddForm = false)}>
									<CloseLine class="button-icon" />
									<span class="button-text">Cancel</span>
								</Button>
							</div>
						</form>
					{:else}
						<button class="absolute w-full h-full" on:click={() => (showAddForm = !showAddForm)}></button>
						<AddBoxLine size="24px" class="mr-2" />
						<span class="uppercase font-bold tracking-widest text-xs">Add profile</span>
					{/if}
				</div>
			{:else}
				<div class="empty">
					<h3 class="text-2xl">You've hit the limit!</h3>
					<p class="text-sm">Only three profiles per account, sorry folks!</p>
				</div>
			{/if}
		{:catch err}
			<div class="empty">
				<h3 class="text-2xl">Something went wrong!</h3>
				<p class="text-sm">Please try again in a little bit.</p>
			</div>
		{/await}
	</div>
</div>

<style lang="scss">
	@use '../Guide';

	div.profile-box {
		@apply relative border rounded-lg flex items-center p-2 transition transform cursor-pointer select-none mb-4;
		&:hover {
			@apply scale-105;
			background: var(--accent);

			div.user-info-container {
				h3,
				h5 {
					@apply text-white;
				}
			}
		}

		&:active {
			@apply scale-100;
		}

		div.user-info-container {
			@apply ml-2;
			h3 {
				@apply text-2xl font-medium;
			}

			h5 {
				@apply text-sm;
				color: var(--text-color);
			}
		}
	}

	div.add-profile-box {
		@apply relative border-2 rounded-lg flex items-center py-2 transition transform cursor-pointer select-none border-dashed justify-center;

		&.auto-height {
			@apply scale-100 cursor-default;
			height: auto;

			&:hover {
				@apply scale-100;
				color: var(--text-color);
				background: var(--background);
			}
		}

		&:hover {
			@apply text-white;
			background: var(--accent);
		}

		&:active {
			@apply scale-95;
		}
	}
</style>