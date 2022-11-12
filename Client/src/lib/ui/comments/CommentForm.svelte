<script lang="ts">
	import { createForm } from "felte";
	import { account } from "../../state/account.state";
	import { addComment } from "./comments.state";
	import { Editor } from "../forms";
	import { Avatar, Button } from "../util";
	import { CheckboxBlankCircleLine, CheckboxCircleLine, CheckLine } from "svelte-remixicon";
	import type { CommentForm } from "../../models/comments";

	export let threadId: string;

	const { form, data, isSubmitting } = createForm({
		async onSubmit(values, context) {
			const formData: CommentForm = {
				threadId: threadId,
				body: values.body,
				spoiler: values.spoiler,
				repliesTo: [],
			};

			await addComment($account.currProfile?.id, formData).then(() => {
				context.reset();
			});
		},
		validate(values) {
			const errors = {
				body: '',
			};
			if (!values.body || values.body.length < 10) {
				errors.body = "Comments must be at least 10 characters long.";
			}
			return errors;
		},
		initialValues: {
			body: '',
			spoiler: false,
		}
	})
</script>

<form use:form>
	<div class="flex items-center w-full p-2 select-none rounded-t-xl bg-zinc-200 dark:bg-zinc-700 border-b-2 border-zinc-300 dark:border-zinc-600 dark:highlight-shadowed">
		<Avatar size="2.5rem" borderWidth="2px" src={$account.currProfile?.avatar} />
		<div class="mx-1"><!--separator--></div>
		<h3 class="text-xl font-medium">Add a comment</h3>
		<div class="flex-1"><!--separator--></div>
		<Button type="button" on:click={() => $data.spoiler = !$data.spoiler} isActive={$data.spoiler}>
			{#if $data.spoiler === true}
				<CheckboxCircleLine class="button-icon" />
			{:else}
				<CheckboxBlankCircleLine class="button-icon" />
			{/if}
			<span class="button-text">Spoiler</span>
		</Button>
		<div class="mx-0.5"><!--spacer--></div>
		<Button type="submit" loading={$isSubmitting} loadingText="Posting...">
			<CheckLine class="button-icon" />
			<span class="button-text">Post</span>
		</Button>
	</div>
	<Editor hasHeader bind:value={$data.body} />
</form>