<script lang="ts">
	import { createForm } from "felte";
	import { account } from "$lib/state/account.state";
	import { ArrowLeftSLine, ImageEditLine, Save3Line } from "svelte-remixicon";
	import { Button, Avatar } from "$lib/ui/util";
	import { prevPage } from "$lib/ui/guide";
	import { openPopup } from "$lib/ui/popup";
	import { UploadAvatar } from "$lib/ui/upload";
	import { TextField, TextArea } from "$lib/ui/forms";
	import { hasRoles } from "$lib/util/functions";
	import { Roles, Presence, type Profile, type ProfileForm } from "$lib/models/accounts";
	import { patchReq, type ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";

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
			<div class="panel-box">yup yup</div>
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
