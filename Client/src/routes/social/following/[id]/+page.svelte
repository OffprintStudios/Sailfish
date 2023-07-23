<script lang="ts">
	import type { Profile } from "$lib/models/accounts";
	import Avatar from "$lib/ui/util/Avatar.svelte";
	import { abbreviate, pluralize, slugify } from "$lib/util/functions";
	import NavLink from "$lib/ui/nav/NavLink.svelte";
	import { UserLine } from "svelte-remixicon";
	import { getReq, type ResponseError } from "$lib/http";
	import type { Paginate } from "$lib/util/types";
	import { ApprovalStatus, type Blog } from "$lib/models/content";
	import { app } from "$lib/state/app.state";
	import toast from "svelte-french-toast";
	import type { Work } from "$lib/models/content/works";
	import { BlogCard, WorkCard } from "$lib/ui/content";
	import { onMount } from "svelte";

	export let data: Profile;
	let loadingBlogs = false;
	let loadingWorks = false;
	let blogs: Paginate<Blog> = {
		items: [],
		metadata: {
			page: 1,
			per: 3,
			total: 0
		}
	};
	let works: Paginate<Work> = {
		items: [],
		metadata: {
			page: 1,
			per: 3,
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

<svelte:head>
	<title>New by {data.username}</title>
</svelte:head>

<div class="max-w-6xl mx-auto mb-6">
	<div class="flex items-center border-b pb-2 mb-6">
		<Avatar src={data.avatar} size="100px" />
		<div class="flex-1 ml-4">
			<h1 class="text-4xl">{data.username}</h1>
			<span
				class="flex items-center text-zinc-400 text-lg"
				style="font-family: var(--header-text);"
			>
				<span>{abbreviate(data.stats.works)} work{pluralize(data.stats.works)}</span>
				<span class="mx-1">•</span>
				<span>{abbreviate(data.stats.blogs)} blog{pluralize(data.stats.blogs)}</span>
			</span>
		</div>
		<NavLink href="/profile/{data.id}/{slugify(data.username)}">
			<UserLine class="link-icon" />
			<span class="link-name">Profile</span>
		</NavLink>
	</div>
	<div>
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
			{#if works.items.length === 0}
				<div class="empty">
					<h3>No works added</h3>
					<p>Well this is rather empty, isn't it?</p>
				</div>
			{:else}
				<div class="w-full grid grid-cols-1 lg:grid-cols-3">
					{#each works.items as work}
						<WorkCard {work} withDropdown={false} />
					{/each}
				</div>
			{/if}
			<div class="grid grid-cols-1 lg:grid-cols-3 border-t pt-6 mt-6">
				<BlogCard blog={blogs.items[0]} hasDropdown={false} />
			</div>
		{/if}
	</div>
</div>
