<script lang="ts">
	import { createForm } from "felte";
	import type { Blog } from "$lib/models/content";
	import { TextField, Editor } from "$lib/ui/forms";

	export let blog: Blog;

	const { form, errors, data } = createForm({
		initialValues: {
			title: blog.title,
			body: blog.body,
		}
	});
</script>

<form use:form>
	<TextField
		name="title"
		type="text"
		title="Title"
		placeholder="Just Catching Up"
		errorMessage={$errors.title}
	/>
	<div class="my-4"></div>
	<Editor label="Content" bind:value={$data.body} />
</form>