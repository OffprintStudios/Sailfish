<script lang="ts">
	import { fade, slide } from "svelte/transition";
	import { createForm } from "felte";
	import { AddFill, CloseLine, Save3Line } from "svelte-remixicon";
	import { Button } from "$lib/ui/util";
	import { Editor, TextField } from "$lib/ui/forms";
	import type { BlogForm } from "$lib/models/content";
	import { ApprovalStatus, ContentRating } from "$lib/models/content";
	import { account } from "$lib/state/account.state";
	import toast from "svelte-french-toast";
	import { ContentFilter } from "$lib/util/constants";
	import { BlogCard } from "$lib/ui/content";

	enum BlogTabs {
		Drafts,
		Pending,
		Published
	}

	let currTab = BlogTabs.Drafts;
	let showForm = false;

	const { form, errors, data, createSubmitHandler, isSubmitting, isDirty, reset } = createForm();

	const submitHandler = createSubmitHandler({
		async onSubmit(values, { reset }) {
			const formInfo: BlogForm = {
				title: values.title,
				body: values.body,
				rating: ContentRating.Everyone
			}

			const response = await fetch(`/api/content/blogs/create-blog?profileId=${$account.currProfile.id}`, { method: 'POST', body: JSON.stringify(formInfo) });
			if (response.status === 200) {
				reset();
				showForm = false;
				console.log(response);
			} else {
				toast.error('Something went wrong! Try again in a little bit.');
			}
		},
	})

	function closeForm() {
		if (!$isDirty) {
			reset();
			showForm = false;
		}
	}

	async function fetchBlogs() {
		switch (currTab) {
			case BlogTabs.Drafts: {
				const response = await fetch(
					`/api/content/blogs/fetch-blogs?profileId=${$account.currProfile.id}&status=${ApprovalStatus.draft}&filter=${ContentFilter.everything}`
				);
				return await response.json();
			}
			case BlogTabs.Published: {
				const response = await fetch(
					`/api/content/blogs/fetch-blogs?profileId=${$account.currProfile.id}&status=${ApprovalStatus.published}&filter=${ContentFilter.everything}`
				);
				return await response.json();
			}
			default:
				console.log('Default hit!');
				break;
		}
	}
</script>

<div class="blogs-tools">
	<button
		class="tab-button"
		disabled={showForm}
		class:active={currTab === BlogTabs.Drafts}
		on:click={() => currTab = BlogTabs.Drafts}
	>
		Drafts
	</button>
	<button
		class="tab-button"
		disabled={showForm}
		class:active={currTab === BlogTabs.Pending}
		on:click={() => currTab = BlogTabs.Pending}
	>
		Pending
	</button>
	<button
		class="tab-button"
		disabled={showForm}
		class:active={currTab === BlogTabs.Published}
		on:click={() => currTab = BlogTabs.Published}
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
			<Button on:click={closeForm}>
				<CloseLine class="button-icon" />
				<span class="button-text">Cancel</span>
			</Button>
		</div>
	{:else}
		<div in:fade|local={{ delay: 0, duration: 200 }}>
			<Button on:click={() => showForm = !showForm}>
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

{#key currTab}
	{#await fetchBlogs()}
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	{:then blogs}
		<div class="my-6 w-11/12 mx-auto">
			{#each blogs.items as blog}
				<div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
					<BlogCard blog={blog} />
				</div>
			{:else}
				<div class="empty">
					<h3>You haven't added anything yet.</h3>
					<p>Make or publish a blog and it'll show up here.</p>
				</div>
			{/each}
		</div>
	{:catch error}
		<div class="empty">
			<h3>An error has occurred!</h3>
			<p>Could not fetch blogs. Please try again in a little bit.</p>
		</div>
	{/await}
{/key}

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