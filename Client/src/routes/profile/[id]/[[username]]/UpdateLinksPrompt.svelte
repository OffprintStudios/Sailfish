<script lang="ts">
	import { popup, closePopup, closePopupAndConfirm } from "$lib/ui/popup";
	import { Button } from "$lib/ui/util";
	import { CheckLine, CloseLine } from "svelte-remixicon";

	let links = $popup.data as Map<string, string>;
</script>

<div class="rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="p-4 flex items-center">
		<h3 class="text-2xl">Update Profile Links</h3>
		<Button on:click={closePopup}><CloseLine class="button-icon" size="24px" /></Button>
	</div>
	<div class="grid grid-cols-4">
		{#each Object.keys(links) as key}
			<div />
		{/each}
	</div>
	<div class="flex items-center flex-row-reverse px-4 py-2 bg-zinc-300 dark:bg-zinc-600">
		<Button kind="primary" on:click={closePopupAndConfirm}>
			<CheckLine class="button-icon" />
			<span class="button-text">Yes</span>
		</Button>
		<div class="mx-0.5" />
		<Button on:click={closePopup}>
			<CloseLine class="button-icon" />
			<span class="button-text">No</span>
		</Button>
	</div>
</div>
