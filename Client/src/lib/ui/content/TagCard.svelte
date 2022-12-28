<script lang="ts">
	import type { Tag } from "$lib/models/tags";
	import { abbreviate, pluralize, slugify } from "$lib/util/functions";

	export let tag: Tag;
	export let works: number;
</script>

<div
	class="flex items-center rounded-xl p-2 relative bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed hover:bg-zinc-300 dark:hover:bg-zinc-600"
>
	<a class="absolute h-full w-full z-[2]" href="/explore/tags/{tag.id}/{slugify(tag.name)}">
		<!--intentionally left blank-->
	</a>
	<slot name="icon" />
	<div>
		<span class="text-zinc-400 italic" style="font-family: var(--header-text);">
			{abbreviate(works)} work{pluralize(works)}
		</span>
		<h5 class="text-2xl relative -top-0.5" style="color: var(--text-color);">{tag.name}</h5>
		{#if tag.desc}
			<span>
				{@html tag.desc}
			</span>
		{/if}
	</div>
</div>
