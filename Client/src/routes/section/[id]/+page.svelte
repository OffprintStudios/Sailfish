<script lang="ts">
	import type { SectionPage, Cheer } from '$lib/models/content/works';
	import { delReq, patchReq, postReq, putReq, type ResponseError } from '$lib/http';
	import type { ReadingHistory } from '$lib/models/content/library';
	import { account } from '$lib/state/account.state';
	import toast from 'svelte-french-toast';
	import {
		ArrowDownSLine,
		ArrowUpSLine,
		ArrowLeftSLine,
		Loader5Line,
		OpenArmFill,
		OpenArmLine,
		DiscussLine,
		ArrowRightSLine,
		Bookmark3Fill,
		Bookmark3Line,
		ShareBoxLine,
		LightbulbFlashLine,
	} from 'svelte-remixicon';
	import { slide } from 'svelte/transition';
	import { abbreviate, copyToClipboard, slugify } from '$lib/util/functions';
	import { goto } from '$app/navigation';
	import { NewComment } from '$lib/ui/comments';
	import { Avatar } from '$lib/ui/util';
	import SvelteMarkdown from 'svelte-markdown';
	import { LinkTag } from '$lib/ui/content';

	export let data: SectionPage;
	const iconSize = "22px";
	let noteTopOpen = false;
	let addingToLibrary = false;

	async function markAsRead() {
		const response = await patchReq<ReadingHistory>(
			`/history/set-as-read?workId=${data.section.work.id}&sectionId=${data.section.id}&profileId=${$account.currProfile?.id}`,
			{}
		);
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			data.readingHistory = response as ReadingHistory;
		}
	}

	const published = data.tableOfContents.filter((section) => section.publishedOn !== undefined);
	let cheering = false;

	function goBack() {
		let sections = published;
		if ($account.currProfile?.id === data.section.author.id) {
			sections = data.tableOfContents;
		}
		const idx = sections.findIndex((item) => item.id === data.section.id);
		if (idx >= 1) {
			goto(`/section/${sections[idx - 1].id}`);
		} else {
			goto(`/section/${data.section.id}`);
		}
	}

	function goForward() {
		let sections = published;
		if ($account.currProfile?.id === data.section.author.id) {
			sections = data.tableOfContents;
		}
		const idx = sections.findIndex((item) => item.id === data.section.id);
		if (idx < sections.length - 1) {
			goto(`/section/${sections[idx + 1].id}`);
		} else {
			goto(`/section/${data.section.id}`);
		}
	}

	async function toggleCheer() {
		if (!$account.currProfile) {
			toast.error("You need to be logged in and have a profile selected to use this feature.");
			return;
		}
		cheering = true;
		const response = await postReq<{ cheer?: Cheer }>(`/reading/toggle-cheer/${data.section.id}?profileId=${$account.currProfile?.id}`, {});
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			const result = response as { cheer?: Cheer };
			data.cheer = result.cheer;
			if (result.cheer?.id) {
				data.section.section.cheers = data.section.section.cheers + 1;
			} else {
				data.section.section.cheers = data.section.section.cheers - 1;
			}
		}
		cheering = false;
	}

	async function setLibrary() {
		if (!$account.currProfile) {
			toast.error("You must be logged in and have a profile selected to use this feature.");
			return;
		}
		addingToLibrary = true;
		if (data.section.section.publishedOn === undefined) {
			toast.error(`This feature is disabled for unpublished works.`);
			addingToLibrary = false;
			return;
		}
		if ($account.account && $account.currProfile) {
			if ($account.currProfile.id === data.section.author.id) {
				toast.error(`You cannot add your own work to your library!`);
				addingToLibrary = false;
				return;
			}

			let response: { hasItem: boolean } | ResponseError;
			if (data.libraryItem?.hasItem) {
				response = await delReq<{ hasItem: boolean }>(
					`/library/remove-one?workId=${data.section.work.id}&profileId=${$account.currProfile.id}`
				);
			} else {
				response = await putReq<{ hasItem: boolean }>(
					`/library/add-one?workId=${data.section.work.id}&profileId=${$account.currProfile.id}`,
					{}
				);
			}

			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				data.libraryItem = response as { hasItem: boolean };
			}
		} else {
			toast.error(`You must be logged in to perform this action.`);
		}
		addingToLibrary = false;
	}
</script>

<div id="section-container" class="section-container">
	<div class="mb-16">
		<h1 class="text-4xl text-center">{data.section.section.title}</h1>
		{#if data.section.section.noteTop}
			<div class="flex flex-col items-center italic w-11/12 max-w-lg mx-auto">
				{#if noteTopOpen}
					<div class="flex flex-col pt-4 w-full" transition:slide={{ delay: 0, duration: 150 }}>
						<div class="authors-note italic text-justify">
							{@html data.section.section.noteTop}
						</div>
						<span class="w-full my-4 text-right">—A word from the author</span>
					</div>
				{/if}
				<button class="section-button" on:click={() => noteTopOpen = !noteTopOpen}>
					{#if noteTopOpen}
						<ArrowUpSLine size="24px" />
					{:else}
						<ArrowDownSLine size="24px" />
					{/if}
				</button>
			</div>
		{/if}
	</div>
	<div id="section-body" class="section-body">
		{@html data.section.section.body}
	</div>
	{#if data.section.section.noteBottom}
		<div class="section-authors-note">
			<div class="flex items-center">
				<h3 class="text-2xl">From the author—</h3>
			</div>
			<div class="authors-note">
				{@html data.section.section.noteBottom}
			</div>
		</div>
	{/if}
</div>
<div id="section-nav" class="section-nav">
	<button class="section-button" on:click={goBack}>
		<ArrowLeftSLine class="lg:mr-1" size={iconSize} />
		<span class="hidden lg:block">Prev</span>
	</button>
	<div class="mx-2"><!--spacer--></div>
	<button class="section-button" class:active={!!data.cheer} title="Cheers" on:click={toggleCheer}>
		{#if cheering}
			<Loader5Line size={iconSize} class="mr-1 animate-[spin_2s_linear_infinite]" />
			<span style="top: 0.03rem;">-</span>
		{:else}
			{#if data.cheer}
				<OpenArmFill size={iconSize} class="mr-1" />
			{:else}
				<OpenArmLine size={iconSize} class="mr-1" />
			{/if}
			<span class="text-xs" style="top: 0.03rem;">
				{abbreviate(data.section.section.cheers)}
			</span>
		{/if}
	</button>
	<div class="mx-0.5"><!--spacer--></div>
	<button class="section-button" title="Comments">
		<DiscussLine size={iconSize} class="mr-1" />
		<span class="text-xs" style="top: 0.03rem;">
			{abbreviate(data.section.section.comments)}
		</span>
	</button>
	<div class="mx-2"><!--spacer--></div>
	<button class="section-button" on:click={goForward}>
		<span class="hidden lg:block">Next</span>
		<ArrowRightSLine class="lg:ml-1" size={iconSize} />
	</button>
</div>
<div id="section-meta" class="section-meta">
	<div
		class="flex flex-col max-w-3xl mx-auto w-11/12 border-b-4 border-dotted border-zinc-700 p-4 pb-8"
	>
		<div class="flex flex-col lg:flex-row items-center">
			{#if data.section.work.coverArt}
				<div class="bg-zinc-700 p-1 rounded-xl lg:mr-4">
					<img
						src={data.section.work.coverArt}
						alt="cover art"
						class="max-w-[150px] max-h-[110px] rounded-lg"
					/>
				</div>
			{/if}
			<div class="w-full" style="font-family: var(--header-text);">
				<h3 class="text-4xl text-center lg:text-left">{data.section.work.title}</h3>
				<div class="flex flex-col lg:flex-row items-center w-full">
				<span class="text-lg text-zinc-500 flex-1">
					by
					<a
						class="text-zinc-500 hover:text-zinc-500"
						href="/profile/{data.section.author.id}/{slugify(data.section.author.name)}"
					>
						{data.section.author.name}
					</a>
				</span>
					<div
						class="py-2 w-full font-normal lg:hidden"
						style="font-family: var(--body-text); text-align: center;"
					>
						{data.section.work.desc}
					</div>
				</div>
				<div
					class="py-2 w-full font-normal hidden lg:block"
					style="font-family: var(--body-text); color: var(--text-color);"
				>
					{data.section.work.desc}
				</div>
			</div>
		</div>
		<div class="flex items-center justify-center lg:justify-end pt-4 flex-wrap">
			<div class="flex items-center">
				<button class="meta-button with-text" on:click={setLibrary}>
					{#if addingToLibrary}
						<Loader5Line class="mr-2 animate-[spin_2s_linear_infinite]" />
						<span class="relative -top-0.5">Adding</span>
					{:else}
						{#if data.libraryItem?.hasItem}
							<Bookmark3Fill class="mr-2" />
							<span class="relative -top-0.5">Added</span>
						{:else}
							<Bookmark3Line class="mr-2" />
							<span class="relative -top-0.5">Library</span>
						{/if}
					{/if}
				</button>
				<div class="mx-0.5"><!--spacer--></div>
				<button class="meta-button with-text" on:click={() => copyToClipboard(`https://offprint.net/section/${data.section.id}`)}>
					<ShareBoxLine class="mr-2" />
					<span class="relative -top-0.5">Share</span>
				</button>
			</div>
		</div>
	</div>
	<div
		class="flex flex-col max-w-3xl mx-auto w-11/12 border-b-4 border-dotted border-zinc-700 py-4 lg:p-8 cursor-pointer"
		on:click={() => goto(`/section/${data.section.id}/comments`)}
	>
		<div class="flex items-center mb-4 pb-4 px-2 border-b border-zinc-700">
			<h3 class="text-xl flex-1">Top Comments</h3>
			<ArrowRightSLine size="24px" />
		</div>
		{#if data.topComments.length === 0}
			<div class="flex flex-col items-center justify-center h-[200px] w-full">
				<LightbulbFlashLine size="62px" />
				<span class="all-small-caps font-bold tracking-wide text-base">Share Your Thoughts</span>
			</div>
		{:else}
			{#each data.topComments as comment}
				<NewComment {comment} collapsed={true} topComment={true} />
			{/each}
		{/if}
	</div>
	<div
		class="flex flex-col items-center justify-center max-w-[400px] mx-auto w-11/12 px-4 py-2 mt-4 rounded-xl font-normal"
		style="font-family: var(--body-text);"
	>
		<Avatar src={data.section.author.avatar} size="125px" />
		<h4 class="mt-3 text-2xl">{data.section.author.name}</h4>
		<div class="markdown-text">
			<SvelteMarkdown source={data.section.author.info.bio} />
		</div>
		{#if Object.keys(data.section.author.links).length !== 0}
			<div class="flex items-center flex-wrap">
				{#each Object.keys(data.section.author.links) as key}
					<LinkTag kind={key} href={data.section.author.links[key]} />
				{/each}
			</div>
		{/if}
	</div>
</div>

<style lang="scss">
  :global(div.markdown-text) {
    :global(p) {
      color: var(--text-color);
      margin: 0.5rem 0 0.5rem 0 !important;
      text-align: center !important;
    }
  }
</style>
