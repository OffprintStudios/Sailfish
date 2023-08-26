<script lang="ts">
	import { createForm } from "felte";
	import { page } from "$app/stores";
	import { account } from "$lib/state/account.state";
	import { Editor } from "../forms";
	import { Avatar, Button } from "../util";
	import { Icon } from "svelte-remix";
	import type { CommentForm } from "$lib/models/comments";
	import type { ThreadService } from "./thread.service";
	import { stripHtml } from "string-strip-html";

	export let threadService: ThreadService;
	export let sectionId: string;
	const { replies } = threadService;
	let resetCounter = 0;

	const { form, data, reset, isSubmitting, setInitialValues } = createForm({
		async onSubmit(values, context) {
			const formData: CommentForm = {
				itemId: threadService.threadId,
				locationUrl: `${$page.url.pathname}`,
				sectionId: sectionId,
				body: values.body,
				spoiler: values.spoiler,
				repliesTo: $replies.map((comment) => comment.id)
			};

			await threadService.addComment(formData).then(() => {
				context.reset();
				resetCounter = 0;
			});
		},
		validate(values) {
			const errors = {
				body: ""
			};
			if (values.body.length < 10) {
				errors.body = "Comments must be at least 10 characters long.";
			}
			return errors;
		},
		initialValues: {
			body: "",
			spoiler: false
		}
	});

	replies.subscribe((values) => {
		let bodyValue = ``;
		for (const reply of values) {
			const strippedComment = stripHtml(reply.body, {
				onlyStripTags: ["blockquote", "script", "style", "xml"],
				stripTogetherWithTheirContents: ["blockquote", "script", "style", "xml"]
			}).result;
			const blockquote = `
				<blockquote class="quote-post">
					<span style="font-size: 0.75rem;"><a href="${$page.url.pathname}#comment-${reply.id}">${reply.profile.username} said:</a></span>
					<em>${strippedComment}</em>
				</blockquote>
			`;
			bodyValue += blockquote;
		}
		if (values.length !== 0) {
			setInitialValues({
				body: `${bodyValue}<p></p>`,
				spoiler: false
			});
			resetCounter += 1;
		} else {
			setInitialValues({
				body: "",
				spoiler: false
			});
			resetCounter = 0;
		}
		reset();
	});
</script>

<form use:form>
	<div
		class="flex items-center w-full p-2 select-none rounded-t-xl bg-zinc-200 dark:bg-zinc-700 border-b-2 border-zinc-300 dark:border-zinc-600 dark:highlight-shadowed"
	>
		<Avatar size="2.5rem" borderWidth="2px" src={$account.currProfile?.avatar} />
		<div class="mx-1"><!--separator--></div>
		<h3 class="text-xl font-medium">Add a comment</h3>
		<div class="flex-1"><!--separator--></div>
		<Button
			type="button"
			on:click={() => ($data.spoiler = !$data.spoiler)}
			isActive={$data.spoiler}
		>
			{#if $data.spoiler === true}
				<Icon name="checkbox-circle-line" class="button-icon" />
			{:else}
				<Icon name="checkbox-blank-circle-line" class="button-icon" />
			{/if}
			<span class="button-text">Spoiler</span>
		</Button>
		<div class="mx-0.5"><!--spacer--></div>
		<Button type="submit" loading={$isSubmitting} loadingText="Posting...">
			<Icon name="check-line" class="button-icon" />
			<span class="button-text">Post</span>
		</Button>
	</div>
	{#key resetCounter}
		<Editor hasHeader bind:value={$data.body} />
	{/key}
</form>
