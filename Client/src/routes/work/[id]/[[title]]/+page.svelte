<script lang="ts">
	import type { FetchWorkPage } from "$lib/models/content/works";
	import { TagBadge } from "$lib/ui/content";
	import { Icon } from "svelte-remix";
	import { readingTime } from "$lib/util/functions";
	import { InfoBar } from "$lib/ui/util";
	import Time from "$lib/ui/util/Time.svelte";
	import WorkCard from "$lib/ui/content/WorkCard.svelte";

	export let data: FetchWorkPage;

	/*async function fetchQueueItem() {
		const response = await getReq<ApprovalQueue>(
			`/approval-queue/fetch-one?workId=${data.work.id}&profileId=${$account.currProfile?.id}`
		);
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			console.log(error.message);
		} else {
			queueItem = response as ApprovalQueue;
		}
	}

	async function fetchHistory() {
		const response = await getReq<ReadingHistory>(
			`/history/fetch-one?workId=${data.work.id}&profileId=${$account.currProfile?.id}`
		);
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			history = response as ReadingHistory;
		}
	}*/
</script>

<div class="pb-8">
	<!--<InfoBar
			message="<b>This work is a draft.</b> No views will be counted when navigating to
                                this page, and all social features (such as comments and likes/dislikes) are disabled."
		/>-->
	<section class="mb-2">
		<h3>Description</h3>
		<div class="html-description">
			{@html data.work.longDesc}
		</div>
	</section>
	<section class="mb-6">
		<h3>Tags</h3>
		<div class="flex items-center flex-wrap">
			{#each data.work.tags as tag}
				<TagBadge {tag} size="large" kind={tag.kind}  />
			{/each}
		</div>
	</section>
	<section class="mb-6">
		<h3>Stats</h3>
		<ul class="list-none w-full bg-zinc-200 dark:bg-zinc-700 rounded-xl overflow-hidden">
			<li class="border-zinc-300 dark:border-zinc-600">
				<span class="mr-2"><Icon name="line-chart-line" /></span>
				<span>Views</span>
				<span class="flex-1"><!--spacer--></span>
				<span class="font-bold">{data.work.views}</span>
			</li>
			<li class="border-zinc-300 dark:border-zinc-600">
				<span class="mr-2"><Icon name="pen-nib-line" /></span>
				<span>Words</span>
				<span class="flex-1"><!--spacer--></span>
				<span class="font-bold">{data.work.words}</span>
			</li>
			<li class="border-zinc-300 dark:border-zinc-600">
				<span class="mr-2"><Icon name="time-line" /></span>
				<span>Est. Reading Time</span>
				<span class="flex-1"><!--spacer--></span>
				<span class="font-bold">{readingTime(data.work.words)}</span>
			</li>
		</ul>
	</section>
	<section class="mb-6">
		<h3>Artwork</h3>
		<div class="flex items-center overflow-y-scroll w-full min-h-[125px] max-h-[125px]">
			{#if data.work.coverArt}
				<img class="object-contain rounded-xl min-h-[125px] max-h-[125px] mr-2" src={data.work.coverArt} alt="Cover Art" />
			{/if}
			{#if data.work.bannerArt}
				<img class="object-contain rounded-xl min-h-[125px] max-h-[125px]" src={data.work.bannerArt} alt="Banner Art" />
			{/if}
			{#if !data.work.coverArt && !data.work.bannerArt}
				<div class="flex flex-col w-full h-full items-center justify-center">
					<span class="text-sm uppercase tracking-wide font-bold text-zinc-400 dark:text-zinc-500">No Artwork Available</span>
				</div>
			{/if}
		</div>
	</section>
	<section>
		<h3>Misc</h3>
		<div class="flex flex-col w-full">
			<div class="flex items-center py-4 px-2 border-b border-zinc-300 dark:border-zinc-600">
				<span class="text-zinc-400 dark:text-zinc-500 flex-1">Category</span>
				<span>{data.work.category}</span>
			</div>
			<div class="flex items-center py-4 px-2 border-b border-zinc-300 dark:border-zinc-600">
				<span class="text-zinc-400 dark:text-zinc-500 flex-1">Kind</span>
				<span>{data.work.kind}</span>
			</div>
			<div class="flex items-center py-4 px-2 border-b border-zinc-300 dark:border-zinc-600">
				<span class="text-zinc-400 dark:text-zinc-500 flex-1">Status</span>
				<span>{data.work.status}</span>
			</div>
			<div class="flex items-center py-4 px-2 border-b border-zinc-300 dark:border-zinc-600">
				<span class="text-zinc-400 dark:text-zinc-500 flex-1">Content Rating</span>
				<span>{data.work.rating}</span>
			</div>
			{#if data.work.publishedOn}
				<div class="flex items-center py-4 px-2">
					<span class="text-zinc-400 dark:text-zinc-500 flex-1">Published On</span>
					<span><Time timestamp={data.work.publishedOn} /></span>
				</div>
			{:else}
				<div class="flex items-center py-4 px-2">
					<span class="text-zinc-400 dark:text-zinc-500 flex-1">Created At</span>
					<span><Time timestamp={data.work.createdAt} /></span>
				</div>
			{/if}
		</div>
	</section>
</div>

<!--<div class="max-w-7xl mx-auto mb-6 xl:mt-6">
	<WorkHeader work={data.work} {history} />
	{#if !data.work.publishedOn && !queueItem}
	
		<div class="mb-6"></div>
	{:else if queueItem !== null && queueItem !== undefined}
		<ApprovalOptionsBar {queueItem} />
	{/if}
	<div class="max-w-4xl w-11/12 lg:w-full mx-auto">
		<WorkInfo work={data.work} />
		<ListContainer work={data.work} {history} />
	</div>
</div>-->

<style lang="scss">
	section {
		ul {
			@apply ml-0;
			li {
				@apply flex items-center px-4 py-3.5 border-b-2 last:border-0;
			}
		}
	}
</style>