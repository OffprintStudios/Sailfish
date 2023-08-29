<script lang="ts">
	import type { Tag } from "$lib/models/tags";
	import { TagKind } from "$lib/models/tags";
	import { Icon } from "svelte-remix";

	export let size: "small" | "medium" | "large" = "medium";
	export let hasIcon = true;
	export let kind: TagKind;
	export let tag: Tag;

	const iconSize = "1rem";
</script>

<button
	class="tag-pill"
	type="button"
	class:fandom={kind === TagKind.fandom}
	class:warning={kind === TagKind.warning}
	class:genre={kind === TagKind.genre}
	class:user={kind === TagKind.user}
	class:small-text={size === "small"}
	class:big-text={size === "large"}
	class:no-icon={!hasIcon || kind === TagKind.fandom}
	on:click
>
	{#if kind === TagKind.genre}
		{#if tag.name === "Comedy"}
			<Icon name="emotion-laugh-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Drama"}
			<Icon name="file-paper-2-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Erotica"}
			<Icon name="door-closed-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Fantasy"}
			<Icon name="magic-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Horror"}
			<Icon name="ghost-2-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Mystery"}
			<Icon name="search-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Romance"}
			<Icon name="hearts-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Science Fiction"}
			<Icon name="aliens-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Slice of Life"}
			<Icon name="home-3-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Speculative Fiction"}
			<Icon name="meteor-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Thriller"}
			<Icon name="spy-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Tragedy"}
			<Icon name="skull-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Action/Adventure"}
			<Icon name="sword-line" width={iconSize} height={iconSize} />
		{:else if tag.name === "Dark"}
			<Icon name="contrast-2-fill" width={iconSize} height={iconSize} />
		{:else if tag.name === "Sad"}
			<Icon name="emotion-sad-line" width={iconSize} height={iconSize} />
		{/if}
		<span class="tag-label pr-0.5">{tag.name}</span>
	{:else if kind === TagKind.fandom && tag !== null}
		<span class="tag-label">
			{#if tag.parent !== null && tag.parent !== undefined && tag.parent.name !== undefined}
				{tag.parent.name}&mdash;{tag.name}
			{:else}
				{tag.name}
			{/if}
		</span>
	{/if}
</button>

<style lang="scss">
	button.tag-pill {
		@apply h-[40px] py-5 px-2 flex items-center rounded-xl mx-0.5 mt-1 text-white transition transform cursor-pointer;
		:global(svg) {
			@apply relative mr-0.5;
		}

		span.tag-label {
			@apply text-sm;
			a {
				@apply font-light text-white;
			}
		}

		span.rating-label-small {
			@apply hidden text-sm font-medium;
		}

		&.small-text {
			@apply px-1.5;
			:global(svg) {
				@apply mr-0;
			}

			span.tag-label {
				@apply text-xs;
			}

			&.no-icon {
				@apply px-2 py-0.5;
				span.rating-label-small {
					@apply block;
				}
			}
		}

		&.big-text {
			:global(svg) {
				@apply w-6 mr-0.5;
			}

			span.tag-label {
				@apply text-sm mr-1;
			}
		}

		&:active {
			@apply scale-95;
		}

		&.fandom {
			@apply bg-gray-500 hover:bg-gray-600;
		}

		&.warning {
		}

		&.genre {
			@apply bg-green-600 hover:bg-green-800;
		}

		&.user {
		}

		&.no-icon {
			@apply pl-3 pr-2;
		}
	}
</style>
