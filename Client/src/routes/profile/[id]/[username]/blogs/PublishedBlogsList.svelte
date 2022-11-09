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

	let blogs: Blog[] = [];
	let pageNum = $page.url.searchParams.has("page") ? $page.url.searchParams.get("page") : 1;
	let per = $page.url.searchParams.has("per") ? $page.url.searchParams.get("per") : 10;
	let total = 1;
	let loading = false;

	onMount(async () => {
		await fetchPublished();
	});

	async function fetchPublished() {
		loading = true;

		const response = await fetch(
			'/api/content/blogs/fetch-blogs?' +
			'profileId=' + $account.currProfile.id + '&' +
			'status=' + ApprovalStatus.published + '&' +
			'filter=' + ContentFilter.everything + '&' +
			'page=' + pageNum + '&' +
			'per=' + per
		);

		if (response.status === 200) {
			const result: Paginate<Blog> = await response.json();
			blogs = result.items;
			pageNum = result.metadata.page;
			per = result.metadata.per;
			total = result.metadata.total;
			loading = false;
		} else {
			toast.error("Something went wrong! Try again in a little bit.");
			loading = false;
		}
	}
</script>

{#if loading}
	<div class="empty">
		<h3>Loading...</h3>
	</div>
{:else}
	<div class="my-6 w-11/12 mx-auto">
		{#each blogs as blog}
			<div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
				<BlogCard blog={blog} />
			</div>
			<Paginator currPage={pageNum} perPage={per} totalItems={total} />
		{:else}
			<div class="empty">
				<h3>You haven't added anything yet.</h3>
				<p>Add a blog and it'll show up here.</p>
			</div>
		{/each}
	</div>
{/if}