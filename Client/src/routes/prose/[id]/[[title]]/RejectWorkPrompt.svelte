<script lang="ts">
	import { Button } from "$lib/ui/util";
	import { createForm } from "felte";
	import { CloseLine, CheckLine } from "svelte-remixicon";
	import { closePopup, closePopupAndConfirm } from "$lib/ui/popup";
	import type { ProvideReason } from "$lib/models/admin/approval-queue";
	import { TextArea } from "$lib/ui/forms";

	const { form, errors, createSubmitHandler } = createForm<ProvideReason>({
		validate: (values) => {
			const error = {
				reason: ""
			};

			if (!values.reason || values.reason === "" || values.reason.length < 3) {
				error.reason = "You must specify a reason for rejecting this work.";
			}

			return error;
		},
		initialValues: {
			reason: ""
		}
	});

	const submit = createSubmitHandler({
		onSubmit: (values) => {
			closePopupAndConfirm(values);
		}
	});
</script>

<div class="rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="p-4">
		<h3 class="text-2xl">Reject Work</h3>
		<form use:form>
			<TextArea
				name="reason"
				title="Reason"
				placeholder="This work has X, when it should have Z."
				kind="primary"
				errorMessage={$errors.reason}
			/>
		</form>
	</div>
	<div class="flex items-center flex-row-reverse px-4 py-2 bg-zinc-300 dark:bg-zinc-600">
		<Button kind="primary" on:click={submit}>
			<CheckLine class="button-icon" />
			<span class="button-text">Yes</span>
		</Button>
		<div class="mx-0.5"><!--spacer--></div>
		<Button on:click={closePopup}>
			<CloseLine class="button-icon" />
			<span class="button-text">No</span>
		</Button>
	</div>
</div>
