<script lang="ts">
	import { getReq, patchReq } from "$lib/http";
	import toast from "svelte-french-toast";
	import type { ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { ApprovalQueue } from "$lib/models/admin/approval-queue";
	import { Status } from "$lib/models/admin/approval-queue";
	import { Button, Paginator, Time, Avatar } from "$lib/ui/util";
	import { SortAsc, SortDesc, AddBoxLine } from "svelte-remixicon";
	import { WorkCard } from "$lib/ui/content";
	import { account } from "$lib/state/account.state";

	export let data: Paginate<ApprovalQueue>;
	let ascending = true;
	let currStatus = Status.waiting;

	$: loadQueue(1, currStatus);

	async function loadQueue(page: number, status: Status) {
		const response = await getReq<Paginate<ApprovalQueue>>(
			`/approval-queue/fetch-all?page=${page}&per=24&ascending=${ascending}&status=${status}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			throw error.message;
		} else {
			data = response as Paginate<ApprovalQueue>;
		}
	}

	async function switchDirection() {
		ascending = !ascending;
		await loadQueue(1, currStatus);
	}

	async function changePage(newPage: number) {
		try {
			await toast.promise<void>(loadQueue(newPage, currStatus), {
				loading: "Fetching works...",
				success: "Fetch successful!",
				error: null
			});
		} catch (err) {
			toast.error(err);
		}
	}

	async function claimItem(id: string) {
		const response = await toast.promise<ApprovalQueue | ResponseError>(
			patchReq<ApprovalQueue>(
				`/approval-queue/claim-one?itemId=${id}&profileId=${$account.currProfile?.id}`,
				{}
			),
			{
				loading: "Claiming work...",
				success: "Work claimed!",
				error: null
			}
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			await loadQueue(1, currStatus);
		}
	}
</script>

<div class="w-11/12 lg:w-full max-w-6xl mx-auto">
	<div class="flex items-center">
		<Button isActive={ascending} on:click={switchDirection}>
			<SortAsc class="button-icon" />
			<span class="button-text">Ascending</span>
		</Button>
		<div class="mx-0.5"><!--spacer--></div>
		<Button isActive={!ascending} on:click={switchDirection}>
			<SortDesc class="button-icon" />
			<span class="button-text">Descending</span>
		</Button>
		<div class="flex-1"><!--spacer--></div>
		<select
			class="w-[150px] lg:w-[250px] border-transparent bg-zinc-200 dark:bg-zinc-700 rounded-xl dark:highlight-shadowed"
			bind:value={currStatus}
		>
			<option value={Status.waiting}>{Status.waiting}</option>
			<option value={Status.claimed}>{Status.claimed}</option>
			<option value={Status.rejected}>{Status.rejected}</option>
			<option value={Status.approved}>{Status.approved}</option>
		</select>
	</div>
	{#if data.items.length === 0}
		<div class="h-full flex flex-col items-center justify-center">
			<div class="empty">
				<h3>And nothing was there...</h3>
				<p>Except dust bunnies and the stench of old paper.</p>
			</div>
		</div>
	{:else}
		<div class="grid grid-cols-1 lg:grid-cols-2 gap-4 my-6">
			{#each data.items as item}
				<div class="bg-zinc-200 dark:bg-zinc-700 rounded-xl p-2">
					<div class="flex items-center pb-2 mx-auto">
						{#if item.claimedBy}
							<Avatar src={item.claimedBy.avatar} size="32px" borderWidth="1px" />
							<span
								class="ml-2 text-zinc-400 relative top-0.5 text-lg"
								style="font-family: var(--header-text);"
							>
								{item.claimedBy.username}
							</span>
						{:else}
							<Button
								kind="primary"
								title="Claim"
								on:click={() => claimItem(item.id)}
							>
								<AddBoxLine class="button-icon" size="20px" />
								<span class="button-text">Claim</span>
							</Button>
						{/if}
						<div class="flex-1" />
						<span class="text-zinc-400" style="font-family: var(--header-text);">
							Added <Time relative timestamp={item.createdAt} />
						</span>
					</div>
					<WorkCard work={item.work} withDropdown={false} />
				</div>
			{/each}
		</div>
	{/if}
	{#if data.items.length > 0}
		<Paginator
			currPage={data.metadata.page}
			perPage={data.metadata.per}
			totalItems={data.metadata.total}
			on:change={(page) => changePage(page)}
		/>
	{/if}
</div>
