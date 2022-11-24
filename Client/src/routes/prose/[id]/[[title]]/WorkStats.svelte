<script lang="ts">
	import { Calendar2Line, Bookmark3Line, BarChart2Line, ShareBoxLine, AlarmWarningLine } from "svelte-remixicon";
	import type { Work } from "$lib/models/content/works";
	import { Button } from "$lib/ui/util";
	import { abbreviate } from "$lib/util/functions";

	export let work: Work;
</script>

<div class="flex flex-col max-w-[108.16px] min-w-[108.16px] mr-6">
	<div class="date-block bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
		<Calendar2Line size="36px" class="mb-2" />
		{#if work.publishedOn}
			<span class="month-and-day">
				{new Date(work.publishedOn).toLocaleString('default', { month: 'short' })} {new Date(work.publishedOn).getDate()}
			</span>
			<span class="year">{new Date(work.publishedOn).getFullYear()}</span>
		{:else}
			<span class="month-and-day">
				{new Date(work.createdAt).toLocaleString('default', { month: 'short' })} {new Date(work.createdAt).getDate()}
			</span>
			<span class="year">{new Date(work.createdAt).getFullYear()}</span>
		{/if}
	</div>
	<div class="flex flex-col w-full md:max-w-[108.16px] md:min-w-[108.16px] p-2 rounded-xl mb-4 bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
		<Button classes="md:w-full md:justify-center">
			<BarChart2Line class="button-icon" />
			<span class="button-text">Shelves</span>
		</Button>
		<div class="my-0.5"><!--spacer--></div>
		<Button classes="md:w-full md:justify-center">
			<ShareBoxLine class="button-icon" />
			<span class="button-text">Share</span>
		</Button>
		<div class="my-0.5"><!--spacer--></div>
		<Button classes="md:w-full md:justify-center">
			<AlarmWarningLine class="button-icon" />
			<span class="button-text">Report</span>
		</Button>
	</div>
	<div class="flex flex-col rounded-xl bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed p-2">
		<div class="stat-block">
			<span class="stat-name">Words</span>
			<span class="stat-value">{abbreviate(work.words)}</span>
		</div>
		<div class="stat-block">
			<span class="stat-name">Views</span>
			<span class="stat-value">{abbreviate(work.views)}</span>
		</div>
		<div class="stat-block">
			<span class="stat-name">Comments</span>
			<span class="stat-value">{abbreviate(work.comments)}</span>
		</div>
	</div>
</div>

<style lang="scss">
	div.date-block {
		font-family: var(--header-text);
		@apply flex-col items-center justify-center pt-3.5 flex rounded-xl mb-4;
		span.month-and-day {
			@apply uppercase text-2xl font-medium relative kerning;
		}
		span.year {
			@apply text-lg font-light relative bottom-2;
		}
	}
	div.stat-block {
		@apply flex flex-col items-center justify-center border-b-2 border-zinc-300 py-4 last:pb-2 last:border-0;
		span.stat-name {
			@apply uppercase text-zinc-500 text-xs font-medium tracking-widest mb-1;
		}
		span.stat-value {
			@apply text-lg font-bold;
			font-family: var(--body-serif-text);
		}
	}
</style>
