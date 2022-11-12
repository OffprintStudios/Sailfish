<script lang="ts">
	import { createEventDispatcher } from "svelte";
	import { fade } from "svelte/transition";
	import { createForm } from "felte";
	import type { Comment, CommentForm } from "$lib/models/comments";
	import { Time, Avatar, Button } from "../util";
	import { Dropdown } from "../dropdown";
	import {
		More2Line,
		ReplyLine,
		Edit2Line,
		CloseLine,
		Save2Line,
		AlarmWarningLine,
		EyeLine,
		EyeOffLine,
		CheckboxBlankCircleLine,
		CheckboxCircleLine,
		DoubleQuotesL,
	} from "svelte-remixicon";
	import { Editor } from "../forms";
	import { account } from "../../state/account.state";
	import { editComment } from "./comments.state";

	export let comment: Comment;
	export let index = 1;

	const dispatch = createEventDispatcher();
	let isEditing = false;
	let revealSpoiler = false;

	const { form, data, createSubmitHandler, isSubmitting } = createForm({
		async onSubmit() {
			console.log(`Alt submit used!`);
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
			body: comment?.body,
			spoiler: comment?.spoiler,
		}
	});

	const saveChanges = createSubmitHandler({
		async onSubmit(values, context) {
			const formData: CommentForm = {
				threadId: comment?.thread.id,
				body: values.body,
				spoiler: values.spoiler,
				repliesTo: [],
			};
			await editComment(comment?.id, $account.currProfile?.id, formData).then(() => {
				isEditing = false;
				context.reset();
			})
		}
	});

	function reply() {
		dispatch('reply', comment);
	}
</script>

<div class="flex flex-col w-full min-h-[14rem] rounded-xl my-4 bg-zinc-200 dark:bg-zinc-700" id="comment-{comment?.id}">
	<div class="flex items-center border-b-2 border-transparent dark:border-zinc-600 px-2 py-0.5">
		<Avatar src={comment?.profile.avatar} size="35px" borderWidth="2px" />
		<div class="ml-2 flex-1">
			<h5 class="text-lg font-medium relative top-1">{comment?.profile.username}</h5>
			<div class="flex items-center relative bottom-1">
				{#if comment && comment?.profile.info.tagline}
					<span class="text-xs relative top-0.5">{comment?.profile.info.tagline}</span>
				{:else}
					<span class="text-xs relative top-0.5">Member</span>
				{/if}
				<span class="mx-1">•</span>
				<span class="text-xs relative top-0.5">
					<Time timestamp={comment?.createdAt} relative live />
				</span>
			</div>
		</div>
		{#if $account.account && $account.currProfile && $account.currProfile.id === comment?.profile.id}
			{#if isEditing}
				<Button type="button" on:click={() => $data.spoiler = !$data.spoiler} isActive={$data.spoiler}>
					{#if $data.spoiler === true}
						<CheckboxCircleLine class="button-icon" />
					{:else}
						<CheckboxBlankCircleLine class="button-icon" />
					{/if}
					<span class="button-text">Spoiler</span>
				</Button>
				<div class="mx-0.5"><!--spacer--></div>
				<Button on:click={saveChanges} loading={$isSubmitting} loadingText="Saving...">
					<Save2Line class="button-icon" />
					<span class="button-text">Save</span>
				</Button>
				<div class="mx-0.5"><!--spacer--></div>
				<Button on:click={() => isEditing = !isEditing}>
					<CloseLine class="button-icon" />
					<span class="button-text">Cancel</span>
				</Button>
			{:else}
				{#if comment?.spoiler}
					<Button on:click={() => revealSpoiler = !revealSpoiler} isActive={revealSpoiler}>
						{#if revealSpoiler}
							<EyeOffLine class="button-icon" />
							<span class="button-text">Hide</span>
						{:else}
							<EyeLine class="button-icon" />
							<span class="button-text">Reveal</span>
						{/if}
					</Button>
					<div class="mx-0.5"></div>
				{/if}
				<Button on:click={() => isEditing = !isEditing}>
					<Edit2Line class="button-icon" />
					<span class="button-text">Edit</span>
				</Button>
			{/if}
		{:else if $account.account && $account.currProfile}
			<Button on:click={reply}>
				<ReplyLine class="button-icon" />
				<span class="button-text">Reply</span>
			</Button>
			<div class="mx-0.5"><!--separator--></div>
			{#if comment?.spoiler}
				<Button on:click={() => revealSpoiler = !revealSpoiler} isActive={revealSpoiler}>
					{#if revealSpoiler}
						<EyeOffLine class="button-icon" />
						<span class="button-text">Hide</span>
					{:else}
						<EyeLine class="button-icon" />
						<span class="button-text">Reveal</span>
					{/if}
				</Button>
				<div class="mx-0.5"></div>
			{/if}
			<Dropdown position="bottom-end">
				<svelte:fragment slot="button">
					<More2Line class="button-icon no-text" />
				</svelte:fragment>
				<svelte:fragment slot="items">
					<button type="button">
						<DoubleQuotesL class="mr-2" />
						<span>Add to multi-quote</span>
					</button>
					<div class="my-0.5"><!--spacer--></div>
					<button type="button">
						<AlarmWarningLine class="mr-2" />
						<span>Report</span>
					</button>
				</svelte:fragment>
			</Dropdown>
		{:else}
			{#if comment?.spoiler}
				<Button on:click={() => revealSpoiler = !revealSpoiler} isActive={revealSpoiler}>
					{#if revealSpoiler}
						<EyeOffLine class="button-icon" />
						<span class="button-text">Hide</span>
					{:else}
						<EyeLine class="button-icon" />
						<span class="button-text">Reveal</span>
					{/if}
				</Button>
				<div class="mx-0.5"></div>
			{/if}
		{/if}
	</div>
	{#if isEditing}
		<form use:form in:fade|local={{ delay: 0, duration: 150 }}>
			<Editor hasHeader bind:value={$data.body} />
		</form>
	{:else}
		<div class="flex-1 relative" in:fade|local={{ delay: 0, duration: 150 }}>
			{#if comment?.spoiler && revealSpoiler !== true}
				<div
					class="absolute flex flex-col items-center justify-center w-full h-full bg-zinc-200 dark:bg-zinc-700"
					transition:fade|local={{ delay: 0, duration: 100 }}
				>
					<EyeOffLine size="36px" />
					<span class="text-sm all-small-caps font-bold tracking-wider">Potential Spoilers</span>
				</div>
			{/if}
			<div class="comment-body px-4">
				{@html comment?.body}
			</div>
		</div>
		<div class="flex items-center p-0.5 pb-1" in:fade|local={{ delay: 0, duration: 150 }}>
			<div>
				<!--TODO: add actual link here-->
				<a
					class="block mx-2 relative text-xs"
					href="#comment-{comment?.id}"
				>
					#{index}
				</a>
			</div>
			<div class="flex-1 text-xs relative top-0.5 pb-1 italic">
				{#if comment?.history.length !== 0}
					Last edited <Time timestamp={comment?.history[comment?.history.length - 1].createdAt} relative live />
				{/if}
			</div>
		</div>
	{/if}
</div>