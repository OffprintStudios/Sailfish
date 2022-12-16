<script lang="ts">
	import {onMount} from "svelte";
	import {account} from "$lib/state/account.state";
	import {
		BookLine,
		Bookmark3Line,
		CloseCircleLine,
		DislikeLine,
		EyeLine,
		EyeOffLine,
		HeartLine,
		ImageAddLine,
		ImageEditLine,
		Loader5Line,
		TimeLine,
	} from "svelte-remixicon";
	import type {Work} from "$lib/models/content/works";
	import {ApprovalStatus} from "$lib/models/content/works";
	import {TagBadge} from "$lib/ui/content";
	import {abbreviate, slugify} from "$lib/util/functions";
	import {TagKind} from "$lib/models/tags";
	import {NavLink} from "$lib/ui/nav";
	import {openPopup} from "$lib/ui/popup";
	import {UploadCoverArt, UploadWorkBanner} from "$lib/ui/upload";
	import toast from "svelte-french-toast";
	import {Button} from "$lib/ui/util";
	import type {ReadingHistory} from "$lib/models/content/library";
	import {Vote} from "$lib/models/content/library";
	import type {ResponseError} from "$lib/http";
	import {delReq, getReq, patchReq, putReq} from "$lib/http";
	import PublishWorkPrompt from "./PublishWorkPrompt.svelte";

	export let work: Work;
	export let history: ReadingHistory;
	let library: { hasItem: boolean } = { hasItem: false };
	let isVoting = false;
	let isAddingToLibrary = false;

	onMount(async () => {
		if ($account.account && $account.currProfile && $account.currProfile.id !== work.author.id) {
			await checkLibrary();
		}
	});

	async function checkLibrary() {
		if (work.publishedOn === undefined || work.publishedOn <= new Date()) {
			toast.error(`This feature is disabled for unpublished works.`);
			return;
		}
		const response = await getReq<{ hasItem: boolean }>(`/history/fetch-one?workId=${work.id}&profileId=${$account.currProfile?.id}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			library = response as { hasItem: boolean };
		}
	}

	async function setVote(vote: Vote) {
		isVoting = true;
		if (work.publishedOn === undefined || work.publishedOn <= new Date()) {
			toast.error(`This feature is disabled for unpublished works.`);
			isVoting = false;
			return;
		}
		if ($account.account && $account.currProfile) {
			if ($account.currProfile.id === work.author.id) {
				toast.error(`You cannot vote on your own work!`);
				isVoting = false;
				return;
			}
			const response = await patchReq<ReadingHistory>(`/history/set-vote?workId=${work.id}&profileId=${$account.currProfile.id}`, {
				vote: history.vote === vote ? Vote.noVote : vote,
			});
			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				history = response as ReadingHistory;
			}
		} else {
			toast.error(`You must be logged in to perform this action.`);
		}
		isVoting = false;
	}

	async function setLibrary() {
		isAddingToLibrary = true;
		if (work.publishedOn === undefined || work.publishedOn <= new Date()) {
			toast.error(`This feature is disabled for unpublished works.`);
			isAddingToLibrary = false;
			return;
		}
		if ($account.account && $account.currProfile) {
			if ($account.currProfile.id === work.author.id) {
				toast.error(`You cannot add your own work to your library!`);
				isAddingToLibrary = false;
				return;
			}

			let response: { hasItem: boolean } | ResponseError;
			if (library.hasItem) {
				response = await delReq<{ hasItem: boolean}>(`/library/remove-one?workId=${work.id}&profileId=${$account.currProfile.id}`);
			} else {
				response = await putReq<{ hasItem: boolean }>(`/library/add-one?workId=${work.id}&profileId=${$account.currProfile.id}`, {});
			}

			if ((response as ResponseError).error) {
				const error = response as ResponseError;
				toast.error(error.message);
			} else {
				library = response as { hasItem: boolean };
			}
		} else {
			toast.error(`You must be logged in to perform this action.`);
		}
		isAddingToLibrary = false;
	}

	function updateCoverArt() {
		openPopup(UploadCoverArt, {
			onConfirm(value: Work) {
				work = value;
			}
		}, { workId: work.id });
	}

	function updateBannerArt() {
		openPopup(UploadWorkBanner, {
			onConfirm(value: Work) {
				work = value;
			}
		}, { workId: work.id })
	}

	function publishWork() {
		openPopup(PublishWorkPrompt, {
			onConfirm: async () => {
				const response = await toast.promise(
						patchReq<void>(`/works/publish-work/${work.id}?profileId=${$account.currProfile?.id}`, {}),
						{
							loading: 'Submitting to queue...',
							success: 'Your work has been submitted!',
							error: null,
						}
					);
				if ((response as ResponseError).error) {
					const error = response as ResponseError;
					toast.error(error.message);
				} else {
					work.approvalStatus = ApprovalStatus.Pending;
				}
			}
		})
	}

	async function hideShow() {
		if (work.approvalStatus !== ApprovalStatus.Approved) {
			toast.error(`Your work must first be approved before you can access this function.`);
			return;
		}
		const response = await toast.promise<void>(
				patchReq<void>(`/works/hide-show/${work.id}?profileId=${$account.currProfile?.id}`, {}),
				{
					loading: 'Changing visibility...',
					success: 'Changes saved!',
					error: null,
				}
			);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			work.publishedOn = undefined;
		}
	}
</script>

<div class="header-container bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	{#if work.coverArt}
		<div class="cover-art">
			<div
				class="relative overflow-hidden w-max flex flex-col items-center justify-center bg-zinc-200 dark:bg-zinc-700 border-4 border-zinc-300 dark:border-zinc-600 rounded-xl z-[2]"
				style="box-shadow: var(--dropshadow);"
			>
				<img src={work.coverArt} alt="cover art" class="max-w-[250px] max-h-[210px]" />
				{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
					<div class="absolute top-2 right-2">
						<Button kind="primary" title="Edit Cover Art" on:click={updateCoverArt}>
							<ImageEditLine class="button-icon no-text" />
						</Button>
					</div>
				{/if}
			</div>
		</div>
	{:else}
		{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
			<div class="cover-art w-[150px]">
				<div class="flex flex-col items-center justify-center w-[150px] h-[215px] bg-zinc-200 dark:bg-zinc-700 border-4 border-zinc-300 dark:border-zinc-600 rounded-xl" style="box-shadow: var(--dropshadow);">
					<NavLink type="button" on:click={updateCoverArt}>
						<ImageAddLine class="link-icon" />
						<span class="link-name">Add Cover</span>
					</NavLink>
				</div>
			</div>
		{:else}
			<div class="cover-art"><!--this is meant to be empty--></div>
		{/if}
	{/if}
	<div class="banner" class:h-[150px]={!work.bannerArt} class:h-[250px]={work.bannerArt}>
		{#if work.bannerArt}
			<img src={work.bannerArt} alt="cover art" class="w-full h-full object-cover" />
		{/if}
		<div class="absolute top-2 right-2 z-[2]">
			<div class="flex items-center">
				<TagBadge kind={TagKind.category} category={work.category} />
				<div class="mx-[0.075rem]"></div>
				<TagBadge kind={TagKind.status} status={work.status} />
				<div class="mx-[0.075rem]"></div>
				<TagBadge kind={TagKind.rating} rating={work.rating} />
			</div>
		</div>
	</div>
	<div class="title-bar">
		<div class="flex-1">
			<h1 class="text-3xl" style="color: var(--text-color);">
				{work.title}
			</h1>
			<div class="flex items-center flex-wrap">
			<span class="relative top-0.5 text-xl font-medium text-zinc-400" style="font-family: var(--header-text);">
				by <a class="text-zinc-400" href="/profile/{work.author.id}/{slugify(work.author.username)}">{work.author.username}</a>
			</span>
				<span class="mx-1 text-zinc-400">•</span>
				{#each work.tags as tag}
					<TagBadge tag={tag} kind={tag.kind} />
					<div class="mx-[0.075rem]"></div>
				{/each}
			</div>
		</div>
		<div class="flex items-center">
			{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
				{#if work.approvalStatus === ApprovalStatus.NotSubmitted}
					<NavLink type="button" on:click={publishWork}>
						<BookLine class="link-icon" />
						<span class="link-name">Publish</span>
					</NavLink>
				{:else if work.approvalStatus === ApprovalStatus.Pending}
					<NavLink type="button">
						<TimeLine class="link-icon" />
						<span class="link-name">Pending</span>
					</NavLink>
				{:else if work.approvalStatus === ApprovalStatus.Rejected}
					<NavLink type="button" on:click={publishWork}>
						<CloseCircleLine class="link-icon" />
						<span class="link-name">Rejected</span>
					</NavLink>
				{:else if work.approvalStatus === ApprovalStatus.Approved}
					{#if work.publishedOn}
						<NavLink type="button" on:click={hideShow}>
							<EyeOffLine class="link-icon" />
							<span class="link-name">Hide</span>
						</NavLink>
					{:else}
						<NavLink type="button" on:click={hideShow}>
							<EyeLine class="link-icon" />
							<span class="link-name">Show</span>
						</NavLink>
					{/if}
				{/if}
				<NavLink type="button" on:click={updateBannerArt}>
					{#if work.bannerArt}
						<ImageEditLine class="link-icon" />
					{:else}
						<ImageAddLine class="link-icon" />
					{/if}
					<span class="link-name">Banner</span>
				</NavLink>
			{:else}
				<button
					title="{work.likes} likes"
					disabled={isVoting}
					type="button"
					class="utility"
					class:active={history?.vote === Vote.liked}
					on:click={() => setVote(Vote.liked)}
				>
					{#if isVoting}
						<Loader5Line class="animate-spin mr-1" size="24px" />
					{:else}
						<HeartLine class="mr-1" size="24px" />
					{/if}
					<span class="text-xl relative top-0.5" style="font-family: var(--header-text);">{abbreviate(work.likes)}</span>
				</button>
				<div class="mx-0.5"></div>
				<button
					title="{work.dislikes} dislikes"
					disabled={isVoting}
					type="button"
					class="utility"
					class:active={history?.vote === Vote.disliked}
					on:click={() => setVote(Vote.disliked)}
				>
					{#if isVoting}
						<Loader5Line class="animate-spin mr-1" size="24px" />
					{:else}
						<DislikeLine class="mr-1" size="24px" />
					{/if}
					<span class="text-xl relative top-0.5" style="font-family: var(--header-text);">{abbreviate(work.dislikes)}</span>
				</button>
				<div class="mx-0.5"></div>
				<button
					title="Add to Library"
					type="button"
					class="utility"
					class:active={library?.hasItem}
					on:click={setLibrary}
				>
					<Bookmark3Line size="24px" />
				</button>
			{/if}
		</div>
	</div>
</div>

<style lang="scss">
	div.header-container {
		@apply grid rounded-xl relative mb-6 overflow-hidden;
		grid-template-areas:
    		"a b"
    		"c d";
		grid-template-rows: 1fr auto;
		grid-template-columns: auto 1fr;

		div.cover-art {
			grid-area: a / c / c / c;
			display: flex;
			align-items: flex-end;
			@apply p-4 relative;
		}
		div.banner {
			background: var(--accent);
			grid-area: a / a / b / b;
		}
		div.title-bar {
			grid-area: d;
			@apply p-4 pl-0 flex items-center z-[2] relative;
		}
		button.utility {
			@apply flex items-center p-2 rounded-xl transition;
			&.active {
				@apply text-white;
				background: var(--accent);
			}
		}
	}
</style>
