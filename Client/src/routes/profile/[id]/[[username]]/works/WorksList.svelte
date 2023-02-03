<script lang="ts">
	import { onMount } from "svelte";
	import type { Work } from "$lib/models/content/works";
	import { app } from "$lib/state/app.state";
	import type { Paginate } from "$lib/util/types";
	import { Paginator } from "$lib/ui/util";
	import { WorkCard } from "$lib/ui/content";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import type { Profile } from "$lib/models/accounts";
	import toast from "svelte-french-toast";
	import { page } from "$app/stores";

	export let profile: Profile;
	let pageNum = +($page.url.searchParams.get("page") ?? "1");
	let perPage = +($page.url.searchParams.get("per") ?? "10");
	let works: Work[] = [];
	let total = 1;

	onMount(async () => {
		await fetchWorks(pageNum);
	});

	async function fetchWorks(newPage: number) {
		pageNum = newPage;
		$page.url.searchParams.set("page", `${pageNum}`);
		$page.url.searchParams.set("per", `${perPage}`);
		const response = await getReq<Paginate<Work>>(
			`/works/fetch-works?` +
				`authorId=${profile.id}&` +
				`published=${true}&` +
				`filter=${$app.filter}&` +
				`page=${pageNum}&` +
				`per=${perPage}`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			const result = response as Paginate<Work>;
			works = result.items;
			pageNum = result.metadata.page;
			perPage = result.metadata.per;
			total = result.metadata.total;
		}
	}
</script>

<div class="my-6 w-11/12 lg:w-full mx-auto">
	{#if works.length > 0}
		<div
			class="w-full lg:w-11/12 xl:w-full mx-auto grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4"
		>
			{#each works as work}
				<WorkCard {work} withDropdown={false} />
			{/each}
		</div>
	{:else}
		<div class="empty">
			<h3>No works yet</h3>
			<p>Check back later!</p>
		</div>
	{/if}
	{#if works.length > 0}
		<Paginator
			currPage={pageNum}
			{perPage}
			totalItems={total}
			on:change={(event) => fetchWorks(event.detail)}
		/>
	{/if}
</div>
