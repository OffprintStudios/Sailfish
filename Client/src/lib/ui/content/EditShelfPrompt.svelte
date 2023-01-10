<script lang="ts">
	import { createForm } from "felte";
	import { TextField, TextArea } from "$lib/ui/forms";
	import { Button } from "$lib/ui/util";
	import { closePopup, closePopupAndConfirm, popup } from "$lib/ui/popup";
	import { Save2Line, CloseLine } from "svelte-remixicon";
	import type { ShelfForm, Shelf } from "$lib/models/content/library";
	import toast from "svelte-french-toast";
	import { patchReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import { account } from "../../state/account.state";

	const shelf: Shelf = $popup.data.shelf;

	const { form, errors, isSubmitting, createSubmitHandler } = createForm<ShelfForm>({
		validate(values) {
			const errors = {
				name: '',
				desc: '',
			};
			if (!values.name || values.name.length < 3 || values.name.length > 120) {
				errors.name = 'Names should be between 3 and 120 characters';
			}
			if (values.desc && (values.desc.length < 3 || values.desc.length > 240)) {
				errors.desc = 'Descriptions should be between 3 and 240 characters';
			}
			return errors;
		},
		initialValues: {
			name: shelf.name,
			desc: shelf.desc,
			isPublic: shelf.isPublic,
		}
	});

	const submit = createSubmitHandler({
		async onSubmit(values) {
			const formInfo: ShelfForm = {
				name: values.name,
				desc: values.desc,
				isPublic: values.isPublic,
			};

			const response = await patchReq<Shelf>(`/shelves/update?shelfId=${shelf.id}&profileId=${$account.currProfile.id}`, formInfo);
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				closePopupAndConfirm(response as Shelf);
			}
		}
	})
</script>

<div class="w-[400px] rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="p-4">
		<h3 class="text-2xl">Add a Shelf</h3>
		<form use:form>
			<TextField
				name="name"
				title="Title"
				type="text"
				placeholder="My Favorite Things"
				errorMessage={$errors.name}
				kind="primary"
			/>
			<TextArea
				name="desc"
				title="Description"
				placeholder="Everything I hold dear in the universe"
				errorMessage={$errors.desc}
				kind="primary"
			/>
		</form>
	</div>
	<div class="flex items-center flex-row-reverse px-4 py-2 bg-zinc-300 dark:bg-zinc-600">
		<Button kind="primary" on:click={submit} loading={$isSubmitting} loadingText="Saving...">
			<Save2Line class="button-icon" />
			<span class="button-text">Save</span>
		</Button>
		<div class="mx-0.5"></div>
		<Button on:click={closePopup} loading={$isSubmitting}>
			<CloseLine class="button-icon" />
			<span class="button-text">Cancel</span>
		</Button>
	</div>
</div>