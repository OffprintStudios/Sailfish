<script lang="ts">
	import { scale } from "svelte/transition";
	import { abbreviate } from "$lib/util/functions";

	export let value = 0;
</script>

<div class="absolute flex -top-1 -right-1" in:scale={{ delay: 0, duration: 250 }}>
	<span class="absolute animate-ping w-full h-full rounded-full bg-red-600"
		><!--ping animation--></span
	>
	<span
		class="inline-flex relative rounded-full bg-red-600 text-xs px-1.5 py-[0.075rem]"
		style="font-family: var(--header-text);"
	>
		<span class="relative top-[0.025rem]">{abbreviate(value)}</span>
	</span>
</div>
