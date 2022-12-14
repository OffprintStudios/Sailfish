<script lang="ts">
	import { createForm } from "felte";
	import { account } from "$lib/state/account.state";
	import { Avatar, Button } from "$lib/ui/util";
	import type { Profile, ProfileForm } from "$lib/models/accounts";
	import { Presence } from "$lib/models/accounts";
	import { TextArea, TextField } from "$lib/ui/forms";
	import { AddBoxLine, CheckLine, CloseLine, ArrowLeftSLine } from "svelte-remixicon";
	import { guide, prevPage } from "$lib/ui/guide";
	import { postReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";

	let showAddForm = false;

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

<div class="panel-container">
	{#if $guide.routing.length > 1}
		<div class="topbar">
			<div class="left-button">
				<Button on:click={prevPage}>
					<ArrowLeftSLine class="button-icon" />
					<span class="button-text">Account</span>
				</Button>
			</div>
		</div>
	{/if}
	<div class="title-block">
		<h1>Select Profile</h1>
	</div>
	<div class="content-container">
		{#each $account.profiles as profile}
			<div
				class="profile-box border-zinc-600 dark:border-white"
				on:click={() => ($account.currProfile = profile)}
			>
				<Avatar src={profile.avatar} size="64px" />
				<div class="user-info-container">
					<h3>{profile.username}</h3>
				</div>
			</div>
		{/each}
		{#if $account.profiles.length < 3}
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
					<button
						class="absolute w-full h-full"
						on:click={() => (showAddForm = !showAddForm)}
					/>
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
	</div>
</div>

<style lang="scss">
	@use "../Guide";

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
