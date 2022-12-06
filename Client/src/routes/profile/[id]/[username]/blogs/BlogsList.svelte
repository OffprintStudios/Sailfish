<script lang="ts">
	import { onMount } from "svelte";
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

	export let profile: Profile;
	export let page = 1;
	export let per = 10;
	let blogs: Blog[] = [];
	let total = 1;

	onMount(async () => {
		await fetchBlogs();
	});

	async function fetchBlogs() {
		const response = await getReq<Paginate<Blog>>(
			`/blogs/fetch-blogs?` +
			`authorId=${profile.id}&` +
			`status=${ApprovalStatus.published}&` +
			`filter=${$app.filter}&` +
			`page=${page}&` +
			`per=${per}`);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			const result = response as Paginate<Blog>;
			blogs = result.items;
			page = result.metadata.page;
			per = result.metadata.per;
			total = result.metadata.total;
		}
	}
</script>

<div class="my-6 w-11/12 mx-auto">
	{#each blogs as blog}
		<div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
			<BlogCard blog={blog} />
		</div>
		<Paginator currPage={page} perPage={per} totalItems={total} />
	{:else}
		<div class="empty">
			<h3>No blogs yet</h3>
			<p>Check back later!</p>
		</div>
	{/each}
</div>
