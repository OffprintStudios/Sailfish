<script lang="ts">
	import { closePopup, closePopupAndConfirm, popup } from "$lib/ui/popup";
	import { Button } from "$lib/ui/util";
	import { CloseLine, CheckLine } from "svelte-remixicon";
	import { createForm } from "felte";
	import { TextArea } from "$lib/ui/forms";
	import type { ActionForm } from "$lib/models/admin/users/action-form";
	import { postReq, type ResponseError } from "$lib/http";
	import { account } from "$lib/state/account.state";
	import toast from "svelte-french-toast";

	const accountId: string = $popup.data.accountId;

	const { form, errors, isSubmitting } = createForm({
		onSubmit: async (values) => {
			const formInfo: ActionForm = {
				accountId,
				reason: values.reason
			};
			const response = await postReq<void>(
				`/admin/warn-user?profileId=${$account.currProfile?.id}`,
				formInfo
			);
			if ((response as ResponseError).statusCode) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				closePopupAndConfirm();
			}
		},
		validate: (values) => {
			const errors = {
				reason: ""
			};

			if (values.reason < 3) {
				errors.reason = "Reasons must have a minimum of 3 characters.";
			}

			return errors;
		},
		initialValues: {
			reason: ""
		}
	});
</script>

<div class="rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="p-4 flex items-center">
		<h3 class="text-2xl flex-1">Warn User</h3>
		<Button on:click={closePopup}><CloseLine class="button-icon no-text" size="24px" /></Button>
	</div>
	<form class="px-4 pb-4 w-full lg:w-[400px]" use:form>
		<TextArea
			title="Reason"
			name="reason"
			placeholder="Detail the reasoning for this action in full. Include any necessary information like work titles or profiles."
			kind="primary"
			errorMessage={$errors.reason}
		/>
		<div class="flex items-center justify-center">
			<Button type="submit" kind="primary" loading={$isSubmitting} loadingText="Saving">
				<CheckLine class="button-icon" />
				<span class="button-text">Submit</span>
			</Button>
			<div class="mx-0.5"><!--spacer--></div>
			<Button type="button" on:click={closePopup}>
				<CloseLine class="button-icon" />
				<span class="button-text">Cancel</span>
			</Button>
		</div>
	</form>
</div>
