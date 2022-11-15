<script lang="ts">
	import { Button } from "$lib/ui/util";
	import { CloseLine, CheckLine } from "svelte-remixicon";
	import { popup, closePopup, closePopupAndConfirm } from "$lib/ui/popup";
	import { createForm } from "felte";
	import { TextField, TextArea } from '$lib/ui/forms';
	import type { TagForm } from "$lib/models/tags";
	import { TagKind } from "$lib/models/tags";
	import toast from "svelte-french-toast";

	const { form, isSubmitting, createSubmitHandler, errors } = createForm({
		onSubmit: () => {
			console.log('Alt submit hit!');
		},
		initialValues: {
			name: null,
			desc: null,
			parentId: $popup.data.parentId ?? null,
			kind: TagKind.fandom
		}
	});

	const submit = createSubmitHandler({
		async onSubmit(values, context) {
			const formInfo: TagForm = {
				name: values.name,
				desc: values.desc,
				parentId: values.parentId,
				kind: values.kind,
			};

			const response = await fetch(`/api/content/tags/create-tag`, { method: 'POST', body: JSON.stringify(formInfo), headers: {
					'content-type': 'application/json'
				} });
			if (response.status === 200) {
				context.reset();
				closePopupAndConfirm(await response.json());
			} else {
				toast.error('Something went wrong! Try again in a little bit.');
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
		<h3 class="text-2xl">Add A Tag</h3>
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
			<TextField
				name="parentId"
				type="text"
				title="Parent ID (Optional)"
				placeholder="someRandomId"
				kind="primary"
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
			<span class="button-text">Create</span>
		</Button>
		<div class="mx-0.5"></div>
		<Button on:click={closePopup} disabled={$isSubmitting}>
			<CloseLine class="button-icon" />
			<span class="button-text">Cancel</span>
		</Button>
	</div>
</div>