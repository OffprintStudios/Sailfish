<script lang="ts">
	import { createForm } from "felte";
	import { account } from "$lib/state/account.state";
	import { Avatar, Button } from "$lib/ui/util";
	import type { ProfileForm } from "$lib/models/accounts";
	import { Presence } from "$lib/models/accounts";
	import { TextArea, TextField } from "$lib/ui/forms";
	import { AddBoxLine, CheckLine, CloseLine, ArrowLeftSLine } from "svelte-remixicon";
	import { closePopup } from "../popup";
	import toast from "svelte-french-toast";

	const { form, errors, isSubmitting } = createForm({
		onSubmit: async (values, context) => {
			const formInfo: ProfileForm = {
				username: values.username,
				presence: Presence.Offline,
				bio: values.bio,
			};
			await fetch('/api/accounts/create-profile', { method: 'POST', body: JSON.stringify(formInfo), credentials: 'include' })
				.then(async (response) => {
					const data = await response.json();
					if (response.status === 200) {
						$account.profiles = [...$account.profiles, data];
						toast.success('Profile added!');
						context.reset();
						closePopup();
					} else {
						toast.error('Something went wrong! Try again in a little bit.');
					}
				})
		},
		validate: () => {
			// TODO: implement errors
			return {
				username: '',
				bio: '',
			};
		},
		initialValues: {
			username: null,
			bio: null,
		}
	});
</script>

<form class="lg:w-[470px] px-4 py-5" use:form>
	<TextField
		name="username"
		type="text"
		title="Username"
		placeholder="A New Face"
		errorMessage={$errors.username}
		kind="primary"
	/>
	<TextArea
		name="bio"
		title="Bio"
		placeholder="Just another somebody"
		errorMessage={$errors.bio}
		kind="primary"
	/>
	<div class="flex items-center justify-center">
		<Button kind="primary" type="submit" loading={$isSubmitting} loadingText="Saving...">
			<CheckLine class="button-icon" />
			<span class="button-text">Submit</span>
		</Button>
	</div>
</form>