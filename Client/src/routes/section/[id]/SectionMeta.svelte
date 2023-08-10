<script lang="ts">
	import type { SectionView } from "$lib/models/content/works";
	import { slugify, copyToClipboard } from "$lib/util/functions";
	import { ThumbUpLine, ThumbUpFill, ThumbDownLine, ThumbDownFill, Bookmark3Line, Bookmark3Fill, Loader5Line, ShareBoxLine, ArrowRightSLine } from "svelte-remixicon";
	import { Avatar } from "$lib/ui/util";
	import { LinkTag } from "$lib/ui/content";
	import SvelteMarkdown from "svelte-markdown";
	import type { ReadingHistory } from '$lib/models/content/library';
	import { Vote } from '$lib/models/content/library';
	import toast from 'svelte-french-toast';
	import { account } from '$lib/state/account.state';
	import { delReq, patchReq, putReq, type ResponseError } from '$lib/http';
	import type { SectionComment } from '$lib/models/comments';
	import { NewComment } from '$lib/ui/comments';

	export let sectionView: SectionView;
	export let readingHistory: ReadingHistory | undefined;
	export let topComments: SectionComment[];
	export let libraryItem: { hasItem: boolean; } | undefined;

	let voting = false;
	let addingToLibrary = false;

	async function setVote(vote: Vote) {
		if (!$account.currProfile) {
			toast.error("You must be logged in and have a profile selected to use this feature.");
			return;
		}
		voting = true;
		if (sectionView.section.publishedOn === undefined) {
			toast.error(`This feature is disabled for unpublished sections.`);
			voting = false;
			return;
		}
		if ($account.account && $account.currProfile) {
			if ($account.currProfile.id === sectionView.author.id) {
				toast.error(`You cannot vote on your own work!`);
				voting = false;
				return;
			}
			const response = await patchReq<{
				history: ReadingHistory;
				likes: number;
				dislikes: number;
			}>(`/history/set-vote?workId=${sectionView.work.id}&profileId=${$account.currProfile.id}`, {
				vote: readingHistory?.vote === vote ? Vote.noVote : vote
			});
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				const result = response as {
					history: ReadingHistory;
					likes: number;
					dislikes: number;
				};
				readingHistory = result.history;
				sectionView.work.likes = result.likes;
				sectionView.work.dislikes = result.dislikes;
			}
		} else {
			toast.error(`You must be logged in to perform this action.`);
		}
		voting = false;
	}

	async function setLibrary() {
		if (!$account.currProfile) {
			toast.error("You must be logged in and have a profile selected to use this feature.");
			return;
		}
		addingToLibrary = true;
		if (sectionView.section.publishedOn === undefined) {
			toast.error(`This feature is disabled for unpublished works.`);
			addingToLibrary = false;
			return;
		}
		if ($account.account && $account.currProfile) {
			if ($account.currProfile.id === sectionView.author.id) {
				toast.error(`You cannot add your own work to your library!`);
				addingToLibrary = false;
				return;
			}

			let response: { hasItem: boolean } | ResponseError;
			if (libraryItem?.hasItem) {
				response = await delReq<{ hasItem: boolean }>(
					`/library/remove-one?workId=${sectionView.work.id}&profileId=${$account.currProfile.id}`
				);
			} else {
				response = await putReq<{ hasItem: boolean }>(
					`/library/add-one?workId=${sectionView.work.id}&profileId=${$account.currProfile.id}`,
					{}
				);
			}

			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				libraryItem = response as { hasItem: boolean };
			}
		} else {
			toast.error(`You must be logged in to perform this action.`);
		}
		addingToLibrary = false;
	}
</script>

<div class="section-meta">
	<div
		class="flex flex-col max-w-3xl mx-auto w-11/12 border-b-4 border-dotted border-zinc-700 p-4 pb-8"
	>
		<div class="flex flex-col lg:flex-row items-center">
			{#if sectionView.work.coverArt}
				<div class="bg-zinc-700 p-1 rounded-xl lg:mr-4">
					<img
						src={sectionView.work.coverArt}
						alt="cover art"
						class="max-w-[150px] max-h-[110px] rounded-lg"
					/>
				</div>
			{/if}
			<div class="w-full" style="font-family: var(--header-text);">
				<h3 class="text-4xl text-center lg:text-left">{sectionView.work.title}</h3>
				<div class="flex flex-col lg:flex-row items-center w-full">
				<span class="text-lg text-zinc-500 flex-1">
					by
					<a
						class="text-zinc-500 hover:text-zinc-500"
						href="/profile/{sectionView.author.id}/{slugify(sectionView.author.name)}"
					>
						{sectionView.author.name}
					</a>
				</span>
					<div
						class="py-2 w-full font-normal lg:hidden"
						style="font-family: var(--body-text); text-align: center;"
					>
						{sectionView.work.desc}
					</div>
				</div>
				<div
					class="py-2 w-full font-normal hidden lg:block"
					style="font-family: var(--body-text); color: var(--text-color);"
				>
					{sectionView.work.desc}
				</div>
			</div>
		</div>
		<div class="flex items-center justify-center lg:justify-end pt-4 flex-wrap">
			{#if readingHistory?.vote === Vote.noVote}
				<button class="meta-button thumbs-up" on:click={() => setVote(Vote.liked)}>
					{#if voting}
						<Loader5Line class="mr-2 animate-[spin_2s_linear_infinite]" />
						<span>-</span>
					{:else}
						<ThumbUpLine class="mr-2" />
						<span class="text-xs">{sectionView.work.likes}</span>
					{/if}
				</button>
				<div class="mx-0.5"><!--spacer--></div>
				<button class="meta-button thumbs-down" on:click={() => setVote(Vote.disliked)}>
					{#if voting}
						<Loader5Line class="mr-2 animate-[spin_2s_linear_infinite]" />
						<span>-</span>
					{:else}
						<ThumbDownLine class="mr-2" />
						<span class="text-xs">{sectionView.work.dislikes}</span>
					{/if}
				</button>
			{:else if readingHistory?.vote === Vote.liked}
				<button class="meta-button thumbs-up selected" on:click={() => setVote(Vote.noVote)}>
					{#if voting}
						<Loader5Line class="mr-2 animate-[spin_2s_linear_infinite]" />
						<span>-</span>
					{:else}
						<ThumbUpFill class="mr-2" />
						<span class="text-xs">{sectionView.work.likes}</span>
					{/if}
				</button>
				<div class="mx-0.5"><!--spacer--></div>
				<button class="meta-button thumbs-down" on:click={() => setVote(Vote.disliked)}>
					{#if voting}
						<Loader5Line class="mr-2 animate-[spin_2s_linear_infinite]" />
						<span>-</span>
					{:else}
						<ThumbDownLine class="mr-2" />
						<span class="text-xs">{sectionView.work.dislikes}</span>
					{/if}
				</button>
			{:else if readingHistory?.vote === Vote.disliked}
				<button class="meta-button thumbs-up" on:click={() => setVote(Vote.liked)}>
					{#if voting}
						<Loader5Line class="mr-2 animate-[spin_2s_linear_infinite]" />
						<span>-</span>
					{:else}
						<ThumbUpLine class="mr-2" />
						<span class="text-xs">{sectionView.work.likes}</span>
					{/if}
				</button>
				<div class="mx-0.5"><!--spacer--></div>
				<button class="meta-button thumbs-down selected" on:click={() => setVote(Vote.noVote)}>
					{#if voting}
						<Loader5Line class="mr-2 animate-[spin_2s_linear_infinite]" />
						<span>-</span>
					{:else}
						<ThumbDownFill class="mr-2" />
						<span class="text-xs">{sectionView.work.dislikes}</span>
					{/if}
				</button>
			{:else}
				<button class="meta-button thumbs-up" on:click={() => setVote(Vote.noVote)}>
					<ThumbUpLine class="mr-2" />
					<span class="text-xs">{sectionView.work.likes}</span>
				</button>
				<div class="mx-0.5"><!--spacer--></div>
				<button class="meta-button thumbs-down" on:click={() => setVote(Vote.noVote)}>
					<ThumbDownLine class="mr-2" />
					<span class="text-xs">{sectionView.work.dislikes}</span>
				</button>
			{/if}
			<div class="flex items-center ml-2.5 pl-2.5 border-l-2 border-zinc-700">
				<button class="meta-button with-text" on:click={setLibrary}>
					{#if addingToLibrary}
						<Loader5Line class="mr-2 animate-[spin_2s_linear_infinite]" />
						<span class="relative -top-0.5">Adding</span>
					{:else}
						{#if libraryItem?.hasItem}
							<Bookmark3Fill class="mr-2" />
							<span class="relative -top-0.5">Added</span>
						{:else}
							<Bookmark3Line class="mr-2" />
							<span class="relative -top-0.5">Library</span>
						{/if}
					{/if}
				</button>
				<div class="mx-0.5"><!--spacer--></div>
				<button class="meta-button with-text" on:click={() => copyToClipboard(`https://offprint.net/section/${sectionView.id}`)}>
					<ShareBoxLine class="mr-2" />
					<span class="relative -top-0.5">Share</span>
				</button>
			</div>
		</div>
	</div>
	<div class="flex flex-col max-w-3xl mx-auto w-11/12 border-b-4 border-dotted border-zinc-700 py-4 lg:p-8">
		<div class="flex items-center mb-4 pb-4 px-2 border-b border-zinc-700">
			<h3 class="text-xl flex-1">Top Comments</h3>
			<ArrowRightSLine size="24px" />
		</div>
		{#each topComments as comment}
			<NewComment {comment} collapsed={true} topComment={true} />
		{/each}
	</div>
	<div
		class="flex flex-col items-center justify-center max-w-[400px] mx-auto w-11/12 px-4 py-2 mt-4 rounded-xl font-normal"
		style="font-family: var(--body-text);"
	>
		<Avatar src={sectionView.author.avatar} size="125px" />
		<h4 class="mt-3 text-2xl">{sectionView.author.name}</h4>
		<div class="markdown-text">
			<SvelteMarkdown source={sectionView.author.info.bio} />
		</div>
		{#if Object.keys(sectionView.author.links).length !== 0}
			<div class="flex items-center flex-wrap">
				{#each Object.keys(sectionView.author.links) as key}
					<LinkTag kind={key} href={sectionView.author.links[key]} />
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
