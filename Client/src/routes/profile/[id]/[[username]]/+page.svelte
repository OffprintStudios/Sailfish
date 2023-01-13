<script lang="ts">
	import { onMount } from "svelte";
	import type { Profile } from "$lib/models/accounts";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import type { Blog } from "$lib/models/content";
	import type { Work } from "$lib/models/content/works";
	import { WorkCard, BlogCard } from "$lib/ui/content";
	import { ApprovalStatus } from "$lib/models/content";
	import { app } from "$lib/state/app.state";
	import toast from "svelte-french-toast";

	export let data: Profile;
	let loadingBlogs = false;
	let loadingWorks = false;
	let blogs: Paginate<Blog> = {
		items: [],
		metadata: {
			page: 1,
			per: 1,
			total: 0
		}
	};
	let works: Paginate<Work> = {
		items: [],
		metadata: {
			page: 1,
			per: 4,
			total: 0
		}
	};

	onMount(async () => {
		await loadLatestBlog();
		await loadLatestWorks();
	});

	async function loadLatestBlog() {
		loadingBlogs = true;
		const response = await getReq<Paginate<Blog>>(
			`/blogs/fetch?` +
				`authorId=${data.id}&` +
				`status=${ApprovalStatus.published}&` +
				`filter=${$app.filter}&` +
				`page=1&` +
				`per=1`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			blogs = response as Paginate<Blog>;
		}
		loadingBlogs = false;
	}

	async function loadLatestWorks() {
		loadingWorks = true;
		const response = await getReq<Paginate<Work>>(
			`/works/fetch-works?` +
				`authorId=${data.id}&` +
				`published=${true}&` +
				`filter=${$app.filter}&` +
				`page=1&` +
				`per=4`
		);
		if ((response as ResponseError).error) {
			const error = response as ResponseError;
			toast.error(error.message);
		} else {
			works = response as Paginate<Work>;
		}
		loadingWorks = false;
	}
</script>

<div class="w-11/12 lg:w-full mx-auto">
	{#if loadingBlogs || loadingWorks}
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	{:else if blogs.items.length === 0 && works.items.length === 0}
		<div class="empty">
			<h3>No content added</h3>
			<p>Well this is rather empty, isn't it?</p>
		</div>
	{:else}
		{#if blogs.items[0]}
			<div class="lg:px-8 mx-auto border-b pb-6 mb-6">
				<BlogCard blog={blogs.items[0]} hasDropdown={false} />
			</div>
		{/if}
		{#if works.items.length === 0}
			<div class="empty">
				<h3>No works added</h3>
				<p>Well this is rather empty, isn't it?</p>
			</div>
		{:else}
			<div class="w-full grid grid-cols-1 lg:grid-cols-2 lg:grid-rows-2 gap-4">
				{#each works.items as work}
					<WorkCard {work} withDropdown={false} />
				{/each}
			</div>
		{/if}
	{/if}
</div>
