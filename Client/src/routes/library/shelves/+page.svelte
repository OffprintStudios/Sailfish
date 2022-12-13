<script lang="ts">
	import { onMount } from "svelte";
	import type { Shelf } from "$lib/models/content/library";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import { account } from "$lib/state/account.state";
	import { Paginator } from "$lib/ui/util";
	import toast from "svelte-french-toast";

	let loading = false;
	let shelves: Paginate<Shelf> = null;

	onMount(async () => {
		await loadShelves(1);
	})

	async function loadShelves(page: number) {
		loading = true;
		const response = await getReq<Paginate<Shelf>>(`/shelves/fetch-all?profileId=${$account.currProfile.id}&page=${page}&per=20`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			shelves = response as Paginate<Shelf>;
		}
		loading = false;
	}
</script>

{#if loading && !shelves}
	<div class="h-full flex flex-col items-center justify-center">
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	</div>
{:else if shelves}
	{#if shelves.items.length > 0}
		<div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
			{#each shelves.items as shelf}
				{shelf.name}
			{/each}
		</div>
	{:else}
		<div class="h-full flex flex-col items-center justify-center">
			<div class="empty">
				<h3>You haven't created anything yet</h3>
				<p>Click the Add Shelf button to get started.</p>
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

{#if shelves && shelves.items.length > 0}
	<Paginator
		currPage={shelves.metadata.page}
		perPage={shelves.metadata.per}
		totalItems={shelves.metadata.total}
		on:change={(page) => loadShelves(page)}
	/>
{/if}
