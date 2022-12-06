<script lang="ts">
	import { popup, closePopup, closePopupAndConfirm } from "$lib/ui/popup";
	import { account } from "$lib/state/account.state";
	import { createForm } from "felte";
	import { Button } from "$lib/ui/util";
	import { CheckLine, CloseLine } from "svelte-remixicon";
	import type { VolumeForm } from "$lib/models/content/works";
	import { postReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import { TextField, TextArea } from "$lib/ui/forms";
	import toast from "svelte-french-toast";

	const { form, errors, isSubmitting, createSubmitHandler } = createForm<VolumeForm>({
		validate(values) {
			const errors = {
				title: '',
				desc: '',
			};
			if (!values.title || values.title.length < 3 || values.title.length > 120) {
				errors.title = 'Titles should be between 3 and 120 characters';
			}
			if (!values.desc || values.desc.length < 3 || values.desc.length > 240) {
				errors.desc = 'Descriptions should be between 3 and 240 characters';
			}
			return errors;
		},
		initialValues: {
			title: null,
			desc: null,
		}
	});

	const submit = createSubmitHandler({
		async onSubmit(values) {
			const formInfo: VolumeForm = {
				title: values.title,
				desc: values.desc,
			};

			const response = await postReq<void>(`/volumes/create-volume?workId=${$popup.data.workId}profileId=${$account.currProfile.id}`, formInfo);
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				closePopupAndConfirm();
			}
		}
	})
</script>

<div class="w-[400px] rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="p-4">
		<h3 class="text-2xl">Add a Volume</h3>
		<form use:form>
			<TextField
				name="title"
				title="Title"
				type="text"
				placeholder="A Great Adventure"
				errorMessage={$errors.title}
				kind="primary"
			/>
			<TextArea
				name="desc"
				title="Description"
				placeholder="It was the best of times, it was the worst of times."
				errorMessage={$errors.desc}
				kind="primary"
			/>
		</form>
	</div>
	<div class="flex items-center flex-row-reverse px-4 py-2 bg-zinc-300 dark:bg-zinc-600">
		<Button kind="primary" on:click={submit} loading={$isSubmitting} loadingText="Saving...">
			<CheckLine class="button-icon" />
			<span class="button-text">Save</span>
		</Button>
		<div class="mx-0.5"></div>
		<Button on:click={closePopup} loading={$isSubmitting}>
			<CloseLine class="button-icon" />
			<span class="button-text">Cancel</span>
		</Button>
	</div>
</div>