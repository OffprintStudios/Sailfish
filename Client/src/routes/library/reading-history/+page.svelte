<script lang="ts">
	import { onMount } from "svelte";
	import { getReq } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { ResponseError } from "$lib/http";
	import type { ReadingHistory } from "$lib/models/content/library";
	import { Paginator } from "$lib/ui/util";
	import { account } from "$lib/state/account.state";
	import { WorkCard } from "$lib/ui/content";
	import toast from "svelte-french-toast";

	let loading = false;
	let history: Paginate<ReadingHistory> = null;

	onMount(async () => {
		await loadHistory(1);
	});

	async function loadHistory(page: number) {
		loading = true;
		const response = await getReq<Paginate<ReadingHistory>>(
			`/history/fetch-all?profileId=${$account.currProfile.id}&page=${page}&per=20`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			history = response as Paginate<ReadingHistory>;
		}
		loading = false;
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
					<svelte:fragment slot="dropdown" />
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
		currPage={history.metadata.page}
		perPage={history.metadata.per}
		totalItems={history.metadata.total}
		on:change={(page) => loadHistory(page)}
	/>
{/if}
