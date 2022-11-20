<script lang="ts">
	import { profileState } from "$lib/state/profile.state";
	import { slugify } from "$lib/util/functions";
	import { AddFill } from "svelte-remixicon";
	import { Button } from "$lib/ui/util";
	import DraftList from "./DraftList.svelte";
	import PendingList from "./PendingList.svelte";
	import PublishedList from "./PublishedList.svelte";

	enum WorkTabs {
		Drafts,
		Pending,
		Published,
	}

	let currTab = WorkTabs.Drafts;
	let currComponent = DraftList;

	function switchTab(newTab: WorkTabs) {
		currTab = newTab;
		switch (newTab) {
			case WorkTabs.Drafts:
				currComponent = DraftList;
				break;
			case WorkTabs.Pending:
				currComponent = PendingList;
				break;
			case WorkTabs.Published:
				currComponent = PublishedList;
				break;
		}
	}
</script>

<div class="work-tools">
	<button
		class="tab-button"
		class:active={currTab === WorkTabs.Drafts}
		on:click={() => switchTab(WorkTabs.Drafts)}
	>
		Drafts
	</button>
	<button
		class="tab-button"
		class:active={currTab === WorkTabs.Pending}
		on:click={() => switchTab(WorkTabs.Pending)}
	>
		Pending
	</button>
	<button
		class="tab-button"
		class:active={currTab === WorkTabs.Published}
		on:click={() => switchTab(WorkTabs.Published)}
	>
		Published
	</button>
	<div class="flex-1"><!--spacer--></div>
	<Button kind="primary" asLink href="/profile/{$profileState.id}/{slugify($profileState.username)}/works/new">
		<AddFill class="button-icon" />
		<span class="button-text">New Work</span>
	</Button>
</div>

<svelte:component this={currComponent} />

<style lang="scss">
	div.work-tools {
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
