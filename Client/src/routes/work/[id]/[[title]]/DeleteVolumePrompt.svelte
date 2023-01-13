<script lang="ts">
	import { Button } from "$lib/ui/util";
	import { CloseLine, CheckLine } from "svelte-remixicon";
	import { closePopup, closePopupAndConfirm } from "$lib/ui/popup";
</script>

<div class="rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="p-4">
		<h3 class="text-2xl">Head's Up</h3>
		<p>
			Deleting this volume will detach any sections you've added<br />to it. Those sections
			<strong>are not deleted.</strong>
		</p>
		<p>Are you sure you want to proceed?</p>
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
