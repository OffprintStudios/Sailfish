<script lang="ts">
	import type { Shelf } from "$lib/models/content/library";
	import { ShelfHeader, WorkCard } from "$lib/ui/content";
	import type { Paginate } from "$lib/util/types";
	import { onMount } from "svelte";
	import toast from "svelte-french-toast";
	import { getReq, postReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import type { Work } from "$lib/models/content/works";
	import { account } from "$lib/state/account.state";
	import { Paginator } from "$lib/ui/util";
	import { CloseLine } from "svelte-remixicon";

	export let data: Shelf;
	let loading = false;
	let works: Paginate<Work> = {
		items: [],
		metadata: {
			page: 1,
			per: 20,
			total: 0
		}
	};

	onMount(async () => {
		try {
			await loadWorks(1);
		} catch (e) {
			toast.error(e);
		}
	});

	async function loadWorks(page: number) {
		loading = true;
		const response = await getReq<Paginate<Work>>(
			`/shelves/fetch-items?profileId=${$account.currProfile?.id}&shelfId=${data.id}&page=${page}&per=20`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			loading = false;
			throw error.message;
		}
		works = response as Paginate<Work>;
		loading = false;
	}

	async function changePage(page: number) {
		await toast.promise<void>(loadWorks(page), {
			loading: "Fetching page...",
			success: "Page loaded!",
			error: "Something went wrong tyring to load this page!"
		});
	}

	async function removeFromShelf(id: string) {
		const result = await toast.promise<void | ResponseError>(
			postReq<void>(
				`/shelves/remove?workId=${id}&shelfId=${data.id}&profileId=${$account.currProfile?.id}`,
				{}
			),
			{
				loading: "Removing from shelf...",
				success: "Work removed!",
				error: null
			}
		);
		if ((result as ResponseError).error) {
			const error = result as ResponseError;
			toast.error(error.message);
		} else {
			try {
				await loadWorks(1);
			} catch (e) {
				toast.error(e);
			}
		}
	}
</script>

<div class="max-w-6xl mx-auto">
	<ShelfHeader shelf={data} />
</div>

{#if loading && !works}
	<div class="h-full flex flex-col items-center justify-center">
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	</div>
{:else if works}
	{#if works.items.length > 0}
		<div class="max-w-6xl mx-auto grid grid-cols-1 grid-cols-2 my-6">
			{#each works.items as work}
				<WorkCard {work}>
					<svelte:fragment slot="dropdown">
						<button type="button" on:click={() => removeFromShelf(work.id)}>
							<CloseLine class="mr-1" size="18px" />
							<span>Remove from shelf</span>
						</button>
					</svelte:fragment>
				</WorkCard>
			{/each}
		</div>
	{:else}
		<div class="h-full flex flex-col items-center justify-center">
			<div class="empty">
				<h3>You haven't added anything yet</h3>
				<p>Click the Shelves button on any work to add it to your shelves.</p>
			</div>
		</div>
	{/if}
{:else}
	<div class="empty">
		<h3>Something went wrong!</h3>
		<p>Try again in a little bit.</p>
	</div>
{/if}

{#if works && works.items.length > 0}
	<Paginator
		currPage={works.metadata.page}
		perPage={works.metadata.per}
		totalItems={works.metadata.total}
		on:change={(page) => changePage(page)}
	/>
{/if}
