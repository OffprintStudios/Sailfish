<script lang="ts">
	import { AddFill } from "svelte-remixicon";
	import { Button } from "$lib/ui/util";
	import DraftBlogsList from "./DraftBlogsList.svelte";
	import PendingBlogsList from "./PendingBlogsList.svelte";
	import PublishedBlogsList from "./PublishedBlogsList.svelte";
	import type { Profile } from "$lib/models/accounts";
	import { slugify } from "$lib/util/functions";

	export let profile: Profile;

	enum BlogTabs {
		Drafts,
		Pending,
		Published
	}

	let currTab = BlogTabs.Drafts;
	let currComponent = DraftBlogsList;

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
		class:active={currTab === BlogTabs.Drafts}
		on:click={() => switchTab(BlogTabs.Drafts)}
	>
		Drafts
	</button>
	<button
		class="tab-button"
		class:active={currTab === BlogTabs.Pending}
		on:click={() => switchTab(BlogTabs.Pending)}
	>
		Pending
	</button>
	<button
		class="tab-button"
		class:active={currTab === BlogTabs.Published}
		on:click={() => switchTab(BlogTabs.Published)}
	>
		Published
	</button>
	<div class="flex-1"><!--spacer--></div>
	<Button kind="primary" asLink href="/profile/{profile.id}/{slugify(profile.username)}/blogs/new">
		<AddFill class="button-icon" />
		<span class="button-text">New Blog</span>
	</Button>
</div>

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