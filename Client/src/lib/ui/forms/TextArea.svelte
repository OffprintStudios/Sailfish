<script lang="ts">
	import { fade } from "svelte/transition";

	export let name = 'Textarea';
	export let title = 'Textarea';
	export let value = null;
	export let placeholder = 'A Placeholder';
	export let errorMessage = null;
	export let kind: 'primary' | 'normal' = 'normal';

	let background = "bg-zinc-200 dark:bg-zinc-700";
	if (kind === 'primary') {
		background = "bg-zinc-300 dark:bg-zinc-600";
	}
</script>

<div class="text-area">
	<label
		for={name}
		class="text-[0.625rem] relative z-20 top-[0.15rem] left-1 py-0.5 px-1 rounded-t-lg font-semibold tracking-wider uppercase"
	>
		{title}
	</label>
	<textarea
		id={name}
		{title}
		{name}
		{value}
		{placeholder}
		class="{background} dark:placeholder-zinc-400 dark:highlight-shadowed"
		class:error={!!errorMessage}
		on:change
		on:keypress
	></textarea>
	{#if !!errorMessage && errorMessage !== ''}
        <span
			class="text-[0.625rem] text-red-500 relative -top-1 left-2"
			transition:fade|local={{ delay: 0, duration: 350 }}>{errorMessage}</span
		>
	{/if}
</div>

<style lang="scss">
	div.text-area {
		@apply w-full my-2 relative z-10 rounded-lg border-b-2 border-transparent overflow-hidden;

		textarea {
			@apply w-full relative min-h-[96px] px-3 pt-3 pb-2.5 border-b-2 rounded-lg border-transparent transition;
			&:focus {
				@apply ring-0 shadow-md;
				border-bottom: 2px solid var(--borders);
			}

			&.error {
				@apply border-b-2 border-red-500;
			}
		}
	}
</style>