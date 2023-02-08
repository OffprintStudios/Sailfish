<script lang="ts">
	import { onMount } from "svelte";
	import { page } from "$app/stores";
	import type { Blog } from "$lib/models/content";
	import { account } from "$lib/state/account.state";
	import { ApprovalStatus } from "$lib/models/content";
	import { ContentFilter } from "$lib/util/constants";
	import type { Paginate } from "$lib/util/types";
	import { BlogCard } from "$lib/ui/content";
	import toast from "svelte-french-toast";
	import { Paginator } from "$lib/ui/util";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import { goto } from "$app/navigation";

	let pageNum = +($page.url.searchParams.get("page") ?? "1");
	let perPage = +($page.url.searchParams.get("per") ?? "10");
	let blogs: Paginate<Blog> = {
		items: [],
		metadata: {
			page: pageNum,
			per: perPage,
			total: 0
		}
	};
	let loading = false;

	onMount(async () => {
		await fetchPending(pageNum);
	});

	async function fetchPending(newPage: number, updateQuery = false) {
		loading = true;
		pageNum = newPage;
		let query = new URLSearchParams($page.url.searchParams.toString());
		query.set("page", `${pageNum}`);
		query.set("per", `${perPage}`);
		const response = await getReq<Paginate<Blog>>(
			"/blogs/fetch?" +
				"authorId=" +
				$account.currProfile?.id +
				"&" +
				"status=" +
				ApprovalStatus.pending +
				"&" +
				"filter=" +
				ContentFilter.everything +
				"&" +
				"page=" +
				pageNum +
				"&" +
				"per=" +
				perPage
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			blogs = response as Paginate<Blog>;
			pageNum = blogs.metadata.page;
			perPage = blogs.metadata.per;
			if (updateQuery) {
				await goto(`?${query.toString()}`);
			}
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
		{#if blogs.items.length > 0}
			<div class="w-full lg:w-11/12 xl:w-full mx-auto grid grid-cols-1 lg:grid-cols-2 gap-4">
				{#each blogs as blog}
					<BlogCard {blog} />
				{/each}
			</div>
		{:else}
			<div class="empty">
				<h3>You haven't added anything yet.</h3>
				<p>Add a blog and it'll show up here.</p>
			</div>
		{/if}
		{#if blogs.items.length > 0}
			<Paginator
				currPage={pageNum}
				{perPage}
				totalItems={blogs.metadata.total}
				on:change={(event) => fetchPending(event.detail, true)}
			/>
		{/if}
	</div>
{/if}
