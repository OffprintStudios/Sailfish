<script lang="ts">
	import { Button } from "$lib/ui/util";
	import { CloseLine, CheckLine } from "svelte-remixicon";
	import { closePopup, closePopupAndConfirm } from "$lib/ui/popup";
</script>

<div class="rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed" style="box-shadow: var(--dropshadow);">
	<div class="p-4">
		<h3 class="text-2xl">Log Out?</h3>
		<p>
			Are you sure you want to log out?
		</p>
	</div>
	<div class="flex items-center flex-row-reverse px-4 py-2 bg-zinc-300 dark:bg-zinc-600">
		<Button kind="primary" on:click={closePopupAndConfirm}>
			<CheckLine class="button-icon" />
			<span class="button-text">Okay</span>
		</Button>
		<div class="mx-0.5"></div>
		<Button on:click={closePopup}>
			<CloseLine class="button-icon" />
			<span class="button-text">Cancel</span>
		</Button>
	</div>
</div>