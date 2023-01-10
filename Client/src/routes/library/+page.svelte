<script lang="ts">
	import { page } from "$app/stores";
	import { onMount } from "svelte";
	import { getReq, delReq, type ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { Work } from "$lib/models/content/works";
	import { AddToShelfPrompt, WorkCard } from "$lib/ui/content";
	import { Paginator } from "$lib/ui/util";
	import toast from "svelte-french-toast";
	import { account } from "$lib/state/account.state";
	import { BarChart2Line, CloseLine, Loader5Line } from "svelte-remixicon";
	import { openPopup } from "$lib/ui/popup";

	let loading = false;
	let removing = false;
	let currPage = +($page.url.searchParams.get("page") ?? "1");
	let perPage = +($page.url.searchParams.get("per") ?? "21");
	let works: Paginate<Work> = {
		items: [],
		metadata: {
			page: currPage,
			per: perPage,
			total: 0
		}
	};

	onMount(async () => {
		await loadLibrary(1);
	});

	async function loadLibrary(newPage: number) {
		loading = true;
		currPage = newPage;
		const response = await getReq<Paginate<Work>>(
			`/library/fetch-all?profileId=${$account.currProfile?.id}&page=${currPage}&per=${perPage}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			works = response as Paginate<Work>;
		}
		loading = false;
	}

	async function removeOne(id: string) {
		removing = true;
		const response = await delReq<void>(
			`/library/remove-one?workId=${id}&profileId=${$account.currProfile?.id}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			await loadLibrary(currPage);
		}
		removing = false;
	}

	async function checkShelves(id: string) {
		openPopup(AddToShelfPrompt, null, { workId: id });
	}
</script>

{#if loading && !works}
	<div class="h-full flex flex-col items-center justify-center">
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	</div>
{:else if works}
	{#if works.items.length > 0}
		<div class="max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-4">
			{#each works.items as favorite}
				<WorkCard work={favorite}>
					<svelte:fragment slot="dropdown">
						<button type="button" on:click={() => checkShelves(favorite.id)}>
							<BarChart2Line size="18px" class="mr-1" />
							<span>Shelves</span>
						</button>
						<div class="divider"><!--spacer--></div>
						<button type="button" disabled={removing} on:click={removeOne(favorite.id)}>
							{#if removing}
								<Loader5Line class="mr-1 animate-spin" size="18px" />
								<span>Removing...</span>
							{:else}
								<CloseLine class="mr-1" size="18px" />
								<span>Remove from library</span>
							{/if}
						</button>
					</svelte:fragment>
				</WorkCard>
			{/each}
		</div>
	{:else}
		<div class="h-full flex flex-col items-center justify-center">
			<div class="empty">
				<h3>You haven't added anything yet</h3>
				<p>Click the Add to Library button on any work and it'll show up here!</p>
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

{#if works && works.items.length > 0}
	<Paginator
		{currPage}
		{perPage}
		totalItems={works.metadata.total}
		on:change={(event) => loadLibrary(event.detail)}
	/>
{/if}
