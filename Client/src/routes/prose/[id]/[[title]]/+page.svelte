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

	export let data: Work;
	let queueItem: ApprovalQueue;

	onMount(async () => {
		if (
			$account.account &&
			$account.currProfile &&
			hasRoles($account.account.roles, [Roles.Admin, Roles.Moderator, Roles.WorkApprover])
		) {
			await fetchQueueItem();
		}
	});

	async function fetchQueueItem() {
		const response = await getReq<ApprovalQueue>(
			`/approval-queue/fetch-one?workId=${data.id}&profileId=${$account.currProfile?.id}`
		);
		console.log(response);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			console.log(error.message);
		} else {
			console.log(`this has been added to`);
			queueItem = response as ApprovalQueue;
			console.log(queueItem);
		}
	}
</script>

<svelte:head>
	<title>{data.title} &mdash; Offprint</title>
	<!-- Primary Meta Tags -->
	<meta name="title" content={data.title} />
	<meta name="description" content={data.shortDesc} />

	<!-- Open Graph / Facebook -->
	<meta property="og:type" content="book" />
	<meta property="og:url" content="https://offprint.net/prose/{data.id}/{slugify(data.title)}" />
	<meta property="og:title" content={data.title} />
	<meta
		property="book:author"
		content="https://offprint.net/profile/{data.author.id}/{slugify(data.author.username)}"
	/>
	<meta property="og:description" content={data.shortDesc} />
	<meta property="og:image" content={data.coverArt ?? data.author.avatar} />
	<meta property="og:site_name" content="Offprint" />

	<!-- Twitter -->
	<meta property="twitter:card" content="summary" />
	<meta property="twitter:site" content="offprint" />
	<meta
		property="twitter:url"
		content="https://offprint.net/prose/{data.id}/{slugify(data.title)}"
	/>
	<meta property="twitter:title" content={data.title} />
	<meta property="twitter:description" content={data.shortDesc} />
	<meta property="twitter:image" content={data.coverArt ?? data.author.avatar} />
</svelte:head>

<div class="max-w-7xl mx-auto mb-6 lg:mt-6">
	<WorkHeader work={data} />
	{#if !data.publishedOn && !queueItem}
		<InfoBar
			message="<b>This work is a draft.</b> No views will be counted when navigating to
                                this page, and all social features (such as comments and likes/dislikes) are disabled."
		/>
		<div class="mb-6"><!--spacer--></div>
	{:else if queueItem !== null && queueItem !== undefined}
		<ApprovalOptionsBar {queueItem} />
	{/if}
	<div class="max-w-4xl w-11/12 lg:w-full mx-auto">
		<WorkInfo work={data} />
		<ListContainer work={data} />
	</div>
</div>
