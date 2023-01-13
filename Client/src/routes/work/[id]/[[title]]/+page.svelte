<script lang="ts">
	import { onMount } from "svelte";
	import type { Work } from "$lib/models/content/works";
	import { slugify } from "$lib/util/functions";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import { account } from "$lib/state/account.state";
	import { InfoBar } from "$lib/ui/util";
	import WorkHeader from "./WorkHeader.svelte";
	import WorkInfo from "./WorkInfo.svelte";
	import ListContainer from "./ListContainer.svelte";
	import ApprovalOptionsBar from "./ApprovalOptionsBar.svelte";
	import type { ApprovalQueue } from "$lib/models/admin/approval-queue";
	import { hasRoles } from "$lib/util/functions";
	import { Roles } from "$lib/models/accounts";
	import type { ReadingHistory } from "$lib/models/content/library";
	import toast from "svelte-french-toast";
	import type { Paginate } from "$lib/util/types";
	import { type Comment, CommentType } from "$lib/models/comments";
	import { page } from "$app/stores";
	import { Thread } from "$lib/ui/comments";

	export let data: { work: Work; comments: Paginate<Comment> };
	let queueItem: ApprovalQueue;
	let history: ReadingHistory;
	let pageNum = +($page.url.searchParams.get("page") ?? "1");
	let perPage = +($page.url.searchParams.get("per") ?? "25");

	onMount(async () => {
		if (
			$account.account &&
			$account.currProfile &&
			hasRoles($account.account.roles, [Roles.Admin, Roles.Moderator, Roles.WorkApprover])
		) {
			await fetchQueueItem();
		}
		if (
			data.work.publishedOn !== undefined &&
			data.work.publishedOn !== null &&
			$account.account &&
			$account.currProfile
		) {
			await fetchHistory();
		}
	});

	async function fetchQueueItem() {
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
	}
</script>

<svelte:head>
	<title>{data.work.title} &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content={data.work.title} />
	<meta name="description" content={data.work.shortDesc} />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="book" />
	<meta
		property="og:url"
		content="https://offprint.net/prose/{data.work.id}/{slugify(data.work.title)}"
	/>
	<meta property="og:title" content={data.work.title} />
	<meta
		property="book:author"
		content="https://offprint.net/profile/{data.work.author.id}/{slugify(
			data.work.author.username
		)}"
	/>
	<meta property="og:description" content={data.work.shortDesc} />
	<meta property="og:image" content={data.work.coverArt ?? data.work.author.avatar} />
	<meta property="og:site_name" content="Offprint" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary" />
	<meta property="twitter:site" content="offprint" />
	<meta
		property="twitter:url"
		content="https://offprint.net/prose/{data.work.id}/{slugify(data.work.title)}"
	/>
	<meta property="twitter:title" content={data.work.title} />
	<meta property="twitter:description" content={data.work.shortDesc} />
	<meta property="twitter:image" content={data.work.coverArt ?? data.work.author.avatar} />
</svelte:head>

<div class="max-w-7xl mx-auto mb-6 lg:mt-6">
	<WorkHeader work={data.work} {history} />
	{#if !data.work.publishedOn && !queueItem}
		<InfoBar
			message="<b>This work is a draft.</b> No views will be counted when navigating to
                                this page, and all social features (such as comments and likes/dislikes) are disabled."
		/>
		<div class="mb-6"><!--spacer--></div>
	{:else if queueItem !== null && queueItem !== undefined}
		<ApprovalOptionsBar {queueItem} />
	{/if}
	<div class="max-w-4xl w-11/12 lg:w-full mx-auto">
		<WorkInfo work={data.work} />
		<ListContainer work={data.work} {history} />
		{#if data.work.publishedOn && data.comments}
			<div class="my-6 border-b w-full"><!--spacer--></div>
			<Thread
				type={CommentType.Work}
				threadId={data.work.id}
				content={data.comments}
				{pageNum}
				{perPage}
			/>
		{/if}
	</div>
</div>
