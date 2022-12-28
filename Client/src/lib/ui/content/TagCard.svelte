<script lang="ts">
	import type { Tag } from "$lib/models/tags";
	import { abbreviate, pluralize } from "$lib/util/functions";

	export let tag: Tag;
	export let works: number;
</script>

<div
	class="flex items-center rounded-xl p-2 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed hover:bg-zinc-300 dark:hover:bg-zinc-600"
>
	<slot name="icon" />
	<div>
		<h5>{tag.name}</h5>
		<span>{abbreviate(works)} work{pluralize(works)}</span>
	</div>
</div>
