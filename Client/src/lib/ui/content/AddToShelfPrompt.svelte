<script lang="ts">
	import { onMount } from "svelte";
	import { Button } from "$lib/ui/util";
	import { AddBoxLine, CheckLine, CloseLine, Loader5Line } from "svelte-remixicon";
	import { popup, closePopup } from "$lib/ui/popup";
	import { getReq, postReq, type ResponseError } from "$lib/http";
	import type { Shelf } from "$lib/models/content/library";
	import { account } from "$lib/state/account.state";
	import toast from "svelte-french-toast";

	const workId: string = $popup.data.workId;
	let shelves: { shelf: Shelf; hasItem: boolean }[] = [];
	let loading = false;
	let stateChanging = false;

	onMount(async () => {
		await fetchShelves();
	});

	async function fetchShelves() {
		loading = true;
		const response = await getReq<{ shelf: Shelf; hasItem: boolean }[]>(
			`/shelves/check-all?workId=${workId}&profileId=${$account.currProfile?.id}`
		);
		if ((response as ResponseError).statusCode) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			shelves = response as { shelf: Shelf; hasItem: boolean }[];
		}
		loading = false;
	}

	async function addToShelf(shelfId: string) {
		stateChanging = true;
		const result = await toast.promise<void | ResponseError>(
			postReq<void>(
				`/shelves/add?workId=${workId}&shelfId=${shelfId}&profileId=${$account.currProfile?.id}`,
				{}
			),
			{
				loading: "Adding to shelf...",
				success: "Work added!",
				error: null
			}
		);
		if ((result as ResponseError).statusCode) {
			const error = result as ResponseError;
			toast.error(error.message);
		} else {
			await fetchShelves();
		}
		stateChanging = false;
	}

	async function removeFromShelf(shelfId: string) {
		stateChanging = true;
		const result = await toast.promise<void | ResponseError>(
			postReq<void>(
				`/shelves/remove?workId=${workId}&shelfId=${shelfId}&profileId=${$account.currProfile?.id}`,
				{}
			),
			{
				loading: "Removing from shelf...",
				success: "Work removed!",
				error: null
			}
		);
		if ((result as ResponseError).statusCode) {
			const error = result as ResponseError;
			toast.error(error.message);
		} else {
			await fetchShelves();
		}
		stateChanging = false;
	}
</script>

<div
	class="rounded-xl h-[450px] w-[350px] overflow-hidden bg-zinc-200 dark:bg-zinc-700 dark:highlight-shadowed"
>
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
		<ul class="px-4 pb-4">
			{#each shelves as item}
				<li class="odd:bg-zinc-300 odd:dark:bg-zinc-600">
					{#if item.hasItem}
						<button
							class="shelf-button"
							disabled={stateChanging}
							on:click={() => removeFromShelf(item.shelf.id)}
						>
							<span class="flex-1 text-left">{item.shelf.name}</span>
							{#if stateChanging}
								<Loader5Line size="18px" class="animate-spin" />
							{:else}
								<CheckLine size="18px" />
							{/if}
						</button>
					{:else}
						<button
							class="shelf-button"
							disabled={stateChanging}
							on:click={() => addToShelf(item.shelf.id)}
						>
							<span class="flex-1 text-left">{item.shelf.name}</span>
							{#if stateChanging}
								<Loader5Line size="18px" class="animate-spin" />
							{:else}
								<AddBoxLine size="18px" />
							{/if}
						</button>
					{/if}
				</li>
			{/each}
		</ul>
	{:else}
		<div class="h-full w-full flex flex-col items-center justify-center">
			<span class="flex items-center font-bold tracking-wider text-xs">
				<CloseLine size="18px" />
				<span class="ml-1">NO SHELVES AVAILABLE</span>
			</span>
		</div>
	{/if}
</div>

<style lang="scss">
	button.shelf-button {
		@apply flex w-full items-center text-sm transition transform h-full p-2;
		color: var(--text-color);
		span.title {
			@apply flex-1;
		}
		&:hover {
			background: var(--accent);
			@apply text-white;
		}
	}
</style>
