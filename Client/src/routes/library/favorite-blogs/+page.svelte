<script lang="ts">
	import { onMount } from "svelte";
	import { account } from "$lib/state/account.state";
	import type { Paginate } from "$lib/util/types";
	import type { FavoriteBlog } from "$lib/models/content";
	import { BlogCard } from "$lib/ui/content";
	import { Paginator } from "$lib/ui/util";
	import toast  from "svelte-french-toast";

	let loading = false;
	let data: Paginate<FavoriteBlog> = null;

	onMount(async () => {
		await fetchData(1);
	});

	async function fetchData(page: number) {
		loading = true;
		const response = await fetch(`/api/content/blogs/fetch-favorites?profileId=${$account.currProfile?.id}&page=${page}&per=15`, {
			method: 'GET'
		});

		if (response.status === 200) {
			data = await response.json();
		} else {
			toast.error('Something went wrong fetching your favorite blogs!');
		}
		loading = false;
	}
</script>

{#if loading}
	<div class="h-full flex flex-col items-center justify-center">
		<div class="empty">
			<h3>Loading...</h3>
		</div>
	</div>
{:else if data}
	{#each data.items as favorite}
		<div class="grid grid-cols-1 lg:grid-cols-3 gap-4">
			<BlogCard showAvatar blog={favorite.blog} />
		</div>
		<Paginator
			currPage={data.metadata.page}
			perPage={data.metadata.per}
			totalItems={data.metadata.total}
			on:change={(page) => fetchData(page)}
		/>
	{:else}
		<div class="h-full flex flex-col items-center justify-center">
			<div class="empty">
				<h3>You haven't added any favorites yet</h3>
				<p>Click the Fave button on any blog and it'll show up here!</p>
			</div>
		</div>
	{/each}
{:else}
	<div class="empty">
		<h3>Something went wrong!</h3>
		<p>Try again in a little bit.</p>
	</div>
{/if}