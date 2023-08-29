<script lang="ts">
	import type { FetchWorkPage, SectionList } from "$lib/models/content/works";
	import { TagBadge } from "$lib/ui/content";
	import { Icon } from "svelte-remix";
	import { abbreviate, readingTime } from "$lib/util/functions";
	import { InfoBar } from "$lib/ui/util";
	import { Time } from "$lib/ui/util";
	import { afterNavigate } from "$app/navigation";
	import { account } from "$lib/state/account.state";

	export let data: FetchWorkPage;
	const publishedSections = data.tableOfContents.filter(section => section.publishedOn !== undefined);

	const tableCopy = $account.currProfile?.id === data.work.author.id ? [...data.tableOfContents] : publishedSections;
	tableCopy.reverse()
	let latestSections = tableCopy.slice(0, 3);

	afterNavigate(() => {
		const tableRecopy = [...data.tableOfContents];
		tableRecopy.reverse();
		latestSections = tableRecopy.slice(0, 3);
	});

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
	<section class="hidden lg:block mb-6">
		<h3>Latest Updates</h3>
		<ul class="list-none w-full bg-zinc-200 dark:bg-zinc-700 rounded-xl overflow-hidden">
			{#each latestSections as section}
				<li class="with-link border-zinc-300 dark:border-zinc-600 hover:bg-zinc-400 dark:hover:bg-zinc-500">
					<a href="/section/{section.id}">
						<div class="flex flex-col flex-1">
							<span class="line-clamp-1">{section.title}</span>
							<div class="flex items-center text-xs uppercase font-bold text-zinc-500 dark:text-zinc-400">
								<span><Icon name="calendar-2-line" width="16px" height="16px" class="mr-1" /></span>
								{#if section.publishedOn}
									<span class="relative top-[0.075rem]"><Time timestamp={section.publishedOn} /></span>
								{:else}
									<span class="relative top-[0.075rem]"><Time timestamp={section.createdAt} /></span>
								{/if}
								<span class="mx-1">•</span>
								<span class="hidden lg:block"><Icon name="open-arm-line" width="16px" height="16px" class="mr-1" /></span>
								<span class="hidden lg:block relative top-[0.075rem]">{abbreviate(section.cheers)}</span>
								<span class="hidden lg:block mx-1">•</span>
								<span class="hidden lg:block"><Icon name="question-answer-line" width="16px" height="16px" class="mr-1" /></span>
								<span class="hidden lg:block relative top-[0.075rem]">{abbreviate(section.comments)}</span>
								<span class="hidden lg:block mx-1">•</span>
								<span><Icon name="time-line" width="16px" height="16px" class="mr-1" /></span>
								<span class="relative top-[0.075rem]">{readingTime(section.words)}</span>
							</div>
						</div>
						<Icon name="arrow-right-s-line" width="20px" height="20px" class="ml-4 text-zinc-500 dark:text-zinc-400" />
					</a>
				</li>
			{/each}
		</ul>
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

<style lang="scss">
	section {
		ul {
			@apply ml-0;
			li {
				@apply flex items-center my-0 px-4 py-3.5 border-b-2 last:border-0;
			}
			li.with-link {
				@apply my-0 px-0 py-0 border-b-2 last:border-0 transition;
				a {
					@apply w-full h-full flex items-center px-4 py-3.5 no-underline;
					color: var(--text-color);
				}
			}
		}
	}
</style>