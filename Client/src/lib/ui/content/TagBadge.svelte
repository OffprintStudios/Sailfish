<script lang="ts">
	import { Category, Kind, Status } from "$lib/models/content/works";
	import type { Tag } from "$lib/models/tags";
	import { TagKind } from "$lib/models/tags";
	import { ContentRating } from "$lib/models/content";
	import {
		EmpathizeLine,
		Loader2Line,
		EmotionLaughLine,
		FilePaper2Line,
		DoorClosedLine,
		MagicLine,
		Ghost2Line,
		SearchEyeLine,
		HeartsLine,
		AliensLine,
		Home3Line,
		MeteorLine,
		SpyLine,
		SkullLine,
		SwordLine,
		Contrast2Fill,
		EmotionSadLine
	} from "svelte-remixicon";

	export let size: "small" | "medium" | "large" = "medium";
	export let hasIcon = true;
	export let kind: TagKind;
	export let workKind: Kind;
	export let category: Category;
	export let rating: ContentRating;
	export let status: Status;
	export let tag: Tag;
</script>

<button
	class="tag-pill"
	type="button"
	class:fandom={kind === TagKind.fandom}
	class:warning={kind === TagKind.warning}
	class:category={kind === TagKind.category}
	class:genre={kind === TagKind.genre}
	class:user={kind === TagKind.user}
	class:work-kind={kind === TagKind.workKind}
	class:small-text={size === "small"}
	class:big-text={size === "large"}
	class:no-icon={!hasIcon}
	class:everyone={rating === ContentRating.Everyone}
	class:teen={rating === ContentRating.Teen}
	class:mature={rating === ContentRating.Mature}
	class:explicit={rating === ContentRating.Explicit}
	class:status={kind === TagKind.status}
	on:click
>
	{#if kind === TagKind.category}
		{#if category === Category.Fanwork}
			<EmpathizeLine />
			<span class="tag-label pr-0.5">Fanwork</span>
		{:else if category === Category.Original}
			<Loader2Line />
			<span class="tag-label pr-0.5">Original</span>
		{/if}
	{:else if kind === TagKind.genre}
		{#if tag.name === "Comedy"}
			<EmotionLaughLine />
		{:else if tag.name === "Drama"}
			<FilePaper2Line />
		{:else if tag.name === "Erotica"}
			<DoorClosedLine />
		{:else if tag.name === "Fantasy"}
			<MagicLine />
		{:else if tag.name === "Horror"}
			<Ghost2Line />
		{:else if tag.name === "Mystery"}
			<SearchEyeLine />
		{:else if tag.name === "Romance"}
			<HeartsLine />
		{:else if tag.name === "Science Fiction"}
			<AliensLine />
		{:else if tag.name === "Slice of Life"}
			<Home3Line />
		{:else if tag.name === "Speculative Fiction"}
			<MeteorLine />
		{:else if tag.name === "Thriller"}
			<SpyLine />
		{:else if tag.name === "Tragedy"}
			<SkullLine />
		{:else if tag.name === "Action/Adventure"}
			<SwordLine />
		{:else if tag.name === "Dark"}
			<Contrast2Fill />
		{:else if tag.name === "Sad"}
			<EmotionSadLine />
		{/if}
		<span class="tag-label pr-0.5">{tag.name}</span>
	{:else if kind === TagKind.rating}
		{#if rating === ContentRating.Everyone}
			<span class="tag-label">Everyone</span>
			<span class="rating-label-small">E</span>
		{:else if rating === ContentRating.Teen}
			<span class="tag-label">Teen</span>
			<span class="rating-label-small">T</span>
		{:else if rating === ContentRating.Mature}
			<span class="tag-label">Mature</span>
			<span class="rating-label-small">M</span>
		{:else if rating === ContentRating.Explicit}
			<span class="tag-label">Explicit</span>
			<span class="rating-label-small">X</span>
		{/if}
	{:else if kind === TagKind.fandom && tag !== null}
		<span class="tag-label">
			{#if tag.parent}
				{tag.parent.name}&mdash;{tag.name}
			{:else}
				{tag.name}
			{/if}
		</span>
	{:else if kind === TagKind.status}
		<span class="tag-label">{status}</span>
	{:else if kind === TagKind.workKind}
		<span class="tag-label">{workKind}</span>
	{/if}
</button>

<style lang="scss">
	button.tag-pill {
		@apply p-1 flex items-center rounded-lg mx-0.5 mt-1 text-white transition transform cursor-pointer h-[1.75rem];
		:global(svg) {
			@apply w-4 relative mr-0.5;
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

		&.category {
			@apply bg-purple-600 hover:bg-purple-800;
		}

		&.genre {
			@apply bg-green-600 hover:bg-green-800;
		}

		&.user {
		}

		&.work-kind {
			@apply bg-cyan-700 hover:bg-cyan-600;
		}

		&.everyone {
			@apply bg-green-700 hover:bg-green-900;
		}

		&.teen {
			@apply bg-yellow-500 hover:bg-yellow-600;
		}

		&.mature {
			@apply bg-yellow-700 hover:bg-yellow-900;
		}

		&.explicit {
			@apply bg-red-700 hover:bg-red-900;
		}

		&.status {
			@apply bg-emerald-600 hover:bg-emerald-700;
		}

		&.no-icon {
			@apply py-1;
		}
	}
</style>
