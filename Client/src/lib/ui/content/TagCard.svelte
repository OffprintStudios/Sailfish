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
		<div
			class="flex items-center text-zinc-400 italic"
			style="font-family: var(--header-text);"
		>
			{#if tag.parent && tag.parent.name}
				<span>{tag.parent.name}</span>
				<span class="mx-1">/</span>
			{/if}
			<span>{abbreviate(works)} work{pluralize(works)}</span>
		</div>
		<h5 class="text-2xl relative -top-0.5" style="color: var(--text-color);">{tag.name}</h5>
		{#if tag.desc}
			<div class="text-xs mx-2">
				{@html tag.desc}
			</div>
		{/if}
	</div>
</div>
