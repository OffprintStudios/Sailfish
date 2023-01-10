<script lang="ts">
	import { Button } from "$lib/ui/util";
	import { CloseLine } from "svelte-remixicon";
	import { popup, closePopup } from "$lib/ui/popup";
	import type { Tag } from "$lib/models/tags";
	import { TagBadge } from "$lib/ui/content/index";

	const tags: Tag[] = $popup.data.tags;
</script>

<div
	class="rounded-xl overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed max-w-lg p-4"
>
	<div class="flex items-center">
		<h3 class="text-2xl">All Tags</h3>
		<div class="flex-1"><!--spacer--></div>
		<Button on:click={closePopup}>
			<CloseLine size="24px" class="button-icon no-text" />
		</Button>
	</div>
	<div class="flex items-center flex-wrap">
		{#each tags as tag}
			<TagBadge {tag} kind={tag.kind} />
			<div class="mx-[0.075rem]"><!--spacer--></div>
		{/each}
	</div>
</div>
