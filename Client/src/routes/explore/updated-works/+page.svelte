<script lang="ts">
	import type { ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { Work } from "$lib/models/content/works";
	import { page } from "$app/stores";
	import { getReq } from "$lib/http";
	import { app } from "$lib/state/app.state";
	import { WorkCard } from "$lib/ui/content";
	import { Paginator } from "$lib/ui/util";
	import toast from "svelte-french-toast";

	export let data: Paginate<Work>;
	let loading = false;

	$: currPage = +($page.url.searchParams.get("page") ?? "1");
	$: perPage = +($page.url.searchParams.get("per") ?? "24");

	async function fetchPage(pageNum: number) {
		loading = true;
		$page.url.searchParams.set("page", `${pageNum}`);
		const response = await getReq<Paginate<Work>>(
			`/explore/updated-works?filter=${$app.filter}?page=${currPage}&per=${perPage}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			data = response as Paginate<Work>;
		}
		loading = false;
	}
</script>

<svelte:head>
	<title>Updated Works &mdash; Offprint</title>
</svelte:head>

{#if data.metadata.total > 0}
	<div class="grid grid-cols-1 lg:grid-cols-3 gap-4 w-full">
		{#each data.items as work}
			<WorkCard {work} withDropdown={false} />
		{/each}
	</div>
{:else}
	<div class="empty">
		<h3>Nothing's been updated yet</h3>
		<p>But that'll probably take care of itself shortly.</p>
	</div>
{/if}

{#if data.metadata.total > 0}
	<Paginator
		{currPage}
		{perPage}
		totalItems={data.metadata.total}
		on:change={(event) => fetchPage(event.detail)}
	/>
{/if}
