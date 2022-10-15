<script lang="ts">
	import { Button } from "../util";
	import { CloseLine } from "svelte-remixicon";
	import { closePopup } from "../popup";
	import SelectProfile from "./SelectProfile.svelte";
	import AddProfile from "./AddProfile.svelte";

	enum FormTabs {
		SelectProfile,
		AddProfile,
	}

	let currTab = FormTabs.SelectProfile;
</script>

<div class="rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed" style="box-shadow: var(--dropshadow);">
	<div class="flex items-center px-2 py-2 bg-zinc-300 dark:bg-zinc-600">
		<button
			class="tab-button"
			on:click={() => currTab = FormTabs.SelectProfile}
			class:active={currTab === FormTabs.SelectProfile}
		>
			Profiles
		</button>
		<button
			class="tab-button"
			on:click={() => currTab = FormTabs.AddProfile}
			class:active={currTab === FormTabs.AddProfile}
		>
			Add New
		</button>
		<div class="flex-1"><!--spacer--></div>
		<Button on:click={closePopup}>
			<CloseLine size="28px" class="button-icon no-text" />
		</Button>
	</div>
	<div>
		{#if currTab === FormTabs.SelectProfile}
			<SelectProfile />
		{:else}
			<AddProfile />
		{/if}
	</div>
</div>

<style lang="scss">
	button.tab-button {
		@apply px-4 py-2 flex items-center justify-center border-b-4 border-b-transparent rounded-t-xl font-bold all-small-caps text-lg tracking-wide transition;
		&:hover {
			border-bottom-color: var(--accent-light);
		}
		&.active {
			border-bottom-color: var(--accent);
		}
	}
</style>