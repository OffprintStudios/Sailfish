<script lang="ts">
	import { onMount } from "svelte";
	import { account } from "$lib/state/account.state";
	import type { Paginate } from "$lib/util/types";
	import type { FavoriteBlog } from "$lib/models/content";
	import { BlogCard } from "$lib/ui/content";
	import { Paginator } from "$lib/ui/util";
	import { getReq } from "$lib/http";
	import type { ResponseError } from "$lib/http";
	import toast  from "svelte-french-toast";

	let loading = false;
	let blogs: Paginate<FavoriteBlog> = null;

	onMount(async () => {
		await loadFavorites(1);
	});

	async function loadFavorites(page: number) {
		loading = true;
		const response = await getReq<Paginate<FavoriteBlog>>(`/blogs/fetch-favorites?profileId=${$account.currProfile.id}&page=${page}&per=15`);
		if ((response as ResponseError).error) {
			const errorMsg = response as ResponseError;
			toast.error(errorMsg.message);
		} else {
			blogs = response as Paginate<FavoriteBlog>;
		}
		loading = false;
	}
</script>

{#if loading && !blogs}
	<div class="h-full flex flex-col items-center justify-center">
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	</div>
{:else if blogs}
	{#if blogs.items.length > 0}
		<div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
			{#each blogs.items as favorite}
				<BlogCard showAvatar blog={favorite} />
			{/each}
		</div>
	{:else}
		<div class="h-full flex flex-col items-center justify-center">
			<div class="empty">
				<h3>You haven't added any favorites yet</h3>
				<p>Click the Fave button on any blog and it'll show up here!</p>
			</div>
		</div>
	{/if}
	{#if loading}
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	{/if}
{:else}
	<div class="empty">
		<h3>Something went wrong!</h3>
		<p>Try again in a little bit.</p>
	</div>
{/if}

{#if blogs && blogs.items.length > 0}
	<Paginator
		currPage={blogs.metadata.page}
		perPage={blogs.metadata.per}
		totalItems={blogs.metadata.total}
		on:change={(page) => loadFavorites(page)}
	/>
{/if}
