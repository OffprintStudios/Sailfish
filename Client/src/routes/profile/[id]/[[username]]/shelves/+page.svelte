<script lang="ts">
	import { onMount } from "svelte";
	import type { Shelf } from "$lib/models/content/library";
	import { getReq, delReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import { account } from "$lib/state/account.state";
	import { Paginator } from "$lib/ui/util";
	import { DeleteBinLine, AlarmWarningLine } from "svelte-remixicon";
	import { openPopup } from "$lib/ui/popup";
	import { ShelfCard, DeleteShelfPrompt } from "$lib/ui/content";
	import toast from "svelte-french-toast";
	import type { Profile } from "$lib/models/accounts";

	export let data: Profile;
	let loading = false;
	let shelves: Paginate<Shelf> = {
		items: [],
		metadata: {
			page: 1,
			per: 20,
			total: 0
		}
	};

	onMount(async () => {
		try {
			await loadShelves(1);
		} catch (e) {
			toast.error(e);
		}
	});

	async function loadShelves(page: number) {
		loading = true;
		const response = await getReq<Paginate<Shelf>>(
			`/shelves/fetch-all?profileId=${data.id}&onlyPublic=true&page=${page}&per=20`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			loading = false;
			throw error.message;
		}
		shelves = response as Paginate<Shelf>;
		loading = false;
	}

	async function changePage(page: number) {
		await toast.promise<void>(loadShelves(page), {
			loading: "Fetching page...",
			success: "Page loaded!",
			error: "Something went wrong tyring to load this page!"
		});
	}

	function deleteShelf(id: string) {
		openPopup(DeleteShelfPrompt, {
			onConfirm: async () => {
				let result = await toast.promise<void | ResponseError>(
					delReq<void>(
						`/shelves/delete?profileId=${$account.currProfile?.id}&shelfId=${id}`
					),
					{
						loading: "Deleting...",
						success: "Shelf deleted!",
						error: null
					}
				);
				if ((result as ResponseError).error) {
					const error = result as ResponseError;
					toast.error(error.message);
				}
				await loadShelves(1);
			}
		});
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
				<ShelfCard {shelf} href="/library/shelves/{shelf.id}">
					<svelte:fragment slot="dropdown">
						{#if $account.currProfile && $account.currProfile.id === data.id}
							<button type="button" on:click={() => deleteShelf(shelf.id)}>
								<DeleteBinLine class="mr-2" size="18px" />
								<span>Delete</span>
							</button>
						{:else}
							<button type="button">
								<AlarmWarningLine class="mr-2" size="18px" />
								<span>Report</span>
							</button>
						{/if}
					</svelte:fragment>
				</ShelfCard>
			{/each}
		</div>
	{:else}
		<div class="h-full flex flex-col items-center justify-center">
			<div class="empty">
				<h3>No public shelves yet</h3>
				{#if $account.currProfile && $account.currProfile.id === data.id}
					<p>
						Go to Library > Shelves and open any shelf.<br />Hit the lock button at the
						top to set it to public.
					</p>
				{:else}
					<p>Come back later to see if they've fixed that!</p>
				{/if}
			</div>
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
		on:change={(page) => changePage(page)}
	/>
{/if}
