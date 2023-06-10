<script lang="ts">
	import { onMount } from "svelte";
	import { getReq, type ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { ReadingHistory } from "$lib/models/content/library";
	import { account } from "$lib/state/account.state";
	import { WorkCard } from "../../content";
	import toast from "svelte-french-toast";
	import { guide, prevPage } from "$lib/ui/guide";
	import { Button } from "$lib/ui/util";
	import { ArrowLeftSLine } from "svelte-remixicon";

	let loading = false;
	let history: Paginate<ReadingHistory> = {
		items: [],
		metadata: {
			page: 1,
			per: 5,
			total: 0
		}
	};

	onMount(async () => {
		await loadHistory();
	});

	async function loadHistory() {
		loading = true;
		const response = await getReq<Paginate<ReadingHistory>>(
			`/history/fetch-all?profileId=${$account.currProfile?.id}&page=1&per=5`
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

<div class="panel-container">
	{#if $guide.routing.length > 1}
		<div class="topbar">
			<div class="left-button">
				<Button on:click={prevPage}>
					<ArrowLeftSLine class="button-icon" />
					<span class="button-text">Account</span>
				</Button>
			</div>
		</div>
	{/if}

	{#if loading && !history}
		<div class="h-full flex flex-col items-center justify-center">
			<div class="empty">
				<h3>Loading...</h3>
			</div>
		</div>
	{:else if history}
		{#if history.items.length > 0}
			<div class="grid grid-cols-1 gap-4 mx-4">
				{#each history.items as item}
					<WorkCard work={item.work} withDropdown={false} />
				{/each}
			</div>
		{:else}
			<div class="h-full flex flex-col items-center justify-center">
				<div class="empty">
					<h3>Nothing read yet</h3>
					<p>The last five things you've read<br />will show up here.</p>
					<div class="my-4"><!--spacer--></div>
					<p>For your full reading history,<br />go to Library > Reading History</p>
				</div>
			</div>
		{/if}
	{:else}
		<div class="empty">
			<h3>Something went wrong!</h3>
			<p>Try again in a little bit.</p>
		</div>
	{/if}
</div>

<style lang="scss">
	@use "../Guide";
</style>
