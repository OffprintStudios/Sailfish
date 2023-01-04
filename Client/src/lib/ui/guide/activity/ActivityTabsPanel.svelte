<script lang="ts">
	import ActivityPanel from "$lib/ui/guide/activity/ActivityPanel.svelte";
	import SystemPanel from "$lib/ui/guide/activity/SystemPanel.svelte";

	enum ActivityTabs {
		Activity,
		System
	}

	let currTab = ActivityTabs.Activity;
	let currPanel = ActivityPanel;

	function switchTab(newTab: ActivityTabs) {
		switch (newTab) {
			case ActivityTabs.Activity:
				currTab = newTab;
				currPanel = ActivityPanel;
				break;
			case ActivityTabs.System:
				currTab = newTab;
				currPanel = SystemPanel;
				break;
		}
	}
</script>

<div class="panel-container flex flex-col" style="height: calc(100vh - 96px);">
	<div class="tab-row bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
		<button
			class:active={currTab === ActivityTabs.Activity}
			on:click={() => switchTab(ActivityTabs.Activity)}
		>
			<span> Activity </span>
		</button>
		<button
			class:active={currTab === ActivityTabs.System}
			on:click={() => switchTab(ActivityTabs.System)}
		>
			<span> System </span>
		</button>
	</div>
	<svelte:component this={currPanel} />
</div>

<style lang="scss">
	@import url("../Guide.scss");

	div.tab-row {
		@apply flex items-center rounded-xl mx-6 p-0.5;
		button {
			@apply py-1 w-1/2 rounded-xl font-bold all-small-caps tracking-wider text-lg transition;
			span {
				@apply relative -top-0.5;
			}
			&:hover,
			&.active {
				@apply text-white;
				background: var(--accent);
			}
			&.active:hover {
				background: var(--accent-light);
			}
		}
	}
</style>
