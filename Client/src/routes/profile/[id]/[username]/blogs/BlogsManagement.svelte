<script lang="ts">
	import { slide, fade } from "svelte/transition";
	import { createForm } from "felte";
	import { AddFill, Save3Line, CloseLine } from "svelte-remixicon";
	import { Button } from "../../../../../lib/ui/util";
	import { TextField, Editor } from "../../../../../lib/ui/forms";

	enum BlogTabs {
		All,
		Drafts,
		Pending,
		Published
	}

	let currTab = BlogTabs.All;
	let showForm = false;

	const { form, errors, data } = createForm({
		onSubmit: (values) => {
			console.log(values);
		}
	});
</script>

<div class="blogs-tools">
	<button
		class="tab-button"
		disabled={showForm}
		class:active={currTab === BlogTabs.All}
		on:click={() => currTab = BlogTabs.All}
	>
		All
	</button>
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
		<div class="flex items-center" in:fade={{ delay: 0, duration: 200 }}>
			<Button>
				<Save3Line class="button-icon" />
				<span class="button-text">Save</span>
			</Button>
			<div class="mx-0.5"><!--spacer--></div>
			<Button on:click={() => showForm = !showForm}>
				<CloseLine class="button-icon" />
				<span class="button-text">Cancel</span>
			</Button>
		</div>
	{:else}
		<div in:fade={{ delay: 0, duration: 200 }}>
			<Button on:click={() => showForm = !showForm}>
				<AddFill class="button-icon" />
				<span class="button-text">New Blog</span>
			</Button>
		</div>
	{/if}
</div>

{#if showForm}
	<form class="max-w-4xl mx-auto" transition:slide={{ delay: 0, duration: 200 }} use:form>
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