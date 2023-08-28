<script lang="ts">
	import { onMount } from "svelte";
	import type { FetchWorkPage } from "$lib/models/content/works";
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
	import { page } from "$app/stores";

	export let data: FetchWorkPage;
	let queueItem: ApprovalQueue;
	let history: ReadingHistory;
	let pageNum = +($page.url.searchParams.get("page") ?? "1");
	let perPage = +($page.url.searchParams.get("per") ?? "25");

	/*onMount(async () => {
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
	});*/

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

<div class="max-w-7xl mx-auto mb-6 xl:mt-6">
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
	</div>
</div>
