<script lang="ts">
	import { onMount } from "svelte";
	import { goto } from "$app/navigation";
	import { account } from "$lib/state/account.state";
	import {
		AlarmWarningLine,
		BarChart2Line,
		BookLine,
		Bookmark3Line,
		Calendar2Line,
		CloseCircleLine,
		DeleteBinLine,
		Edit2Line,
		EyeLine,
		EyeOffLine,
		ImageAddLine,
		ImageEditLine,
		LineChartLine,
		PenNibLine,
		TimeLine,
		ThumbUpLine,
		ThumbUpFill,
		ThumbDownLine,
		ThumbDownFill
	} from "svelte-remixicon";
	import type { Work } from "$lib/models/content/works";
	import { ApprovalStatus } from "$lib/models/content/works";
	import { AddToShelfPrompt, TagBadge, AllTagsPrompt } from "$lib/ui/content";
	import { abbreviate, slugify } from "$lib/util/functions";
	import { TagKind } from "$lib/models/tags";
	import { NavLink } from "$lib/ui/nav";
	import { openPopup } from "$lib/ui/popup";
	import { UploadCoverArt, UploadWorkBanner } from "$lib/ui/upload";
	import toast from "svelte-french-toast";
	import { Button, Time } from "$lib/ui/util";
	import type { ReadingHistory } from "$lib/models/content/library";
	import { Vote } from "$lib/models/content/library";
	import type { ResponseError } from "$lib/http";
	import { delReq, getReq, patchReq, putReq } from "$lib/http";
	import PublishWorkPrompt from "./PublishWorkPrompt.svelte";
	import DeleteWorkPrompt from "./DeleteWorkPrompt.svelte";
	import { ReportForm } from "$lib/ui/admin";
	import { ReportKind } from "$lib/models/admin/users/reports";
	import { page } from "$app/stores";

	export let work: Work;
	export let history: ReadingHistory;
	const fandoms = work.tags.filter((value) => value.kind === TagKind.fandom);
	let library: { hasItem: boolean } = { hasItem: false };
	let isVoting = false;
	let isAddingToLibrary = false;

	console.log(history);

	onMount(async () => {
		if (
			$account.account &&
			$account.currProfile &&
			$account.currProfile.id !== work.author.id
		) {
			await checkLibrary();
		}
	});

	async function checkLibrary() {
		if (work.publishedOn === undefined || work.publishedOn <= new Date()) {
			toast.error(`This feature is disabled for unpublished works.`);
			return;
		}
		const response = await getReq<{ hasItem: boolean }>(
			`/history/fetch-one?workId=${work.id}&profileId=${$account.currProfile?.id}`
		);
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
			const response = await patchReq<ReadingHistory>(
				`/history/set-vote?workId=${work.id}&profileId=${$account.currProfile.id}`,
				{
					vote: history.vote === vote ? Vote.noVote : vote
				}
			);
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
				response = await delReq<{ hasItem: boolean }>(
					`/library/remove-one?workId=${work.id}&profileId=${$account.currProfile.id}`
				);
			} else {
				response = await putReq<{ hasItem: boolean }>(
					`/library/add-one?workId=${work.id}&profileId=${$account.currProfile.id}`,
					{}
				);
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
		openPopup(
			UploadCoverArt,
			{
				onConfirm(value: Work) {
					work = value;
				}
			},
			{ workId: work.id }
		);
	}

	function updateBannerArt() {
		openPopup(
			UploadWorkBanner,
			{
				onConfirm(value: Work) {
					work = value;
				}
			},
			{ workId: work.id }
		);
	}

	function publishWork() {
		openPopup(PublishWorkPrompt, {
			onConfirm: async () => {
				const response = await toast.promise(
					patchReq<void>(
						`/works/publish-work/${work.id}?profileId=${$account.currProfile?.id}`,
						{}
					),
					{
						loading: "Submitting to queue...",
						success: "Your work has been submitted!",
						error: null
					}
				);
				if ((response as ResponseError).error) {
					const error = response as ResponseError;
					toast.error(error.message);
				} else {
					work.approvalStatus = ApprovalStatus.Pending;
				}
			}
		});
	}

	async function hideShow() {
		if (work.approvalStatus !== ApprovalStatus.Approved) {
			toast.error(`Your work must first be approved before you can access this function.`);
			return;
		}
		const response = await toast.promise<void>(
			patchReq<void>(`/works/hide-show/${work.id}?profileId=${$account.currProfile?.id}`, {}),
			{
				loading: "Changing visibility...",
				success: "Changes saved!",
				error: null
			}
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			work.publishedOn = undefined;
		}
	}

	async function addToShelf() {
		openPopup(
			AddToShelfPrompt,
			{
				onConfirm: async () => {
					console.log(`hit!`);
				}
			},
			{ workId: work.id }
		);
	}

	async function deleteWork() {
		openPopup(DeleteWorkPrompt, {
			onConfirm: async () => {
				const result = await toast.promise<void | ResponseError>(
					delReq<void>(
						`/works/delete-work/${work.id}?profileId=${$account.currProfile?.id}`
					),
					{
						loading: "Deleting work...",
						success: "Work deleted!",
						error: null
					}
				);
				if ((result as ResponseError).error) {
					const error = result as ResponseError;
					toast.error(error.message);
				} else {
					await goto(`/profile/${work.author.id}/${slugify(work.author.username)}/works`);
				}
			}
		});
	}

	function reportWork() {
		openPopup(ReportForm, null, {
			kind: ReportKind.Work,
			accountId: work.author.account.id,
			itemId: work.id,
			link: $page.url.pathname
		});
	}

	function openAllTags() {
		openPopup(AllTagsPrompt, null, { tags: work.tags });
	}
</script>

<div class="header-container bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	{#if work.coverArt}
		<div class="cover-art">
			<div
				class="relative overflow-hidden w-max flex flex-col items-center justify-center bg-zinc-200 dark:bg-zinc-700 border-4 border-zinc-300 dark:border-zinc-600 rounded-xl z-[2]"
				style="box-shadow: var(--dropshadow);"
			>
				<img
					src={work.coverArt}
					alt="cover art"
					class="max-w-[150px] max-h-[110px] lg:max-w-[250px] lg:max-h-[210px]"
				/>
				{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
					<div class="absolute top-2 right-2">
						<Button kind="primary" title="Edit Cover Art" on:click={updateCoverArt}>
							<ImageEditLine class="button-icon no-text" />
						</Button>
					</div>
				{/if}
			</div>
		</div>
	{:else if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
		<div class="cover-art w-[180px]">
			<div
				class="lg:flex flex-col items-center justify-center w-[180px] h-[215px] bg-zinc-200 dark:bg-zinc-700 border-4 border-zinc-300 dark:border-zinc-600 rounded-xl hidden"
				style="box-shadow: var(--dropshadow);"
			>
				<NavLink type="button" on:click={updateCoverArt}>
					<ImageAddLine class="link-icon" />
					<span class="link-name">Add Cover</span>
				</NavLink>
			</div>
			<div class="block lg:hidden">
				<Button on:click={updateCoverArt}>
					<ImageAddLine class="button-icon" />
					<span class="button-text">Add Cover</span>
				</Button>
			</div>
		</div>
	{:else}
		<div class="cover-art"><!--this is meant to be empty--></div>
	{/if}
	<div class="banner {work.bannerArt ? 'big-art' : 'small-art'}">
		{#if work.bannerArt}
			<img src={work.bannerArt} alt="cover art" class="w-full h-full object-cover" />
		{/if}
		<div class="absolute top-2 right-2 z-[2]">
			<div class="lg:flex items-center hidden">
				<TagBadge kind={TagKind.category} category={work.category} />
				<div class="mx-[0.075rem]"><!--spacer--></div>
				<TagBadge kind={TagKind.status} status={work.status} />
				<div class="mx-[0.075rem]"><!--spacer--></div>
				<TagBadge kind={TagKind.rating} rating={work.rating} />
				{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
					<div class="mx-2 text-white text-lg relative top-[0.1625rem]">|</div>
					<div class="relative top-0.5">
						<Button on:click={updateBannerArt} kind="primary">
							{#if work.bannerArt}
								<ImageEditLine class="button-icon no-text" size="18px" />
							{:else}
								<ImageAddLine class="button-icon no-text" size="18px" />
							{/if}
						</Button>
					</div>
				{/if}
			</div>
			<div class="flex items-center lg:hidden">
				<TagBadge kind={TagKind.category} category={work.category} size="small" />
				<div class="mx-[0.075rem]"><!--spacer--></div>
				<TagBadge kind={TagKind.status} status={work.status} size="small" />
				<div class="mx-[0.075rem]"><!--spacer--></div>
				<TagBadge kind={TagKind.rating} rating={work.rating} size="small" />
				{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
					<div class="mx-2 text-white text-lg relative top-[0.1625rem]">|</div>
					<div class="relative top-0.5">
						<Button on:click={updateBannerArt} kind="primary">
							{#if work.bannerArt}
								<ImageEditLine class="button-icon no-text" size="16px" />
							{:else}
								<ImageAddLine class="button-icon no-text" size="16px" />
							{/if}
						</Button>
					</div>
				{/if}
			</div>
		</div>
	</div>
	<div class="title-bar">
		<div class="flex-1 hidden lg:block">
			<h1 class="text-2xl lg:text-3xl" style="color: var(--text-color);">
				{work.title}
			</h1>
			<div class="flex items-center flex-wrap">
				<span
					class="relative top-0.5 text-base lg:text-xl font-medium text-zinc-400"
					style="font-family: var(--header-text);"
				>
					by <a
						class="text-zinc-400"
						href="/profile/{work.author.id}/{slugify(work.author.username)}"
						>{work.author.username}</a
					>
				</span>
				<span class="mx-1 text-zinc-400 hidden lg:block">•</span>
				<div class="hidden lg:flex items-center flex-wrap">
					{#each work.tags as tag}
						{#if tag.kind === TagKind.genre}
							<TagBadge {tag} kind={tag.kind} />
							<div class="mx-[0.075rem]"><!--spacer--></div>
						{/if}
					{/each}
					{#each fandoms as tag, i}
						{#if i === 0}
							<TagBadge {tag} kind={tag.kind} />
							<button
								class="relative text-lg top-0.5 ml-2 text-zinc-400"
								style="font-family: var(--header-text);"
								on:click={openAllTags}
							>
								+ {fandoms.length - 1} more
							</button>
						{/if}
					{/each}
				</div>
			</div>
		</div>
		<div class="flex-1 lg:hidden"><!--spacer--></div>
		<div class="flex items-center bg-zinc-300 dark:bg-zinc-600 rounded-xl p-1">
			{#if history}
				<Button
					loading={isVoting}
					loadingText="''"
					isPositive={history.vote === Vote.liked}
					on:click={() => setVote(Vote.liked)}
				>
					{#if history.vote === Vote.liked}
						<ThumbUpFill class="button-icon" />
						<span class="button-small-text">{abbreviate(work.likes + 1)}</span>
					{:else}
						<ThumbUpLine class="button-icon text-green-600" />
						<span class="button-small-text text-green-600"
							>{abbreviate(work.likes)}</span
						>
					{/if}
				</Button>
				<div class="mx-0.5"><!--spacer--></div>
				<Button
					loading={isVoting}
					loadingText="''"
					isNegative={history.vote === Vote.disliked}
					on:click={() => setVote(Vote.disliked)}
				>
					{#if history.vote === Vote.disliked}
						<ThumbDownFill class="button-icon" />
						<span class="button-small-text">{abbreviate(work.dislikes + 1)}</span>
					{:else}
						<ThumbDownLine class="button-icon text-red-600" />
						<span class="button-small-text text-red-600"
							>{abbreviate(work.dislikes)}</span
						>
					{/if}
				</Button>
			{:else}
				<Button>
					<ThumbUpLine class="button-icon text-green-600" />
					<span class="button-small-text text-green-600">{abbreviate(work.likes)}</span>
				</Button>
				<div class="mx-0.5"><!--spacer--></div>
				<Button>
					<ThumbDownLine class="button-icon text-red-600" />
					<span class="button-small-text text-red-600">{abbreviate(work.dislikes)}</span>
				</Button>
			{/if}
		</div>
	</div>
	<div class="tool-bar">
		<div class="basis-full block mb-2 lg:hidden">
			<h1 class="text-2xl lg:text-3xl" style="color: var(--text-color);">
				{work.title}
			</h1>
			<span
				class="relative top-0.5 text-base lg:text-xl font-medium text-zinc-400"
				style="font-family: var(--header-text);"
			>
				by <a
					class="text-zinc-400"
					href="/profile/{work.author.id}/{slugify(work.author.username)}"
					>{work.author.username}</a
				>
			</span>
		</div>
		<div class="flex items-center flex-wrap basis-full mb-4 lg:hidden">
			{#each work.tags as tag}
				{#if tag.kind === TagKind.genre}
					<TagBadge {tag} kind={tag.kind} size="small" />
					<div class="mx-[0.075rem]"><!--spacer--></div>
				{/if}
			{/each}
			{#each fandoms as tag, i}
				{#if i === 0}
					<TagBadge {tag} kind={tag.kind} size="small" />
					<button
						class="relative text-sm lg:text-base top-1 lg:top-0.5 ml-2 text-zinc-400"
						style="font-family: var(--header-text);"
						on:click={openAllTags}
					>
						+ {fandoms.length - 1} more
					</button>
				{/if}
			{/each}
		</div>
		<div class="flex items-center p-1 bg-zinc-300 dark:bg-zinc-600 rounded-xl">
			{#if $account.account && $account.currProfile && $account.currProfile.id === work.author.id}
				{#if work.approvalStatus === ApprovalStatus.NotSubmitted}
					<Button type="button" on:click={publishWork}>
						<BookLine class="button-icon variable-text" />
						<span class="button-text hidden lg:block">Publish</span>
					</Button>
				{:else if work.approvalStatus === ApprovalStatus.Pending}
					<Button type="button">
						<TimeLine class="button-icon variable-text" />
						<span class="button-text hidden lg:block">Pending</span>
					</Button>
				{:else if work.approvalStatus === ApprovalStatus.Rejected}
					<Button type="button" on:click={publishWork}>
						<CloseCircleLine class="button-icon variable-text" />
						<span class="button-text hidden lg:block">Rejected</span>
					</Button>
				{:else if work.approvalStatus === ApprovalStatus.Approved}
					{#if work.publishedOn}
						<Button type="button" on:click={hideShow}>
							<EyeOffLine class="button-icon variable-text" />
							<span class="button-text hidden lg:block">Hide</span>
						</Button>
					{:else}
						<Button type="button" on:click={hideShow}>
							<EyeLine class="button-icon variable-text" />
							<span class="button-text hidden lg:block">Show</span>
						</Button>
					{/if}
				{/if}
				<div class="mx-0.5"><!--spacer--></div>
				<Button on:click={() => goto(`/prose/${work.id}/${slugify(work.title)}/edit`)}>
					<Edit2Line class="button-icon variable-text" />
					<span class="button-text hidden lg:block">Edit</span>
				</Button>
				<Button on:click={addToShelf}>
					<BarChart2Line class="button-icon variable-text" />
					<span class="button-text hidden lg:block">Shelves</span>
				</Button>
				<div class="mx-1 text-zinc-400 text-lg relative top-[0.075rem]">|</div>
				<Button on:click={deleteWork}>
					<DeleteBinLine class="button-icon variable-text" />
					<span class="button-text hidden lg:block">Delete</span>
				</Button>
			{:else if $account.account && $account.currProfile && $account.currProfile.id !== work.author.id}
				<Button on:click={setLibrary}>
					<Bookmark3Line class="button-icon variable-text" />
					<span class="button-text hidden lg:block">Library</span>
				</Button>
				<div class="mx-0.5"><!--spacer--></div>
				<Button on:click={addToShelf}>
					<BarChart2Line class="button-icon variable-text" />
					<span class="button-text hidden lg:block">Shelves</span>
				</Button>
				<div class="mx-1 text-zinc-400 text-lg relative top-[0.075rem]">|</div>
				<Button on:click={reportWork}>
					<AlarmWarningLine class="button-icon variable-text" />
					<span class="button-text hidden lg:block">Report</span>
				</Button>
			{:else}
				<Button disabled>
					<Bookmark3Line class="button-icon variable-text" />
					<span class="button-text hidden lg:block">Library</span>
				</Button>
				<div class="mx-0.5"><!--spacer--></div>
				<Button disabled>
					<BarChart2Line class="button-icon variable-text" />
					<span class="button-text hidden lg:block">Shelves</span>
				</Button>
				<div class="mx-1 text-zinc-400 text-lg relative top-[0.075rem]">|</div>
				<Button disabled>
					<AlarmWarningLine class="button-icon variable-text" />
					<span class="button-text hidden lg:block">Report</span>
				</Button>
			{/if}
		</div>
		<div class="flex-1"><!--spacer--></div>
		<div
			class="flex items-center lg:mt-4 self-center justify-center lg:mt-0 lg:self-end lg:justify-end text-xs lg:text-base text-zinc-400"
			style="font-family: var(--header-text);"
		>
			<span class="flex items-center relative z-[2]" title="Views">
				<LineChartLine class="mr-1 w-[16px] h-[16px] lg:w-[20px] lg:h-[20px]" />
				<span class="relative">{abbreviate(work.views)}</span>
			</span>
			<span class="mx-2">/</span>
			<span class="flex items-center relative z-[2]" title="Words">
				<PenNibLine class="mr-1 w-[16px] h-[16px] lg:w-[20px] lg:h-[20px]" />
				<span class="relative">{abbreviate(work.words)}</span>
			</span>
			<span class="hidden lg:block mx-2">/</span>
			{#if work.publishedOn}
				<span class="lg:flex items-center relative z-[2] hidden" title="Published On">
					<Calendar2Line class="mr-1 w-[16px] h-[16px] lg:w-[20px] lg:h-[20px]" />
					<span class="relative"
						><Time timestamp={work.publishedOn} format="MMM DD, YYYY" /></span
					>
				</span>
			{:else}
				<span class="lg:flex items-center relative z-[2] hidden" title="Created On">
					<Calendar2Line class="mr-1 w-[16px] h-[16px] lg:w-[20px] lg:h-[20px]" />
					<span class="relative"
						><Time timestamp={work.createdAt} format="MMM DD, YYYY" /></span
					>
				</span>
			{/if}
		</div>
	</div>
</div>

<style lang="scss">
	div.header-container {
		@apply grid lg:rounded-xl relative w-full mb-6 overflow-hidden;
		grid-template-areas:
			"banner banner"
			"cover title"
			"action action";
		grid-template-rows: 1fr auto auto;
		grid-template-columns: auto 1fr;
		@media (min-width: 1024px) {
			grid-template-areas:
				"banner banner"
				"cover title"
				"action action";
			grid-template-columns: auto 1fr;
		}
		div.cover-art {
			grid-area: banner / banner / cover / cover;
			display: flex;
			align-items: flex-end;
			@apply px-4 pb-4 lg:p-4 relative items-end justify-self-start;
		}
		div.banner {
			background: var(--accent);
			grid-area: banner;
		}
		div.title-bar {
			grid-area: title;
			@apply p-4 pl-0 flex items-center z-[2] relative;
		}
		div.tool-bar {
			grid-area: action;
			@apply flex items-center mx-4 mb-4 flex-wrap;
		}
		button.utility {
			@apply flex items-center p-2 rounded-xl transition hidden lg:block;
			&.active {
				@apply text-white;
				background: var(--accent);
			}
		}
		div.big-art {
			@apply h-[200px] lg:h-[250px];
		}
		div.small-art {
			@apply h-[100px] lg:h-[150px];
		}
	}
</style>
