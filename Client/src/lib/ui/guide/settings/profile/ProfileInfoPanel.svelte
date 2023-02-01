<script lang="ts">
	import { createForm } from "felte";
	import { slide } from "svelte/transition";
	import { account } from "$lib/state/account.state";
	import {
		AddBoxLine,
		ArrowLeftSLine,
		CheckLine,
		CloseLine,
		ImageEditLine,
		Save3Line,
		Loader5Line,
		DeleteBinLine
	} from "svelte-remixicon";
	import { Button, Avatar } from "$lib/ui/util";
	import { prevPage } from "$lib/ui/guide";
	import { openPopup } from "$lib/ui/popup";
	import { UploadAvatar } from "$lib/ui/upload";
	import { TextField, TextArea } from "$lib/ui/forms";
	import { hasRoles } from "$lib/util/functions";
	import {
		Roles,
		Presence,
		LinkKinds,
		type Profile,
		type ProfileForm
	} from "$lib/models/accounts";
	import { patchReq, type ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";

	let showAddTagForm = false;
	let addingLink = false;
	let deletingLink = false;
	let key = LinkKinds.Other;
	let value: string;

	const { form, isSubmitting, errors } = createForm({
		async onSubmit(values) {
			const formInfo: ProfileForm = {
				presence: Presence.Offline,
				username: values.username,
				bio: values.bio,
				tagline: values.tagline === "" ? undefined : values.tagline
			};

			const response = await patchReq<Profile>(
				`/profiles/update-profile?profileId=${$account.currProfile?.id}`,
				formInfo
			);
			if ((response as ResponseError).statusCode) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				$account.profiles = $account.profiles.map((val) => {
					if (val.id === (response as Profile).id) {
						return response as Profile;
					} else {
						return val;
					}
				});
				$account.currProfile = response as Profile;
			}
		},
		validate: (values) => {
			const errors = {
				username: "",
				bio: "",
				tagline: ""
			};

			if (values.username.length < 3 || values.username.length > 36) {
				errors.username = "Usernames must be between 3 and 36 characters in length";
			}

			if (values.bio !== "" && (values.bio.length < 3 || values.username.length > 120)) {
				errors.bio = "Profile bios must be between 3 and 120 characters in length";
			}

			if (
				values.tagline !== "" &&
				(values.tagline.length < 3 || values.tagline.length > 36)
			) {
				errors.tagline = "Taglines must be between 3 and 36 characters in length";
			}

			return errors;
		},
		initialValues: {
			username: $account.currProfile?.username,
			bio: $account.currProfile?.info.bio,
			tagline: $account.currProfile?.info.tagline ? $account.currProfile?.info.tagline : ""
		}
	});

	function updateAvatar() {
		openPopup(UploadAvatar, {
			onConfirm(value: Profile) {
				$account.currProfile = value;
				$account.profiles = $account.profiles.map((item) => {
					return item.id === value.id ? value : item;
				});
			}
		});
	}

	async function addLink() {
		addingLink = true;
		if ($account.currProfile) {
			let currLinks = $account.currProfile.links;
			if (currLinks[key]) {
				toast.error("You've already added a link of this kind!");
				return;
			}
			currLinks[key] = value;
			const response = await patchReq<Profile>(
				`/profiles/update-links?profileId=${$account.currProfile.id}`,
				{ links: currLinks }
			);
			if ((response as ResponseError).statusCode) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				const updatedProfile = response as Profile;
				$account.profiles = $account.profiles.map((val) => {
					if (val.id === updatedProfile.id) {
						return updatedProfile;
					} else {
						return val;
					}
				});
				$account.currProfile = updatedProfile;
			}
		} else {
			toast.error("No profile signed in. How did you manage to do that?");
		}
		addingLink = false;
		toggleAddLink();
	}

	async function deleteLink(linkKey: string) {
		deletingLink = true;
		if ($account.currProfile) {
			let currLinks = $account.currProfile.links;
			delete currLinks[linkKey];
			const response = await patchReq<Profile>(
				`/profiles/update-links?profileId=${$account.currProfile.id}`,
				{ links: currLinks }
			);
			if ((response as ResponseError).statusCode) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				const updatedProfile = response as Profile;
				$account.profiles = $account.profiles.map((val) => {
					if (val.id === updatedProfile.id) {
						return updatedProfile;
					} else {
						return val;
					}
				});
				$account.currProfile = updatedProfile;
			}
		} else {
			toast.error("No profile signed in. How did you manage that?");
		}
		deletingLink = false;
	}

	function toggleAddLink() {
		key = LinkKinds.Other;
		value = "";
		showAddTagForm = showAddTagForm !== true;
	}
</script>

<div class="panel-container">
	<div class="topbar">
		<div class="left-button">
			<Button on:click={prevPage}>
				<ArrowLeftSLine class="button-icon" />
				<span class="button-text">Settings</span>
			</Button>
		</div>
	</div>
	<div class="content-container">
		<div class="panel-section">
			<h3>Avatar</h3>
			<div class="panel-box">
				<Avatar src={$account.currProfile.avatar} size="100px" borderWidth="1px" />
				<div class="my-1"><!--spacer--></div>
				<Button on:click={updateAvatar}>
					<ImageEditLine class="button-icon" />
					<span class="button-text">Change Avatar</span>
				</Button>
			</div>
		</div>
		<div class="panel-section">
			<h3>Username & Bio</h3>
			<div class="panel-box">
				<form class="w-full" use:form>
					<TextField
						name="username"
						title="Username"
						placeholder="Somebody"
						kind="primary"
						errorMessage={$errors.username}
					/>
					<TextArea
						name="bio"
						title="Bio"
						placeholder="Just another friendly face"
						kind="primary"
						errorMessage={$errors.bio}
					/>
					<div class="flex items-center justify-center">
						<Button
							type="submit"
							kind="primary"
							loading={$isSubmitting}
							loadingText="Saving"
						>
							<Save3Line class="button-icon" />
							<span class="button-text">Save</span>
						</Button>
					</div>
				</form>
			</div>
		</div>
		<div class="panel-section">
			<h3>Links</h3>
			<div class="panel-box">
				<ul class="w-full">
					{#each Object.keys($account.currProfile?.links) as key}
						<li
							class="flex items-center bg-zinc-300 dark:bg-zinc-600 rounded-xl text-xs overflow-hidden mb-2"
						>
							<span class="py-3 px-4">{key}</span>
							<span class="flex-1 truncate">{$account.currProfile?.links[key]}</span>
							<button
								class="px-2 pt-[0.70rem] pb-[0.675rem]"
								title="Delete Link"
								disabled={deletingLink}
								on:click={() => deleteLink(key)}
							>
								{#if addingLink}
									<Loader5Line class="animate-spin" size="18px" />
								{:else}
									<DeleteBinLine size="18px" />
								{/if}
							</button>
						</li>
					{/each}
					{#if showAddTagForm}
						<li
							transition:slide={{ delay: 0, duration: 150 }}
							class="flex items-center mb-2"
						>
							<select
								class="py-3 w-1/3 text-xs border-0 rounded-l-xl bg-zinc-300 dark:bg-zinc-600 focus:ring-0"
								bind:value={key}
							>
								{#each Object.keys(LinkKinds) as kind}
									<option value={LinkKinds[kind]}>{LinkKinds[kind]}</option>
								{/each}
							</select>
							<input
								type="text"
								bind:value
								class="bg-zinc-300 w-2/3 dark:bg-zinc-600 focus:ring-0 border-0 text-xs py-3"
								placeholder="Paste link here"
							/>
							<button
								class="rounded-r-xl bg-zinc-300 dark:bg-zinc-600 px-2 pt-[0.70rem] pb-[0.675rem]"
								on:click={addLink}
								disabled={addingLink}
							>
								{#if addingLink}
									<Loader5Line class="animate-spin" size="18px" />
								{:else}
									<CheckLine size="18px" />
								{/if}
							</button>
						</li>
					{/if}
					<li
						class="w-full border-2 border-dashed rounded-xl border-zinc-300 dark:border-zinc-600"
					>
						<button
							class="w-full py-2.5 flex rounded-xl transition items-center justify-center"
							on:click={toggleAddLink}
						>
							{#if showAddTagForm}
								<CloseLine class="mr-2" size="18px" />
								<span
									class="relative top-[0.075rem] uppercase tracking-wider text-xs font-bold"
								>
									Cancel
								</span>
							{:else}
								<AddBoxLine class="mr-2" size="18px" />
								<span
									class="relative top-[0.075rem] uppercase tracking-wider text-xs font-bold"
								>
									Add Link
								</span>
							{/if}
						</button>
					</li>
				</ul>
			</div>
		</div>
		{#if hasRoles( $account.account.roles, [Roles.Admin, Roles.Moderator, Roles.ChatModerator, Roles.VIP] )}
			<div class="panel-section">
				<h3>VIP Options</h3>
				<div class="panel-box">
					<form class="w-full" use:form>
						<TextField
							name="tagline"
							title="Tagline"
							placeholder="Just another friendly face"
							kind="primary"
							errorMessage={$errors.tagline}
						/>
						<div class="flex items-center justify-center">
							<Button
								type="submit"
								kind="primary"
								loading={$isSubmitting}
								loadingText="Saving"
							>
								<Save3Line class="button-icon" />
								<span class="button-text">Save</span>
							</Button>
						</div>
					</form>
				</div>
			</div>
		{/if}
	</div>
</div>

<style lang="scss">
	@use "../../Guide";
</style>
