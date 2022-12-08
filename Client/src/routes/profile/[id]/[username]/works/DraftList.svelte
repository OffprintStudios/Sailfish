<script lang="ts">
	import { onMount } from "svelte";
	import { page } from "$app/stores";
	import type { Work } from "$lib/models/content/works";
	import { ContentFilter } from "$lib/util/constants";
	import { account } from "$lib/state/account.state";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import { Paginator } from "$lib/ui/util";
	import { WorkCard } from "$lib/ui/content";
	import toast from "svelte-french-toast";

	let works: Work[] = [];
	let pageNum = $page.url.searchParams.has("page") ? $page.url.searchParams.get("page") : 1;
	let per = $page.url.searchParams.has("per") ? $page.url.searchParams.get("per") : 10;
	let total = 1;
	let loading = false;

	onMount(async () => {
		await fetchDrafts();
	})

	async function fetchDrafts() {
		loading = true;
		const response = await getReq<Paginate<Work>>(
			`/works/fetch-works?` +
			`authorId=${$account.currProfile.id}&` +
			`published=${false}&` +
			`filter=${ContentFilter.everything}&` +
			`page=${pageNum}&` +
			`per=${per}&`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			const result = response as Paginate<Work>;
			works = result.items;
			pageNum = result.metadata.page;
			per = result.metadata.per;
			total = result.metadata.total;
		}
		loading = false;
	}
</script>

{#if loading}
	<div class="empty">
		<h3>Loading...</h3>
	</div>
{:else}
	<div class="my-6 w-11/12 mx-auto">
		{#each works as work}
			<div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
				<WorkCard work={work} />
			</div>
		{:else}
			<div class="empty">
				<h3>You haven't added anything yet.</h3>
				<p>Add a work and it'll show up here.</p>
			</div>
		{/each}
	</div>
{/if}

{#if works.length > 0}
	<Paginator currPage={pageNum} perPage={per} totalItems={total} />
{/if}