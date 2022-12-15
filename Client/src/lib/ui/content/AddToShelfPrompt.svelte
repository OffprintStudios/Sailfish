<script lang="ts">
	import { onMount } from "svelte";
	import { Button } from "$lib/ui/util";
	import { CloseLine, Loader5Line } from "svelte-remixicon";
	import { popup, closePopup } from "$lib/ui/popup";
	import { getReq } from "../../http";
	import type { ResponseError } from "../../http";
	import type { Shelf } from "../../models/content/library";
	import { account } from "../../state/account.state";
	import toast from "svelte-french-toast";

	const workId: string = $popup.data.workId;
	let shelves: { shelf: Shelf, hasItem: boolean }[] = [];
	let loading = false;

	onMount(async () => {
		await fetchShelves();
	})

	async function fetchShelves() {
		loading = true;
		const response = await getReq<{shelf: Shelf, hasItem: boolean}[]>(`/shelves/check-all?workId=${workId}&profileId=${$account.currProfile.id}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			shelves = response as {shelf: Shelf, hasItem: boolean}[];
			console.log(shelves)
		}
		loading = false;
	}
</script>

<div class="rounded-xl h-[450px] w-[350px] overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed">
	<div class="flex items-center p-4">
		<h3 class="text-2xl flex-1">Add to Shelves</h3>
		<Button on:click={closePopup}>
			<CloseLine class="button-icon no-text" size="24px" />
		</Button>
	</div>
	{#if loading}
		<div class="h-[250px] w-full flex flex-col items-center justify-center">
			<span class="flex items-center font-bold tracking-wider text-xs">
				<Loader5Line size="18px" class="animate-spin" />
				<span class="ml-1">LOADING...</span>
			</span>
		</div>
	{:else if shelves.length > 0}
		<ul class="overflow-y-auto">
			{#each shelves as item}
				<li>{item.shelf.name}</li>
			{/each}
		</ul>
	{:else}
		<div class="h-full w-full flex flex-col items-center justify-center">
			<span class="font-bold tracking-wider text-xs">
				<CloseLine size="18px" />
				<span class="ml-1">NO SHELVES AVAILABLE</span>
			</span>
		</div>
	{/if}
</div>