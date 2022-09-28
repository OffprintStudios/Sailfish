<script lang="ts">
	import { fade, slide } from "svelte/transition";
	import { createForm } from "felte";
	import { AddFill, CloseLine, Save3Line } from "svelte-remixicon";
	import { Button } from "$lib/ui/util";
	import { Editor, TextField } from "$lib/ui/forms";
	import type { BlogForm } from "$lib/models/content";
	import { ContentRating } from "$lib/models/content";
	import { account } from "$lib/state/account.state";
	import toast from "svelte-french-toast";
	import DraftBlogsList from "./DraftBlogsList.svelte";
	import PendingBlogsList from "./PendingBlogsList.svelte";
	import PublishedBlogsList from "./PublishedBlogsList.svelte";

	enum BlogTabs {
		Drafts,
		Pending,
		Published
	}

	let currTab = BlogTabs.Drafts;
	let currComponent = DraftBlogsList;
	let showForm = false;

	const { form, errors, data, createSubmitHandler, isSubmitting } = createForm();

	const submitHandler = createSubmitHandler({
		async onSubmit(values, { reset }) {
			currComponent = null;
			const formInfo: BlogForm = {
				title: values.title,
				body: values.body,
				rating: ContentRating.Everyone
			}

			const response = await fetch(`/api/content/blogs/create-blog?profileId=${$account.currProfile.id}`, { method: 'POST', body: JSON.stringify(formInfo) });
			if (response.status === 200) {
				reset();
				showForm = false;
				currComponent = DraftBlogsList;
			} else {
				toast.error('Something went wrong! Try again in a little bit.');
				showForm = false;
				currComponent = DraftBlogsList;
			}
		},
	})

	function toggleForm() {
		if (showForm === true) {
			showForm = false;
			currComponent = DraftBlogsList;
		} else {
			showForm = true;
			currComponent = null;
		}
	}

	function switchTab(newTab: BlogTabs) {
		currTab = newTab;
		switch (newTab) {
			case BlogTabs.Drafts:
				currComponent = DraftBlogsList;
				break;
			case BlogTabs.Pending:
				currComponent = PendingBlogsList;
				break;
			case BlogTabs.Published:
				currComponent = PublishedBlogsList;
				break;
		}
	}
</script>

<div class="blogs-tools">
	<button
		class="tab-button"
		disabled={showForm}
		class:active={currTab === BlogTabs.Drafts}
		on:click={() => switchTab(BlogTabs.Drafts)}
	>
		Drafts
	</button>
	<button
		class="tab-button"
		disabled={showForm}
		class:active={currTab === BlogTabs.Pending}
		on:click={() => switchTab(BlogTabs.Pending)}
	>
		Pending
	</button>
	<button
		class="tab-button"
		disabled={showForm}
		class:active={currTab === BlogTabs.Published}
		on:click={() => switchTab(BlogTabs.Published)}
	>
		Published
	</button>
	<div class="flex-1"><!--spacer--></div>
	{#if showForm}
		<div class="flex items-center" in:fade|local={{ delay: 0, duration: 200 }}>
			<Button on:click={submitHandler} loading={$isSubmitting}>
				<Save3Line class="button-icon" />
				<span class="button-text">Save</span>
			</Button>
			<div class="mx-0.5"><!--spacer--></div>
			<Button on:click={toggleForm}>
				<CloseLine class="button-icon" />
				<span class="button-text">Cancel</span>
			</Button>
		</div>
	{:else}
		<div in:fade|local={{ delay: 0, duration: 200 }}>
			<Button on:click={toggleForm}>
				<AddFill class="button-icon" />
				<span class="button-text">New Blog</span>
			</Button>
		</div>
	{/if}
</div>

{#if showForm}
	<form class="max-w-4xl mx-auto" transition:slide|local={{ delay: 0, duration: 200 }} use:form>
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
{/if}

<svelte:component this={currComponent} />

<style lang="scss">
	div.blogs-tools {
		@apply flex items-center w-11/12 mx-auto;
		button.tab-button {
			@apply px-4 py-2 flex items-center justify-center border-b-4 border-b-transparent font-bold all-small-caps text-lg tracking-wide transition;
			&:hover {
				border-bottom-color: var(--accent-light);
			}
			&.active {
				border-bottom-color: var(--accent);
			}
		}
	}
</style>