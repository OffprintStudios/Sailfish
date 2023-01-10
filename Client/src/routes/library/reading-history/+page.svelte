<script lang="ts">
	import { onMount } from "svelte";
	import { getReq, patchReq, type ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { ReadingHistory } from "$lib/models/content/library";
	import { Paginator } from "$lib/ui/util";
	import { account } from "$lib/state/account.state";
	import { WorkCard } from "$lib/ui/content";
	import toast from "svelte-french-toast";
	import { page } from "$app/stores";
	import { EyeOffLine, Loader5Line } from "svelte-remixicon";

	let loading = false;
	let hiding = false;
	let currPage = +($page.url.searchParams.get("page") ?? "1");
	let perPage = +($page.url.searchParams.get("per") ?? "21");
	let history: Paginate<ReadingHistory> = {
		items: [],
		metadata: {
			page: 1,
			per: 21,
			total: 0
		}
	};

	onMount(async () => {
		await loadHistory(1);
	});

	async function loadHistory(newPage: number) {
		loading = true;
		currPage = newPage;
		const response = await getReq<Paginate<ReadingHistory>>(
			`/history/fetch-all?profileId=${$account.currProfile?.id}&page=${currPage}&per=${perPage}`
		);
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			history = response as Paginate<ReadingHistory>;
		}
		loading = false;
	}

	async function hide(id: string) {
		hiding = true;
		const response = await patchReq<void>(
			`/history/hide?profileId=${$account.currProfile?.id}`,
			{ id }
		);
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			await loadHistory(currPage);
		}
		hiding = false;
	}
</script>

{#if loading && !history}
	<div class="h-full flex flex-col items-center justify-center">
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	</div>
{:else if history}
	{#if history.items.length > 0}
		<div class="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-4">
			{#each history.items as item}
				<WorkCard work={item.work}>
					<svelte:fragment slot="dropdown">
						<button type="button" disabled={hiding} on:click={() => hide(item.id)}>
							{#if hiding}
								<Loader5Line size="18px" class="mr-1" />
								<span>Saving...</span>
							{:else}
								<EyeOffLine class="mr-1" size="18px" />
								<span>Hide</span>
							{/if}
						</button>
					</svelte:fragment>
				</WorkCard>
			{/each}
		</div>
	{:else}
		<div class="h-full flex flex-col items-center justify-center">
			<div class="empty">
				<h3>You haven't read anything yet</h3>
				<p>Whenever you open any published work, it'll show up here.</p>
			</div>
		</div>
	{/if}
	{#if loading}
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	{/if}
{:else}
	<div class="empty">
		<h3>Something went wrong!</h3>
		<p>Try again in a little bit.</p>
	</div>
{/if}

{#if history && history.items.length > 0}
	<Paginator
		{currPage}
		{perPage}
		totalItems={history.metadata.total}
		on:change={(event) => loadHistory(event.detail)}
	/>
{/if}
