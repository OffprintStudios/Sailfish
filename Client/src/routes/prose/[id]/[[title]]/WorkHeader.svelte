<script lang="ts">
	import { account } from "$lib/state/account.state";
	import {
		HeartLine,
		DislikeLine,
		ImageAddLine,
		ImageEditLine,
		Bookmark3Line,
		BookLine,
		TimeLine,
		CloseCircleLine,
		EyeOffLine,
		EyeLine,
	} from "svelte-remixicon";
	import type { Work } from "$lib/models/content/works";
	import { TagBadge } from "$lib/ui/content";
	import { abbreviate, slugify } from "$lib/util/functions";
	import { TagKind } from "$lib/models/tags";
	import { NavLink } from "$lib/ui/nav";
	import { openPopup } from "$lib/ui/popup";
	import { UploadCoverArt, UploadWorkBanner } from "$lib/ui/upload";
	import toast from "svelte-french-toast";
	import { ApprovalStatus } from "$lib/models/content/works";
	import { Button } from "$lib/ui/util";

	export let work: Work;

	async function like() {
		if ($account.account && $account.currProfile) {
			// TODO: Add liking feature
		} else {
			toast.error(`You must be logged in to perform this action.`);
		}
	}

	async function dislike() {
		if ($account.account && $account.currProfile) {
			// TODO: Add disliking feature
		} else {
			toast.error(`You must be logged in to perform this action.`);
		}
	}

	async function addToLibrary() {
		if ($account.account && $account.currProfile) {
			// TODO: Add library feature
		} else {
			toast.error(`You must be logged in to perform this action.`);
		}
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
					<NavLink type="button">
						<BookLine class="link-icon" />
						<span class="link-name">Publish</span>
					</NavLink>
				{:else if work.approvalStatus === ApprovalStatus.Pending}
					<NavLink type="button">
						<TimeLine class="link-icon" />
						<span class="link-name">Pending</span>
					</NavLink>
				{:else if work.approvalStatus === ApprovalStatus.Rejected}
					<NavLink type="button">
						<CloseCircleLine class="link-icon" />
						<span class="link-name">Rejected</span>
					</NavLink>
				{:else if work.approvalStatus === ApprovalStatus.Approved}
					{#if work.publishedOn}
						<NavLink type="button">
							<EyeOffLine class="link-icon" />
							<span class="link-name">Hide</span>
						</NavLink>
					{:else}
						<NavLink type="button">
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
				<button title="{work.likes} likes" type="button" class="flex items-center p-2 rounded-xl transition" on:click={like}>
					<HeartLine class="mr-1" size="24px" />
					<span class="text-xl relative top-0.5" style="font-family: var(--header-text);">{abbreviate(work.likes)}</span>
				</button>
				<div class="mx-0.5"></div>
				<button title="{work.dislikes} dislikes" type="button" class="flex items-center p-2 rounded-xl transition" on:click={dislike}>
					<DislikeLine class="mr-1" size="24px" />
					<span class="text-xl relative top-0.5" style="font-family: var(--header-text);">{abbreviate(work.dislikes)}</span>
				</button>
				<div class="mx-0.5"></div>
				<button title="Add to Library" type="button" class="flex items-center p-2 rounded-xl transition" on:click={addToLibrary}>
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
	}
</style>
