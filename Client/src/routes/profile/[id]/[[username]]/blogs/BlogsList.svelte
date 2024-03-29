<script lang="ts">
	import { onMount } from "svelte";
	import { page } from "$app/stores";
	import type { Blog } from "$lib/models/content";
	import { ApprovalStatus } from "$lib/models/content";
	import { app } from "$lib/state/app.state";
	import type { Paginate } from "$lib/util/types";
	import { Paginator } from "$lib/ui/util";
	import { BlogCard } from "$lib/ui/content";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import type { Profile } from "$lib/models/accounts";
	import toast from "svelte-french-toast";
	import { goto } from "$app/navigation";

	export let profile: Profile;
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
		await fetchBlogs(pageNum);
	});

	async function fetchBlogs(newPage: number, updateQuery = false) {
		loading = true;
		pageNum = newPage;
		let query = new URLSearchParams($page.url.searchParams.toString());
		query.set("page", `${pageNum}`);
		query.set("per", `${perPage}`);
		const response = await getReq<Paginate<Blog>>(
			`/blogs/fetch?` +
				`authorId=${profile.id}&` +
				`status=${ApprovalStatus.published}&` +
				`filter=${$app.filter}&` +
				`page=${newPage}&` +
				`per=${perPage}`
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

<div class="my-6 w-11/12 lg:w-full mx-auto">
	{#if blogs.metadata.total > 0}
		<div class="w-full lg:w-11/12 xl:w-full mx-auto grid grid-cols-1 lg:grid-cols-2 gap-4">
			{#each blogs.items as blog}
				<BlogCard {blog} hasDropdown={false} />
			{/each}
		</div>
	{:else}
		<div class="empty">
			<h3>No blogs yet</h3>
			<p>Check back later!</p>
		</div>
	{/if}
	{#if blogs.metadata.total > 0}
		<Paginator
			currPage={pageNum}
			{perPage}
			totalItems={blogs.metadata.total}
			on:change={(event) => fetchBlogs(event.detail, true)}
			{loading}
		/>
	{/if}
</div>
