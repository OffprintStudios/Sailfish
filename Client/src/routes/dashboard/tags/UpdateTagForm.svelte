<script lang="ts">
	import { Button } from "$lib/ui/util";
	import { CloseLine, CheckLine } from "svelte-remixicon";
	import { popup, closePopup, closePopupAndConfirm } from "$lib/ui/popup";
	import { createForm } from "felte";
	import { TextField, TextArea } from '$lib/ui/forms';
	import type { Tag, TagForm } from "$lib/models/tags";
	import { TagKind } from "$lib/models/tags";
	import { patchReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import toast from "svelte-french-toast";

	const tag: Tag = $popup.data;

	const { form, isSubmitting, createSubmitHandler, errors } = createForm({
		onSubmit: () => {
			console.log('Alt submit hit!');
		},
		initialValues: {
			name: tag.name,
			desc: tag.desc,
			kind: tag.kind
		}
	});

	const submit = createSubmitHandler({
		async onSubmit(values, context) {
			const formInfo: TagForm = {
				name: values.name,
				desc: values.desc,
				kind: values.kind,
			};

			const response = await patchReq<Tag>(`/tags/update-tag/${tag.id}`, formInfo);
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				context.reset();
				closePopupAndConfirm(response as Tag);
			}
		},
		validate: (values) => {
			const errors = {
				name: '',
				desc: '',
			};

			if (!values.name || (values.name.length < 3 || values.name.length > 120)) {
				errors.name = 'Names must be between 3 and 120 characters';
			}

			if (values.desc && (values.desc.length < 3 || values.desc.length > 120)) {
				errors.name = 'Descriptions must be between 3 and 120 characters';
			}

			return errors;
		}
	})
</script>

<div class="rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="p-4">
		<h3 class="text-2xl">Update Tag</h3>
		<form use:form>
			<TextField
				name="name"
				type="text"
				title="Name"
				placeholder="A Brand New Tag"
				kind="primary"
				errorMessage={$errors.name}
			/>
			<TextArea
				name="desc"
				title="Description (Optional)"
				placeholder="This is a whole new set of opportunities."
				kind="primary"
				errorMessage={$errors.desc}
			/>
			<label
				for="kind"
				class="text-[0.625rem] relative z-20 top-[0.15rem] left-1 py-0.5 px-1 rounded-t-lg font-semibold tracking-wider uppercase"
			>
				Tag Kind
			</label>
			<select name="kind" id="kind" class="w-full border-transparent bg-zinc-300 dark:bg-zinc-600 rounded-xl">
				<option value={TagKind.fandom}>{TagKind.fandom}</option>
				<option value={TagKind.genre}>{TagKind.genre}</option>
				<option value={TagKind.warning}>{TagKind.warning}</option>
				<option value={TagKind.user}>{TagKind.user}</option>
			</select>
		</form>
	</div>
	<div class="flex items-center flex-row-reverse px-4 py-2 bg-zinc-300 dark:bg-zinc-600">
		<Button kind="primary" on:click={submit} loading={$isSubmitting} loadingText="Saving...">
			<CheckLine class="button-icon" />
			<span class="button-text">Save</span>
		</Button>
		<div class="mx-0.5"></div>
		<Button on:click={closePopup} disabled={$isSubmitting}>
			<CloseLine class="button-icon" />
			<span class="button-text">Cancel</span>
		</Button>
	</div>
</div>