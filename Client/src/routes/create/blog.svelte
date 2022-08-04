<script lang="ts">
	import { createForm } from "felte";
	import { TextField, Editor } from "$lib/ui/forms";
	import { Button } from "$lib/ui/util";
	import { CloseLine, Save2Line } from "svelte-remixicon";

	const { form, errors, data, isSubmitting } = createForm({
		onSubmit: (values) => {
			console.log(values);
		}
	});
</script>

<div class="w-11/12 my-6 mx-auto max-w-3xl">
	<h1 class="text-4xl text-center">Create a New Blog</h1>
	<form use:form>
		<TextField
			name="title"
			type="text"
			title="Title"
			placeholder="Just Catching Up"
			errorMessage={$errors.username}
		/>
		<div class="my-4"></div>
		<Editor label="Content" bind:value={$data.body} />
		<div class="flex items-center justify-center mt-6">
			<Button type="button">
				<CloseLine class="button-icon" />
				<span class="button-text">Cancel</span>
			</Button>
			<div class="mx-2"></div>
			<Button type="submit" isLoading={$isSubmitting} loadingText="Saving...">
				<Save2Line class="button-icon" />
				<span class="button-text">Save</span>
			</Button>
		</div>
	</form>
</div>